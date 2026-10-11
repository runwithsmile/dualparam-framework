#!/usr/bin/env bash
# Reproduce the dual-parameter framework end-to-end.
# Requires: R (>=4.0) with synergyfinder, data.table, ggplot2; optional SAS for re-import.
set -euo pipefail

echo "[1/4] Synergy scoring (SynergyFinder 2.0, 4 reference models + CSS) ..."
Rscript scripts/01_synergy_score.R data/raw results

echo "[2/4] CSS validation (Malyutina 2019) ..."
Rscript scripts/02_css.R

echo "[3/4] Dual-threshold classification + false-positive accounting ..."
Rscript scripts/03_classify.R

echo "[4/4] Manuscript figures ..."
Rscript scripts/04_figures.R

echo "Done. Results in results/ and supplementary/."
