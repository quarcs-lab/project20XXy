#!/usr/bin/env bash
set -euo pipefail

echo "=== Clean render: $(basename "$(pwd)") ==="

echo "1. Cleaning Quarto caches..."
rm -rf _freeze/
rm -rf _manuscript/
rm -rf .quarto/embed/

echo "2. Rendering manuscript (HTML + PDF + Word)..."
quarto render

echo "3. Staging LaTeX for Overleaf sync..."
mkdir -p latex
cp _manuscript/_tex/index.tex latex/index.tex
cp _manuscript/_tex/index.tex latex/.baseline.tex

echo "=== Done ==="
echo "Outputs in _manuscript/: index.html, index.pdf, index.docx"
echo "LaTeX staged in latex/index.tex (baseline saved to latex/.baseline.tex)"
