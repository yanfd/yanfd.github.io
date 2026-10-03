# Minimal Hexo Workflow Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `blog new`, `blog edit`, and `blog publish` for the existing Hexo project.

**Architecture:** Use one executable POSIX shell script at `bin/blog`. It resolves the project root, invokes the existing local Hexo binary for post creation, opens `source/_posts` in Typora for editing, and stages/commits/pushes only post changes so the existing GitHub Actions workflow performs CI/CD.

**Tech Stack:** POSIX shell, Hexo `6.3.0`, Git, GitHub Actions, macOS `open`, Typora.

## Global Constraints

- Posts are under `source/_posts`.
- Use the existing `scaffolds/post.md`; do not rewrite front matter.
- Use only `./node_modules/.bin/hexo` for Hexo operations.
- `blog publish` must not run local Hexo build or deploy.
- `blog publish` may stage only `source/_posts`.
- Never use force push, `git add .`, or deploy during tests.

---

### Task 1: Implement the Three-Command Wrapper

**Files:**
- Create: `bin/blog`

**Interfaces:**
- `bin/blog new "title"`: creates a post with local Hexo and opens the generated file in Typora.
- `bin/blog edit`: opens `source/_posts` in Typora.
- `bin/blog publish`: confirms, stages post changes, commits, and pushes `main`.

- [ ] **Step 1: Add root and dependency resolution**

Create a `#!/bin/sh` script with `set -eu`. Resolve `ROOT_DIR` from the script's parent directory, set `HEXO="$ROOT_DIR/node_modules/.bin/hexo"`, set `POSTS_DIR="$ROOT_DIR/source/_posts"`, and fail with a clear message if the local Hexo binary or posts directory is missing.

- [ ] **Step 2: Implement `new`**

Require one non-empty title. Record the list of Markdown files under `source/_posts` before invoking:

```sh
"$HEXO" new "$title"
```

After success, identify the newly created Markdown file by comparing the before/after file lists, then run:

```sh
open -a Typora "$created_file"
```

Use quoted variables throughout so titles and paths with spaces or Chinese characters work.

- [ ] **Step 3: Implement `edit`**

Run:

```sh
open -a Typora "$POSTS_DIR"
```

Do not use `fzf` or open a single selected post.

- [ ] **Step 4: Implement help and invalid commands**

Support `blog help` and print only `new`, `edit`, and `publish`. Any other command returns non-zero with the same usage text. Do not forward miscellaneous Hexo commands.

- [ ] **Step 5: Run shell syntax validation**

Run:

```sh
sh -n bin/blog
chmod +x bin/blog
./bin/blog help
```

Expected: syntax succeeds, help exits `0`, and no existing content changes.

### Task 2: Implement the CI/CD Publish Flow

**Files:**
- Modify: `bin/blog`

**Interfaces:**
- Consumes current Git state.
- Produces a guarded commit and `git push origin main` that activates `workflows/deploy.yml`.

- [ ] **Step 1: Add interactive safety check**

At the start of `publish`, require stdin and stdout to be TTYs. If either is not a TTY, return non-zero before any Git mutation. Print that `blog publish` must be run from an interactive terminal.

- [ ] **Step 2: Show status and confirm**

Run `git -C "$ROOT_DIR" status --short`, then read one answer from `/dev/tty`. Continue only for `y` or `yes`, case-insensitive. For every other answer, return `0` without staging, committing, or pushing.

- [ ] **Step 3: Stage only post files**

Run:

```sh
git -C "$ROOT_DIR" add -- source/_posts
```

Then check whether the index contains staged changes. If it does not, print that there are no post changes and exit `0` without committing or pushing.

- [ ] **Step 4: Commit and push the workflow trigger**

When post changes are staged, run:

```sh
git -C "$ROOT_DIR" commit -m "post: publish updates"
git -C "$ROOT_DIR" push origin main
```

Do not modify the workflow file, run local Hexo commands, or stage unrelated files.

- [ ] **Step 5: Verify publish order with stubs**

Use temporary stub `git` and `open` executables to assert the order is status, confirmation, add, diff check, commit, push. Assert that cancellation and non-interactive execution contain neither `commit` nor `push`.

### Task 3: Add Fixture Tests

**Files:**
- Create: `bin/blog.test.sh`

**Interfaces:**
- Test runner uses temporary directories and stub executables; it must never contact GitHub or open the real Typora app.

- [ ] **Step 1: Build the fixture harness**

Create temporary `node_modules/.bin/hexo`, `open`, and `git` stubs. The Hexo stub logs arguments and creates a Markdown file for `new`; the `open` stub logs its arguments; the Git stub logs calls and returns controlled status/diff results.

- [ ] **Step 2: Test `new` and `edit`**

Assert that `new` forwards a title containing spaces and Chinese characters, opens the newly created Markdown path with `Typora`, and that `edit` opens the exact `source/_posts` directory.

- [ ] **Step 3: Test `publish` safety**

Assert that a non-interactive invocation fails before Git mutation, a negative confirmation performs no mutation, and a positive confirmation calls `add -- source/_posts`, commit with `post: publish updates`, and `push origin main` in order.

- [ ] **Step 4: Test no-op publish**

Configure the Git stub to report no post changes after staging. Assert that no commit or push is made.

- [ ] **Step 5: Run tests and diagnostics**

Run:

```sh
sh -n bin/blog
sh -n bin/blog.test.sh
./bin/blog.test.sh
git diff --check
```

Expected: all fixture assertions pass and no remote operation occurs.

### Task 4: Add Minimal Usage Documentation

**Files:**
- Create: `docs/hexo-workflow.md`

- [ ] **Step 1: Document direct invocation**

Document:

```sh
cd /Users/yanfengwu/Downloads/HexoBlog
./bin/blog new "文章标题"
./bin/blog edit
./bin/blog publish
```

- [ ] **Step 2: Document optional `blog` shortcut**

Document the one-time zsh configuration:

```sh
echo 'export PATH="/Users/yanfengwu/Downloads/HexoBlog/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

- [ ] **Step 3: Explain publish ownership**

State that `blog publish` only publishes changes under `source/_posts` and pushes `main`; the existing GitHub Actions workflow then runs Hexo generation and deployment.

### Task 5: Verify Against the Real Project Without Publishing

**Files:**
- No source changes expected.

- [ ] **Step 1: Verify Hexo remains available**

Run:

```sh
./node_modules/.bin/hexo version
```

Expected: successful output reporting Hexo `6.3.0`.

- [ ] **Step 2: Verify helper help and paths**

Run:

```sh
./bin/blog help
test -d source/_posts
test -f scaffolds/post.md
```

- [ ] **Step 3: Review final status**

Run `git status --short` and confirm that no existing articles, `workflows/deploy.yml`, or `_config.yml` were changed. Do not run `blog publish` against the real remote during verification.
