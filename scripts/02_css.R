#!/usr/bin/env Rscript
# 02_css.R
# ---------------------------------------------------------------------------
# Validate the Combination Sensitivity Score (CSS) deposited by SynergyFinder 2.0.
#
# CSS (Malyutina et al., 2019; Nat. Commun. 10:3470 — Ref. #3) quantifies the
# overall therapeutic potency of a combination. For a two-drug pair it is the
# arithmetic mean of the two single-drug sensitivity contributions:
#
#     css = (css1_ic502 + css2_ic501) / 2
#
# where css1_ic502 is the sensitivity of drug 1 when drug 2 is held at its own
# IC50, and css2_ic501 vice versa.
#
# This script independently recomputes css from the two components and asserts
# it matches the deposited `css` column, guaranteeing the sensitivity axis is
# transparent and reproducible.
# ---------------------------------------------------------------------------
suppressMessages(library(data.table))

files <- c("results/SynergyFinder_summary_table1_2021-06-29.csv",
           "results/SynergyFinder_summary_table2_2021-06-29.csv")
dt <- rbindlist(lapply(files, fread), fill = TRUE)

dt[, css_recomputed := (css1_ic502 + css2_ic501) / 2]
max_diff <- max(abs(dt$css_recomputed - dt$css), na.rm = TRUE)

cat(sprintf("Rows: %d | Max |css_recomputed - deposited css| = %.3e\n",
            nrow(dt), max_diff))
if (max_diff > 1e-6) {
  stop("CSS recomputation does NOT match deposited values — investigate input CSVs.")
}
fwrite(dt, "results/drugcombs_scored.css_validated.csv")
cat("CSS validated; table written to results/drugcombs_scored.css_validated.csv\n")
