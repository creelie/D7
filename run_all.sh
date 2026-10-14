#!/usr/bin/env bash
# Run every check of the archive from any working directory.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v g++ >/dev/null || { echo "g++ is required" >&2; exit 2; }
command -v python3 >/dev/null || { echo "python3 is required" >&2; exit 2; }
python3 -c 'import numpy, pysat' || { echo "python3 needs numpy and python-sat" >&2; exit 2; }
g++ -O2 -o "$ROOT/code/cpp/search" "$ROOT/code/cpp/search.cpp"
echo "== brute force, n <= 4"
python3 "$ROOT/code/python/brute_small.py"
echo "== upper bounds: optimal words"
cat "$ROOT"/certs/word_n*.txt | sort -n | python3 "$ROOT/code/python/verify_upper.py"
echo "== lower bounds: certificates"
python3 "$ROOT/code/python/verify_lower.py"
if command -v lake >/dev/null; then
  echo "== Lean"
  (cd "$ROOT/lean" && lake exe cache get && lake build)
else
  echo "== Lean skipped (lake not found)"
fi
echo "all checks passed"
