/*
 * pmux_opt —— 优化 pass 骨架（第 1 周：可调用、可退出、默认不改结构）。
 *
 * 第 1 周只要求"命令可调用且不破坏流程"，因此本骨架的行为是：
 *   1. 复用 pmux_analyze 的机会统计（跨位分组共享机会）；
 *   2. 输出一条可追溯的运行记录（JSON）：规则、候选、映射收益、验证状态、回退原因；
 *   3. **不做任何结构变换**，明确报告 fallback=true —— 参考设计始终可恢复。
 *
 * 第 3～5 周再按方案第 7、8 节接入：
 *   C0 保留原结构 / C1 位片分组＋共享选择子表达式 / C2 受控层次结构 / C3 可选二进制译码，
 *   并对每个候选执行「固定后端映射 → 比较 → 形式等价 → 择优或回退」。
 *
 * 用法：
 *   yosys -p "read_verilog x.v; hierarchy -top top; proc; pmux_opt -json opt.json"
 *   yosys -p "...; pmux_opt -rule group_shared_select -json opt.json"
 */

#include "kernel/register.h"
#include "kernel/log.h"
#include "kernel/rtlil.h"
#include "kernel/sigtools.h"

#include <fstream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

USING_YOSYS_NAMESPACE
PRIVATE_NAMESPACE_BEGIN

static std::string json_escape_opt(const std::string &s)
{
    std::string o;
    for (char c : s) {
        switch (c) {
            case '"':  o += "\\\""; break;
            case '\\': o += "\\\\"; break;
            case '\n': o += "\\n";  break;
            case '\r': o += "\\r";  break;
            case '\t': o += "\\t";  break;
            default:   o += c;
        }
    }
    return o;
}

static std::string digest_of(RTLIL::Design *design)
{
    uint64_t h = 1469598103934665603ULL;
    auto mix = [&h](const std::string &s) { for (unsigned char c : s) { h ^= c; h *= 1099511628211ULL; } };
    for (auto module : design->selected_modules()) {
        mix(module->name.str());
        for (auto cell : module->selected_cells()) {
            mix(cell->type.str());
            for (auto &conn : cell->connections()) mix(conn.first.str() + log_signal(conn.second));
        }
    }
    char buf[32];
    snprintf(buf, sizeof(buf), "%016llx", (unsigned long long)h);
    return std::string(buf);
}

struct PmuxOptPass : public Pass {
    PmuxOptPass() : Pass("pmux_opt", "PMUX structure-sharing optimizer (week-1 skeleton: analyze + safe fallback)") {}

    void help() override
    {
        log("\n");
        log("    pmux_opt [options]\n");
        log("\n");
        log("PMUX 结构共享优化入口。第 1 周为骨架版本：只统计机会并记录运行，不改变网表，\n");
        log("并显式报告 fallback=true（保留参考设计）。\n");
        log("\n");
        log("    -json <file>\n");
        log("        输出运行记录 JSON（含规则、候选、回退原因、结构摘要）。\n");
        log("\n");
        log("    -rule <name>\n");
        log("        指定要启用的规则名（可多次）。第 1 周只接受 analyze_only；\n");
        log("        其余规则名会被记录为 unimplemented 并回退。\n");
        log("\n");
        log("    -budget-ms <n>\n");
        log("        搜索预算（毫秒）。第 1 周仅记录，不参与决策。\n");
        log("\n");
        log("    -quiet\n");
        log("        减少终端输出。\n");
        log("\n");
    }

