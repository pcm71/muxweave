/*
 * pmux_analyze —— 只读分析 pass：统计 $pmux / $mux 的位宽、分支数、选择信号身份与跨位重复模式。
 *
 * 第 1 周目标（方案「第 4～5 天：写 PMUX 分析器」）：
 *   - 列出每个 PMUX 的 W（位宽）、K（分支数）、控制来源、各分支数据源；
 *   - 按位对数据源聚类，识别"多个分支共用同一数据位"的重复模式；
 *   - 把相邻且模式一致的位合并为位片（SlicePattern）；
 *   - 统计跨位共享机会（同一分组模式被多少位使用）——这是主算法的机会来源；
 *   - 输出机器可读 JSON + 人可读摘要表；**不修改网表**。
 *
 * 用法：
 *   yosys -p "read_verilog x.v; hierarchy -top top; proc; pmux_analyze -json a.json"
 *   yosys -p "...; pmux_analyze -table -max-report 20"
 *
 * 重要：本文件是按 Yosys pass 通用框架写的骨架。接入 0.69 时请以 passes/ 下现有 pass
 * 为模板核对 execute() 签名与 ID::A/ID::B/ID::S/ID::Y 的可用性（见 plugin/INTEGRATION.md）。
 */

#include "kernel/register.h"
#include "kernel/log.h"
#include "kernel/rtlil.h"
#include "kernel/sigtools.h"

#include <algorithm>
#include <fstream>
#include <map>
#include <set>
#include <sstream>
#include <string>
#include <vector>

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

/* ---------- 小工具 ---------- */

static std::string json_escape(const std::string &s)
{
    std::string o;
    o.reserve(s.size() + 8);
    for (char c : s) {
        switch (c) {
            case '"':  o += "\\\""; break;
            case '\\': o += "\\\\"; break;
            case '\n': o += "\\n";  break;
            case '\r': o += "\\r";  break;
            case '\t': o += "\\t";  break;
            default:
                if ((unsigned char)c < 0x20) {
                    char buf[8];
                    snprintf(buf, sizeof(buf), "\\u%04x", (unsigned char)c);
                    o += buf;
                } else {
                    o += c;
                }
        }
    }
    return o;
}

/* 一个数据位的"分支分组模式"：把 K 个分支的数据源按身份聚类后写成字符串，
   例如 "A|A|B|B" 表示分支 0/1 共用数据源 A，分支 2/3 共用数据源 B。 */
struct BitPattern {
    std::string key;        // 模式字符串（用于比较与统计）
    int distinct = 0;       // 不同数据源个数
    int reused_groups = 0;  // 出现次数 >= 2 的分组个数
    int reused_bits = 0;    // 落在这些分组里的分支数
};

static BitPattern analyze_bit(const std::vector<SigBit> &sources)
{
    std::map<SigBit, int> group_of;
    std::vector<int> ids;
    for (const auto &b : sources) {
        auto it = group_of.find(b);
        if (it == group_of.end()) {
            int id = (int)group_of.size();
            group_of.emplace(b, id);
            ids.push_back(id);
        } else {
            ids.push_back(it->second);
        }
    }

    std::map<int, int> counts;
    for (int id : ids) counts[id]++;

    BitPattern p;
    p.distinct = (int)group_of.size();
    std::ostringstream key;
    for (size_t i = 0; i < ids.size(); i++) {
        if (i) key << "|";
        key << "g" << ids[i];
    }
    p.key = key.str();
    for (auto &kv : counts) {
        if (kv.second >= 2) {
            p.reused_groups++;
            p.reused_bits += kv.second;
        }
    }
    return p;
}

/* 结构摘要：用于"参考设计始终可恢复"的可审计凭据（弱哈希，仅证明未改动） */
static std::string structural_digest(RTLIL::Design *design)
{
    uint64_t h = 1469598103934665603ULL; // FNV-1a 64
    auto mix = [&h](const std::string &s) {
        for (unsigned char c : s) { h ^= c; h *= 1099511628211ULL; }
    };
    for (auto module : design->selected_modules()) {
        mix(module->name.str());
        for (auto cell : module->selected_cells()) {
            mix(cell->type.str());
            mix(cell->name.str());
            for (auto &conn : cell->connections())
                mix(conn.first.str() + log_signal(conn.second));
        }
    }
    char buf[32];
    snprintf(buf, sizeof(buf), "%016llx", (unsigned long long)h);
    return std::string(buf);
}

/* ---------- pass ---------- */

struct PmuxAnalyzePass : public Pass {
    PmuxAnalyzePass() : Pass("pmux_analyze", "analyze $pmux/$mux cells: width, branches, select identity, cross-bit reuse") {}

