# CLAUDE.md – AI Assistant Instructions

**READ THIS FILE FIRST** upon entering this project.

This file contains critical rules and context for working on this project. These rules are non-negotiable.

---

## Critical Rules

### 1. NEVER DELETE DATA
Under no circumstances are you ever to DELETE any data files. Protected formats include:
- **Statistical data:** `.dta`, `.sav`, `.sas7bdat`
- **Spreadsheets:** `.xlsx`, `.xls`, `.csv`, `.tsv`
- **Spatial data:** `.shp`, `.geojson`, `.kml`, `.gpkg`
- **Databases:** `.db`, `.sqlite`, `.sql`
- **Raw data:** `.txt`, `.json`, `.xml`, `.parquet`
- **Add other formats as needed for your project**

### 2. NEVER DELETE PROGRAMS
Under no circumstances are you ever to DELETE any program files. Protected formats include:
- **Scripts:** `.do`, `.R`, `.py`, `.jl`, `.m`
- **Notebooks:** `.ipynb`, `.Rmd`, `.qmd`
- **Configuration:** `.yaml`, `.yml`, `.toml`, `.ini`
- **Documentation:** `.md`, `.tex`
- **Add other formats as needed for your project**

### 3. USE THE LEGACY FOLDER
The `./legacy/` folder contains a complete snapshot of the original project structure (created 20260120). This is sacred and should never be modified.

**One-Time Exception (COMPLETED):** On 20260120, we performed a one-time move of all original files into `./legacy/` to preserve the original project state. This was the only permitted "move" operation.

**Going forward:**
- NEVER move files directly between working directories
- ALWAYS copy from `./legacy/` when you need original files
- If reorganizing, copy files to new locations (never move)

### 4. STAY WITHIN THIS DIRECTORY
Under no circumstances are you ever to GO UP OUT OF THIS ONE FOLDER. All work must remain within this project directory.

### 5. COPY, DON'T MOVE
When working with files:
- COPY from `./legacy/` to working directories
- COPY between working directories if needed
- NEVER move files (except the one-time legacy migration, now complete)

### 6. MAINTAIN PROGRESS LOGS
The `./log/` directory contains progress logs that preserve conversation context across sessions.

**Why:** Chat sessions can die unexpectedly. When a new Claude starts, it has no memory of previous work. Logs bridge this gap.

**When to log:**
- After completing significant work
- Before ending a session
- After major decisions
- When context is building up

**What to include:**
- Current state of the project
- Summary of work done (include key results, tables, or figures)
- Key decisions made
- Any issues or blockers
- Next steps planned

**How:** Create timestamped entries (`YYYYMMDD_HHMM.md`) documenting what was done, current state, and next steps.

**On startup:** Always check `./log/` for recent entries to understand what was happening before.

---

## Project Context

- **Project Title:** Data Science Project
- **Project Directory:** project_root
- **Legacy Directory:** `./legacy/`
- **Log Directory:** `./log/`
- **Primary Tools:** Claude Code, Python, R, Stata
- **Authors:** Project Team
- **Goal:** Reproducible data science workflows

---


---

## About the Slides Folder

The `slides/` folder contains Quarto presentations created to showcase the results of the current session or specific analyses.

**Design Principles:**
- Clean, professional design suitable for academic or professional presentations
- Effective communication of data analysis findings
- Clear interpretation of results

**Style Guide:**
- **Titles:** Blue (#2874A6)
- **Bold emphasis:** Green (#229954)
- Custom CSS embedded directly in `.qmd` files for easy portability

**Typical Structure:**
```yaml
---
title: "Your Analysis Title"
author: "Your Name"
format:
  revealjs:
    theme: simple
    css: custom.css
---
```

---

## Workflow Guidelines

### Starting a New Session
1. Read this `CLAUDE.md` file
2. Check `./log/` for recent progress
3. Review project structure and goals
4. Understand what work has been completed

### During Work
1. Copy files from `./legacy/` when needed (never move)
2. Save intermediate results in appropriate directories
3. Document key decisions and findings
4. Create checkpoints for significant progress

### Ending a Session
1. Create a progress log in `./log/` with timestamp
2. Summarize work completed
3. Document next steps
4. Ensure all outputs are saved

---

**Remember:** These rules protect your work. When in doubt, copy rather than move, and log your progress.