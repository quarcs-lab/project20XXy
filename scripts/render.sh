#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

command -v quarto >/dev/null 2>&1 || { echo "ERROR: quarto not found"; exit 1; }

# Clean caches and render (two passes: first generates table .md files,
# second includes them correctly in the manuscript)
rm -rf _freeze/ _manuscript/ .quarto/
quarto render
quarto render

# Stage LaTeX for Overleaf sync
mkdir -p latex
if [ -f "_manuscript/_tex/index.tex" ]; then
    cp _manuscript/_tex/index.tex latex/index.tex
    cp _manuscript/_tex/index.tex latex/.baseline.tex
fi
