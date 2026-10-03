# Hexo Workflow

文章都在 `source/_posts`，现在只需要三个命令。

## 使用

在博客目录里直接运行：

```sh
./bin/blog new "文章标题"
./bin/blog edit
./bin/blog publish
```

想直接使用 `blog`，把 helper 加进 zsh 的 `PATH`：

```sh
echo 'export PATH="/Users/yanfengwu/Downloads/HexoBlog/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

- `blog new "文章标题"`：使用现有 Hexo `post` scaffold 创建文章，然后用 Typora 打开新文件。
- `blog edit`：用 Typora 打开整个 `source/_posts` 文件夹，你自己选择文章。
- `blog publish`：只提交 `source/_posts`，确认后 push 到 `origin/main`。push 成功后，GitHub Actions 会自动执行 Hexo 生成和部署。

`blog publish` 不执行本地 `serve`、`build` 或 `hexo deploy`，也不会提交文章目录以外的文件。
