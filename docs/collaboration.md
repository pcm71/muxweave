# 团队协作方式（不建远端仓库）

三人各自本地都是完整 git 仓库，通过下面任一方式交换提交。**三种方式可以混用**，
关键是：谁也不能直接改别人的工作目录，改动一律通过 git 提交传递。

---

## 方式 A（推荐）：云同步盘 + 裸仓库当"远端"

零服务器，但有完整 git 协作（clone / push / pull / 分支 / 冲突处理）。
前提：三人能访问**同一个共享同步目录**（OneDrive 共享文件夹、坚果云同步文件夹等）。

```bash
# 1) 在同步盘里建裸仓库（只做一次，由 A 执行）
cd "/mnt/c/Users/<你的用户名>/OneDrive/团队共享"        # 换成你的同步盘路径
git init --bare muxweave.git

# 2) A 把本地仓库推上去
cd "/mnt/c/Users/<你的用户名>/Desktop/PMUX/muxweave"
git remote add origin "/mnt/c/Users/<你的用户名>/OneDrive/团队共享/muxweave.git"
git branch -M main
git push -u origin main

# 3) B、C 各自克隆（路径用**自己机器上**同步盘的本地路径）
git clone "/mnt/c/Users/<自己的用户名>/OneDrive/团队共享/muxweave.git" muxweave
cd muxweave
git config user.name "B 的名字"
git config user.email "B 的邮箱"
```

日常：`git pull` → 改代码 → `git commit` → `git push`。

**注意（同步盘特有的风险）**

- 同步有延迟：**两人不要同时 push**；push 前先 `git pull`，push 后再等同步完成（看云盘图标变绿）再通知别人。
- 云盘偶尔会把裸仓库的 pack 文件同步到中间状态。因为我们仓库很小（约 150 KB），风险低；
  万一坏了，从任何一个人的本地克隆重新 `git push --mirror` 即可恢复。
- **不要**让云盘同步"工作目录"本身（即不要同步 `muxweave/` 而不是 `muxweave.git`）——
  那会把 `.git` 内部状态搅乱，冲突几乎无法修复。

---

## 方式 B（最稳）：每周 bundle 单文件交换

无任何同步风险，适合"不常在一起、各干各的"。缺点是没有实时协作，靠每周固定交换。

```bash
# 出包的人（每周一次）
cd muxweave
git bundle create ../muxweave-w<N>.bundle --all

# 收包的人：本地已有仓库 → 从 bundle 拉取合并
git pull ../muxweave-w<N>.bundle main

# 收包的人：本地还没有仓库 → 直接克隆
git clone muxweave-w<N>.bundle muxweave
```

文件很小（当前 82 KB），微信/QQ 直接发即可。

**纪律**：每周固定时间（例如周日 20:00）全员出包并互相拉取；
**不要攒两周以上**，否则冲突会很难合。

---

## 方式 C：局域网自建 Gitea（如果实验室有常开的机器）

最贴近正规协作，一次投入长期受益。

```bash
# 在常开的机器上（Linux）
wget https://dl.gitea.com/gitea/latest/gitea-latest-linux-amd64   # 单文件，无依赖
chmod +x gitea-latest-linux-amd64
./gitea-latest-linux-amd64 web --port 3000                        # 浏览器打开 http://<内网IP>:3000 初始化
```

初始化后在网页上建 `muxweave` 私有仓库，然后三人：

```bash
git remote add origin http://<内网IP>:3000/<用户名>/muxweave.git
git push -u origin main
```

---

## 通用纪律（比选哪种方式更重要）

1. **每人先配自己的身份**，否则提交记录分不清谁做的（答辩要讲团队分工）：
   ```bash
   git config user.name "真实姓名"
   git config user.email "常用邮箱"
   ```
2. **按目录分工，减少冲突面**（我们仓库天然适合这样切）：
   | 角色 | 自己的地盘 |
   |---|---|
   | A 算法/插件 | `plugin/` `configs/` |
   | B 验证/评测 | `benchmarks/` `formal/` |
   | C 集成/展示 | `scripts/` `docs/` `reports/` |
   公共文件（根 `README.md`、`VERSION_LOCK.md`）改动前先在群里说一声。
3. **每次开工前先 `git pull`，收工前必须 `git commit`**；不要长时间留着未提交的改动。
4. **传代码不传二进制**：Yosys/EQY 必须在各自机器上编译（约 18 分钟），
   二进制跨机不可用，`runs/` 证据也不必互传（可重生成）。
5. **版本必须保持一致**：任何人升级 Yosys/EQY 版本，都要先更新 `VERSION_LOCK.md`
   并在群里公告，然后**全员重跑基线**。这是主办方明确要求的"全队同一版本"。
6. **提交信息写清触发条件与验证范围**（方案第 17 节），例如：
   `分析器: 修正复用判定假信号（普通2选1不再报有机会）；重跑 u01-u05 全部通过`
7. **别把大文件提交进去**：`runs/`、`*.so`、`yosys` 二进制已在 `.gitignore` 里排除，
   不要用 `git add -f` 强行加入。

---

## 三种方式对比

| | A 同步盘+裸仓库 | B bundle 交换 | C 局域网 Gitea |
|---|---|---|---|
| 需要服务器 | 否 | 否 | 是（一台常开机器） |
| 实时性 | 好（同步延迟内） | 差（每周） | 好 |
| 冲突处理 | git 正常处理 | git 正常处理 | git 正常处理 |
| 上手成本 | 低 | 极低 | 中 |
| 主要风险 | 云盘同步半成品 | 攒太久难合 | 机器需常开 |
| 适合 | 三人有共享云盘 | 不常碰面 | 同一实验室 |
