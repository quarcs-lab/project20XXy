# Logs

Timestamped execution logs from notebook runs and the render pipeline.

**Naming convention:** `<name>_YYYYMMDD_HHMM.txt`

- `<name>` is a notebook slug (`notebook-01`) or a pipeline name (`render`).
- Examples: `render_20260525_0930.txt`, `notebook-01_20260525_0930.txt`

`scripts/render.sh` writes a `render_<timestamp>.txt` log here on every run.

Log **contents** are gitignored (they are run artifacts that regenerate on
each run); this `README.md` keeps the folder tracked so the template ships
with it present. See `.gitignore`.
