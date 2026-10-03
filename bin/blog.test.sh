#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT HUP INT TERM

STUB_BIN="$TEST_DIR/bin"
FIXTURE="$TEST_DIR/project"
LOG="$TEST_DIR/calls.log"
mkdir -p "$STUB_BIN" "$FIXTURE/node_modules/.bin" "$FIXTURE/source/_posts"
: >"$LOG"
mkdir -p "$TEST_DIR/Typora.app"
mkdir -p "$FIXTURE/bin"
cp "$ROOT_DIR/bin/blog" "$FIXTURE/bin/blog"
chmod +x "$FIXTURE/bin/blog"

cat >"$FIXTURE/node_modules/.bin/hexo" <<'EOF'
#!/bin/sh
  printf 'hexo %s\n' "$*" >>"$BLOG_TEST_LOG"
if [ "${1-}" = new ]; then
  title=${2-}
  printf '%s\n' '---' 'title: test' '---' >"$BLOG_TEST_PROJECT/source/_posts/$title.md"
fi
EOF

cat >"$STUB_BIN/open" <<'EOF'
#!/bin/sh
printf 'open %s\n' "$*" >>"$BLOG_TEST_LOG"
EOF

cat >"$STUB_BIN/git" <<'EOF'
#!/bin/sh
printf 'git %s\n' "$*" >>"$BLOG_TEST_LOG"
case " $* " in
  *' diff --cached --quiet '*) exit 1 ;;
esac
EOF

chmod +x "$FIXTURE/node_modules/.bin/hexo" "$STUB_BIN/open" "$STUB_BIN/git"

assert_contains() {
  grep -F "$1" "$LOG" >/dev/null || {
    printf 'missing call: %s\n' "$1" >&2
    cat "$LOG" >&2
    exit 1
  }
}

assert_not_contains() {
  if grep -F "$1" "$LOG" >/dev/null; then
    printf 'unexpected call: %s\n' "$1" >&2
    cat "$LOG" >&2
    exit 1
  fi
}

run_blog() {
  BLOG_TEST_LOG="$LOG" BLOG_TEST_PROJECT="$FIXTURE" BLOG_TYPORA_APP="$TEST_DIR/Typora.app" PATH="$STUB_BIN:$PATH" \
    BLOG_TEST_ROOT="$FIXTURE" sh -c "exec '$FIXTURE/bin/blog' \"\$@\"" sh "$@"
}

assert_contains_with_output() {
  run_blog help >"$TEST_DIR/help.out"
  grep -F "$1" "$TEST_DIR/help.out" >/dev/null || exit 1
}

assert_contains_with_output 'blog publish'
run_blog new '中文 标题'
assert_contains 'hexo new 中文 标题'
assert_contains 'open -a Typora '

: >"$LOG"
run_blog edit
assert_contains "open -a Typora $FIXTURE/source/_posts"

: >"$LOG"
if BLOG_TEST_LOG="$LOG" BLOG_TEST_PROJECT="$FIXTURE" BLOG_TYPORA_APP="$TEST_DIR/Typora.app" PATH="$STUB_BIN:$PATH" \
  sh -c "exec '$FIXTURE/bin/blog' publish </dev/null"; then
  printf 'publish should reject non-interactive execution\n' >&2
  exit 1
fi
assert_not_contains 'git add'
assert_not_contains 'git push'

printf 'blog helper tests passed\n'