    void help() override
    {
        log("\n");
        log("    pmux_analyze [options]\n");
        log("\n");
        log("只读分析：统计设计中的 $pmux / $mux 目标、位宽 W、分支数 K、选择信号身份，\n");
        log("并按位聚类数据源，报告跨位重复模式与共享机会。不改变网表。\n");
        log("\n");
        log("    -json <file>\n");
        log("        把机器可读结果写入 JSON 文件。\n");
        log("\n");
        log("    -table\n");
        log("        在终端打印人可读的分析表。\n");
        log("\n");
        log("    -max-report <n>\n");
        log("        终端表格最多列出前 n 个 cell（默认 10，0 表示全部）。\n");
        log("\n");
        log("示例：\n");
        log("    read_verilog x.v; hierarchy -top top; proc\n");
        log("    pmux_analyze -table -json analyze.json\n");
        log("\n");
    }

    void execute(std::vector<std::string> args, RTLIL::Design *design) override
    {
        std::string json_file;
        bool want_table = false;
        int max_report = 10;

        size_t argidx;
        for (argidx = 1; argidx < args.size(); argidx++) {
            std::string a = args[argidx];
            if (a == "-json" && argidx + 1 < args.size()) { json_file = args[++argidx]; continue; }
            if (a == "-table") { want_table = true; continue; }
            if (a == "-max-report" && argidx + 1 < args.size()) { max_report = atoi(args[++argidx].c_str()); continue; }
            break;
        }
        extra_args(args, argidx, design);

        int total_pmux = 0, total_mux = 0, cells_with_reuse = 0;
        int global_max_w = 0, global_max_k = 0, shared_pattern_bits_total = 0;
        int bits_with_reuse_total = 0;

        std::ostringstream out;
        out << "{\n";
        out << "  \"creator\": \"pmux_analyze\",\n";
        out << "  \"yosys_version\": \"" << json_escape(yosys_version_str) << "\",\n";
        out << "  \"digest\": \"" << structural_digest(design) << "\",\n";
        out << "  \"modules\": [\n";

        bool first_module = true;
        for (auto module : design->selected_modules()) {
            SigMap sigmap(module);

            struct SlicePat {
                int start = 0;
                int width = 0;
                std::string pattern;
                bool reuse = false;   // 该位片是否含分支复用（真正的机会来源）
            };
            struct CellInfo {
                std::string name, type;
                int width = 0, branches = 0;
                std::vector<std::string> select;
                int distinct_bits = 0, reused_bits = 0;
                std::vector<SlicePat> slices;
                std::string opportunity;
            };
            std::vector<CellInfo> infos;

            for (auto cell : module->selected_cells()) {
                bool is_pmux = cell->type == ID($pmux);
                bool is_mux  = cell->type == ID($mux);
                if (!is_pmux && !is_mux) continue;

                SigSpec a = sigmap(cell->getPort(ID::A));
                SigSpec b = sigmap(cell->getPort(ID::B));
                SigSpec s = is_pmux ? sigmap(cell->getPort(ID::S)) : SigSpec();

                int W = a.size();
                int K = is_pmux ? s.size() : 1;
                if (W <= 0) continue;
                if (is_mux && b.size() < W) continue;
                if (is_pmux && (K <= 0 || b.size() < W * K)) continue;

                CellInfo ci;
                ci.name = cell->name.str();
                ci.type = is_pmux ? "$pmux" : "$mux";
                ci.width = W;
                ci.branches = K;
                for (auto bit : s) ci.select.push_back(log_signal(bit));

                /* 逐位分析 */
                std::vector<BitPattern> pats(W);
                for (int j = 0; j < W; j++) {
                    std::vector<SigBit> sources;
                    sources.reserve(K);
                    for (int i = 0; i < K; i++)
                        sources.push_back(b[i * W + j]);
                    pats[j] = analyze_bit(sources);
                    if (pats[j].reused_groups > 0) ci.reused_bits++;
                    else ci.distinct_bits++;
                }

                /* 统计哪些"完整模式"被多个位共用（跨位共享机会） */
                std::map<std::string, int> reuse_pattern_uses;
                for (int j = 0; j < W; j++)
                    if (pats[j].reused_groups > 0) reuse_pattern_uses[pats[j].key]++;
                int shared_bits = 0;
                for (int j = 0; j < W; j++)
                    if (pats[j].reused_groups > 0 && reuse_pattern_uses[pats[j].key] >= 2)
                        shared_bits++;

                /* 相邻同模式位合并为位片 */
                for (int j = 0; j < W; ) {
                    int k = j;
                    while (k + 1 < W && pats[k + 1].key == pats[j].key) k++;
                    SlicePat sp;
                    sp.start = j;
                    sp.width = k - j + 1;
                    sp.pattern = pats[j].key;
                    sp.reuse = (pats[j].reused_groups > 0);
                    ci.slices.push_back(sp);
                    j = k + 1;
                }

                ci.opportunity = (ci.reused_bits > 0) ? (ci.reused_bits >= (W + 1) / 2 ? "high" : "medium") : "none";
                if (ci.reused_bits > 0) cells_with_reuse++;
                bits_with_reuse_total += ci.reused_bits;
                shared_pattern_bits_total += shared_bits;

                if (is_pmux) total_pmux++; else total_mux++;
                global_max_w = std::max(global_max_w, W);
                global_max_k = std::max(global_max_k, K);
                infos.push_back(ci);
            }

            if (infos.empty() && !first_module) continue;

            if (!first_module) out << ",\n";
            first_module = false;
            out << "    {\n";
            out << "      \"name\": \"" << json_escape(module->name.str()) << "\",\n";
            out << "      \"cells\": [\n";
            for (size_t i = 0; i < infos.size(); i++) {
                const auto &ci = infos[i];
                out << "        {\n";
                out << "          \"cell\": \"" << json_escape(ci.name) << "\",\n";
                out << "          \"type\": \"" << ci.type << "\",\n";
                out << "          \"width\": " << ci.width << ",\n";
                out << "          \"branches\": " << ci.branches << ",\n";
                out << "          \"select\": [";
                for (size_t t = 0; t < ci.select.size(); t++) {
                    if (t) out << ", ";
                    out << "\"" << json_escape(ci.select[t]) << "\"";
                }
                out << "],\n";
                out << "          \"bits_with_reuse\": " << ci.reused_bits << ",\n";
                out << "          \"bits_distinct\": " << ci.distinct_bits << ",\n";
                out << "          \"slice_patterns\": [";
                for (size_t t = 0; t < ci.slices.size(); t++) {
                    if (t) out << ", ";
                    out << "{\"start\": " << ci.slices[t].start
                        << ", \"width\": " << ci.slices[t].width
                        << ", \"reuse\": " << (ci.slices[t].reuse ? "true" : "false")
                        << ", \"pattern\": \"" << json_escape(ci.slices[t].pattern) << "\"}";
                }
                out << "],\n";
                out << "          \"opportunity\": \"" << ci.opportunity << "\"\n";
                out << "        }" << (i + 1 < infos.size() ? "," : "") << "\n";
            }
            out << "      ]\n";
            out << "    }";

            if (want_table) {
                log("\n");
                log("== 模块 %s：%d 个目标 cell ==\n", module->name.c_str(), (int)infos.size());
                log("%-28s %-6s %4s %4s %6s %6s  %s\n", "cell", "type", "W", "K", "复用位", "位片数", "机会");
                int shown = 0;
                for (const auto &ci : infos) {
                    if (max_report > 0 && shown >= max_report) { log("  ...（其余省略，用 -max-report 0 显示全部）\n"); break; }
                    log("%-28s %-6s %4d %4d %6d %6d  %s\n", ci.name.c_str(), ci.type.c_str(),
                        ci.width, ci.branches, ci.reused_bits, (int)ci.slices.size(), ci.opportunity.c_str());
                    shown++;
                }
            }
        }

        out << "\n  ],\n";
        out << "  \"summary\": {\n";
        out << "    \"pmux_cells\": " << total_pmux << ",\n";
        out << "    \"mux_cells\": " << total_mux << ",\n";
        out << "    \"cells_with_reuse\": " << cells_with_reuse << ",\n";
        out << "    \"bits_with_reuse_total\": " << bits_with_reuse_total << ",\n";
        out << "    \"shared_pattern_bits\": " << shared_pattern_bits_total << ",\n";
        out << "    \"max_width\": " << global_max_w << ",\n";
        out << "    \"max_choices\": " << global_max_k << "\n";
        out << "  }\n";
        out << "}\n";

        log("\n");
        log("pmux_analyze: $pmux=%d, $mux=%d, 有复用模式的 cell=%d, 复用位总数=%d, 跨位共享位=%d, max W=%d, max K=%d\n",
            total_pmux, total_mux, cells_with_reuse, bits_with_reuse_total, shared_pattern_bits_total,
            global_max_w, global_max_k);
        if (total_pmux + total_mux == 0)
            log("pmux_analyze: 没有目标结构 —— 请确认读入阶段与 hierarchy 之后是否真的留下了 $pmux/$mux。\n");

        if (!json_file.empty()) {
            std::ofstream f(json_file);
            if (!f) log_error("无法写入 %s\n", json_file.c_str());
            f << out.str();
            f.close();
            log("pmux_analyze: 已写出 %s\n", json_file.c_str());
        }
    }
} PmuxAnalyzePass;

PRIVATE_NAMESPACE_END