    void execute(std::vector<std::string> args, RTLIL::Design *design) override
    {
        std::string json_file;
        std::vector<std::string> rules;
        long budget_ms = 0;
        bool quiet = false;

        size_t argidx;
        for (argidx = 1; argidx < args.size(); argidx++) {
            std::string a = args[argidx];
            if (a == "-json" && argidx + 1 < args.size()) { json_file = args[++argidx]; continue; }
            if (a == "-rule" && argidx + 1 < args.size()) { rules.push_back(args[++argidx]); continue; }
            if (a == "-budget-ms" && argidx + 1 < args.size()) { budget_ms = atol(args[++argidx].c_str()); continue; }
            if (a == "-quiet") { quiet = true; continue; }
            break;
        }
        extra_args(args, argidx, design);

        const std::string ref_digest = digest_of(design);

        /* --- 机会统计（沿用 pmux_analyze 的口径，第 1 周只做统计） --- */
        int pmux_count = 0, mux_count = 0, cells_with_reuse = 0, shared_bits_total = 0;
        int bits_with_reuse_total = 0;
        int max_w = 0, max_k = 0;

        for (auto module : design->selected_modules()) {
            SigMap sigmap(module);
            for (auto cell : module->selected_cells()) {
                bool is_pmux = cell->type == ID($pmux);
                bool is_mux  = cell->type == ID($mux);
                if (!is_pmux && !is_mux) continue;

                SigSpec a = sigmap(cell->getPort(ID::A));
                SigSpec b = sigmap(cell->getPort(ID::B));
                int W = a.size();
                int K = is_pmux ? (int)sigmap(cell->getPort(ID::S)).size() : 1;
                if (W <= 0 || K <= 0 || (int)b.size() < W * K) continue;

                if (is_pmux) pmux_count++; else mux_count++;
                max_w = std::max(max_w, W);
                max_k = std::max(max_k, K);

                std::map<std::string, int> reuse_pattern_uses;
                std::vector<std::string> keys(W);
                std::vector<bool> bit_has_reuse(W, false);
                for (int j = 0; j < W; j++) {
                    std::map<SigBit, int> group_of;
                    std::map<int, int> gcount;
                    std::ostringstream key;
                    for (int i = 0; i < K; i++) {
                        SigBit bit = b[i * W + j];
                        auto it = group_of.find(bit);
                        int id;
                        if (it == group_of.end()) { id = (int)group_of.size(); group_of.emplace(bit, id); }
                        else id = it->second;
                        gcount[id]++;
                        if (i) key << "|";
                        key << "g" << id;
                    }
                    keys[j] = key.str();
                    bool reused = false;
                    for (auto &kv : gcount) if (kv.second >= 2) reused = true;
                    bit_has_reuse[j] = reused;
                    if (reused) reuse_pattern_uses[keys[j]]++;
                }
                int shared = 0, reuse_bits = 0;
                for (int j = 0; j < W; j++) {
                    if (bit_has_reuse[j]) {
                        reuse_bits++;
                        if (reuse_pattern_uses[keys[j]] >= 2) shared++;
                    }
                }
                if (reuse_bits > 0) cells_with_reuse++;
                bits_with_reuse_total += reuse_bits;
                shared_bits_total += shared;
            }
        }

        /* --- 规则接受情况：第 1 周全部回退 --- */
        std::vector<std::string> accepted, rejected;
        std::string fallback_reason;
        for (const auto &r : rules) {
            if (r == "analyze_only") { accepted.push_back(r); continue; }
            rejected.push_back(r);
        }
        if (accepted.empty()) fallback_reason = "week1-skeleton: no structural rule implemented";
        if (!rejected.empty())
            fallback_reason += fallback_reason.empty() ? "unimplemented rule(s)" : "; unimplemented rule(s)";

        if (!quiet) {
            log("\n");
            log("pmux_opt: $pmux=%d, $mux=%d, 有复用模式的 cell=%d, 复用位总数=%d, 跨位共享位=%d, max W=%d, max K=%d\n",
                pmux_count, mux_count, cells_with_reuse, bits_with_reuse_total, shared_bits_total, max_w, max_k);
            log("pmux_opt: 第 1 周骨架版本 —— 不做结构变换，输出保留参考设计（fallback=true）。\n");
            if (!rejected.empty()) {
                for (auto &r : rejected) log("pmux_opt: 规则 '%s' 尚未实现，已记录为 unimplemented。\n", r.c_str());
            }
        }

        if (!json_file.empty()) {
            std::ofstream f(json_file);
            if (!f) log_error("无法写入 %s\n", json_file.c_str());
            f << "{\n";
            f << "  \"creator\": \"pmux_opt\",\n";
            f << "  \"yosys_version\": \"" << json_escape_opt(yosys_version_str) << "\",\n";
            f << "  \"reference_digest\": \"" << ref_digest << "\",\n";
            f << "  \"output_digest\": \"" << digest_of(design) << "\",\n";
            f << "  \"budget_ms\": " << budget_ms << ",\n";
            f << "  \"pmux_count\": " << pmux_count << ",\n";
            f << "  \"mux_count\": " << mux_count << ",\n";
            f << "  \"max_width\": " << max_w << ",\n";
            f << "  \"max_choices\": " << max_k << ",\n";
            f << "  \"cells_with_reuse\": " << cells_with_reuse << ",\n";
            f << "  \"bits_with_reuse_total\": " << bits_with_reuse_total << ",\n";
            f << "  \"shared_pattern_bits\": " << shared_bits_total << ",\n";
            f << "  \"accepted_rules\": [";
            for (size_t i = 0; i < accepted.size(); i++) { if (i) f << ", "; f << "\"" << json_escape_opt(accepted[i]) << "\""; }
            f << "],\n";
            f << "  \"rejected_rules\": [";
            for (size_t i = 0; i < rejected.size(); i++) { if (i) f << ", "; f << "\"" << json_escape_opt(rejected[i]) << "\""; }
            f << "],\n";
            f << "  \"fallback\": true,\n";
            f << "  \"fallback_reason\": \"" << json_escape_opt(fallback_reason) << "\",\n";
            f << "  \"formal_status\": \"NOT_RUN\"\n";
            f << "}\n";
            f.close();
            if (!quiet) log("pmux_opt: 已写出 %s\n", json_file.c_str());
        }
    }
} PmuxOptPass;

PRIVATE_NAMESPACE_END
