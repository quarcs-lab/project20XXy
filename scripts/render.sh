#!/usr/bin/env bash
set -euo pipefail

echo "=== Clean render: project20XXy ==="

echo "1. Cleaning Quarto caches..."
rm -rf _freeze/
rm -rf _manuscript/
rm -rf .quarto/embed/

echo "2. Rendering manuscript (HTML + PDF + Word)..."
quarto render

echo "=== Done ==="
echo "Outputs in _manuscript/: index.html, index.pdf, index.docx"
