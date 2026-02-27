#!/usr/bin/env bash
set -euo pipefail

echo "=== Clean render: project20XXy ==="

echo "1. Cleaning Quarto caches..."
rm -rf _freeze/
rm -rf .quarto/embed/
rm -f notebooks/*.embed-preview.html
rm -rf notebooks/*.embed_files/

echo "2. Rendering manuscript (HTML + PDF + Word)..."
quarto render

echo "=== Done ==="
echo "Outputs: index.html, index.pdf, index.docx"
