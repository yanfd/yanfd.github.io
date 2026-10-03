# Minimal Hexo Workflow Design

**Date:** 2026-08-07  
**Project:** `/Users/yanfengwu/Downloads/HexoBlog`

## Goal

Reduce the local Hexo workflow to the three operations actually needed:

```sh
blog new "文章标题"
blog edit
blog publish
```

Existing Hexo content, theme, scaffolds, and CI/CD configuration remain unchanged.

## Confirmed Project Context

- Posts are stored in `source/_posts`.
- The existing post scaffold is `scaffolds/post.md`.
- `post_asset_folder: true` remains enabled, so Hexo continues to manage post asset folders according to the existing configuration.
- `workflows/deploy.yml` deploys on pushes to `main`:
  - checkout
  - Node.js 14
  - `npm ci`
  - `npx hexo generate`
  - `npx hexo deploy`
- Typora is installed at `/Applications/Typora.app`.

## Interface

### `blog new "文章标题"`

Run the project-local Hexo binary from the repository root:

```sh
./node_modules/.bin/hexo new "文章标题"
```

This uses the existing `scaffolds/post.md` and creates the Markdown file under `source/_posts`. The helper then opens the generated Markdown file in Typora. It must preserve spaces and Chinese characters in titles.

The title is required. Missing titles fail without creating anything.

### `blog edit`

Open the whole posts directory in Typora:

```sh
open -a Typora "$ROOT_DIR/source/_posts"
```

The user chooses an article inside Typora. No `fzf`, post selection, or editor detection is needed.

### `blog publish`

Trigger the existing GitHub Actions workflow by committing and pushing the current source changes to `main`:

1. Show `git status --short`.
2. Require an interactive terminal.
3. Ask for a single `y/N` confirmation.
4. Run `git add source/_posts`.
5. If there are staged post changes, create a commit with a fixed message such as `post: publish updates`.
6. Push `main` to `origin`.

This command does not run Hexo locally and does not call `hexo deploy`. GitHub Actions performs the build and deployment. The helper only stages `source/_posts`, so it will not accidentally publish helper code, docs, generated files, or unrelated working-tree changes. If no post changes exist, it exits without creating an empty commit.

## Architecture

Create one executable POSIX shell script at `bin/blog`. It resolves the repository root from its own path and always invokes the local Hexo binary. The script has only three dispatch branches, plus `help` and invalid-command handling.

The optional global shortcut is adding the repository's `bin` directory to `PATH` in zsh. The project remains usable via `./bin/blog` without shell configuration.

## Safety and Errors

- Missing local Hexo binary: fail before `new` runs.
- Missing title: print usage and return non-zero.
- Missing Typora: print the expected application path and return non-zero.
- `publish` without a TTY: refuse to commit or push.
- `publish` cancellation: do not stage, commit, or push.
- `publish` stages only `source/_posts`.
- `publish` skips commit/push when there are no post changes.
- Any failed git command stops the flow and preserves its failure status.
- No automatic `git add .`, force push, local Hexo build, or local Hexo deploy.

## Verification

- Shell syntax check passes.
- `blog new` forwards the exact title to local Hexo and opens the generated file.
- `blog edit` opens exactly `source/_posts` with Typora.
- `blog publish` refuses non-interactive execution, cancels safely, stages only posts, skips empty commits, and pushes only after confirmation.
- Fixture tests stub Hexo, Typora, Git, and `open`; they never touch the real remote.
- Real `./node_modules/.bin/hexo version` remains successful.
