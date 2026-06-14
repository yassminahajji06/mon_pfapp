# Tutorial Package

This folder contains the complete technical tutorial for Yassmine Hajji's Mon PF App project.

## Deliverables

| File | Purpose |
|---|---|
| `Mon_PF_App_Tutorial_Yassmine_Hajji.pdf` | Final tutorial PDF with architecture, stack, screenshots, algorithms, tests and presentation notes |
| `Mon_PF_App_Tutorial_Yassmine_Hajji.docx` | Editable source version |
| `assets/diagrams/` | Generated architecture, auth, order flow, repo and data model diagrams |
| `assets/screenshots/` | Captured Flutter UI screenshots used in the guide and root README |

## Regenerate

From the repository root:

```powershell
node tools/capture_app_screenshots.js
C:\Users\LOQ\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe tools\build_pfe_documents.py
```

The screenshot script expects the web release to be available at `http://localhost:57321`.

`tools/build_pfe_documents.py` regenere aussi le rapport PFE dans `docs/pfe-report/`.

## QA Note

The PDF was rendered to page images during QA to check for clipping, overlap and missing visuals. Those render outputs are internal and ignored by Git.
