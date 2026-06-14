# Rapport PFE - Mon PF App

Ce dossier contient le rapport PFE de Yassmine Hajji pour le projet Mon PF App.

## Livrables

| Fichier | Usage |
|---|---|
| `latex/rapport_pfe_yassmine_hajji_mon_pf_app.tex` | Source LaTeX officielle du rapport |
| `latex/rapport_pfe_yassmine_hajji_mon_pf_app.pdf` | PDF compile depuis LaTeX |
| `Rapport_PFE_Yassmine_Hajji_Mon_PF_App.pdf` | Version finale imprimable / partageable, copie du PDF LaTeX |
| `Rapport_PFE_Yassmine_Hajji_Mon_PF_App.docx` | Version editable dans Word |
| `assets/` | Diagrammes et visuels generes pour le rapport |

## Compilation LaTeX

Depuis `docs/pfe-report/latex/`:

```powershell
pdflatex -interaction=nonstopmode -halt-on-error rapport_pfe_yassmine_hajji_mon_pf_app.tex
pdflatex -interaction=nonstopmode -halt-on-error rapport_pfe_yassmine_hajji_mon_pf_app.tex
```

## Regeneration

Depuis la racine du depot:

```powershell
C:\Users\LOQ\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe tools\build_pfe_documents.py
```

Le script regenere aussi le tutoriel technique dans `docs/tutorial/`.
