#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

command -v quarto >/dev/null 2>&1 || { echo "ERROR: quarto not found"; exit 1; }

# Clean caches and render (two passes: first generates table .md files,
# second includes them correctly in the manuscript)
rm -rf _freeze/ _manuscript/ .quarto/
quarto render
quarto render

# Generate LLM-friendly markdown (clean text from LaTeX, no HTML artifacts)
quarto pandoc _manuscript/_tex/index.tex -f latex -t gfm-raw_html -o _manuscript/index.llms.md --wrap=none

# Stage LaTeX for Overleaf sync
mkdir -p latex
if [ -f "_manuscript/_tex/index.tex" ]; then
    cp _manuscript/_tex/index.tex latex/index.tex
    cp _manuscript/_tex/index.tex latex/.baseline.tex
fi

# Deploy to GitHub Pages (if gh-pages branch exists)
if git rev-parse --verify gh-pages >/dev/null 2>&1; then
    echo "Deploying to GitHub Pages..."
    tmpdir=$(mktemp -d)
    git worktree add "$tmpdir" gh-pages
    rm -rf "$tmpdir"/*
    cp -R _manuscript/* "$tmpdir/"
    touch "$tmpdir/.nojekyll"
    cd "$tmpdir"
    git add -A
    if git diff --cached --quiet; then
        echo "No changes to deploy."
    else
        git commit -m "Deploy manuscript to GitHub Pages"
        git push origin gh-pages
        echo "Deployed to GitHub Pages."
    fi
    cd - >/dev/null
    git worktree remove "$tmpdir"
fi
