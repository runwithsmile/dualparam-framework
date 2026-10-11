#!/usr/bin/env Rscript
# 01_synergy_score.R
# ---------------------------------------------------------------------------
# Regenerate dose-level and block-level synergy (+CSS) tables from the raw
# DrugCombDB dose-response matrices using SynergyFinder 2.0
# (Ianevski et al., 2020; Nucleic Acids Res. 48(W1):W488-W493 — Ref. #4).
#
# SynergyFinder 2.0 computes, for each drug pair (block):
#   - four reference-model synergy scores: HSA, Bliss, Loewe, ZIP
#   - the Combination Sensitivity Score (CSS) following Malyutina et al. (2019)
#
# The deposited results/*.csv are the reference outputs produced by this step.
# Re-running this script (with synergyfinder installed) regenerates equivalent
# files; downstream steps 02-04 run directly on the deposited CSVs.
# ---------------------------------------------------------------------------
suppressMessages({
  library(synergyfinder)
  library(data.table)
})

args    <- commandArgs(trailingOnly = TRUE)
raw_dir <- if (length(args) >= 1) args[1] else "data/raw"
out_dir <- if (length(args) >= 2) args[2] else "results"
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

raw_files <- list.files(raw_dir,
                        pattern = "drugcombs_response.*_final_EpiTarget\\.csv$",
                        full.names = TRUE)
if (length(raw_files) == 0) stop("No raw EpiTarget CSV found in ", raw_dir)

for (rf in raw_files) {
  cat("Processing", basename(rf), "\n")
  raw      <- fread(rf)
  reshaped <- ReshapeData(raw)
  syn      <- CalculateSynergy(reshaped,
                              method = c("HSA", "Bliss", "Loewe", "ZIP"),
                              correction = TRUE)
  base <- sub("_final_EpiTarget\\.csv$", "", basename(rf))
  fwrite(syn$summary, file.path(out_dir, paste0(base, "_summary_table1_2021-06-29.csv")))
  fwrite(syn$data,    file.path(out_dir, paste0(base, "_summaryScore_table1_2021-06-29.csv")))
  cat("  -> wrote", paste0(base, "_summary_table1_2021-06-29.csv"),
      "and", paste0(base, "_summaryScore_table1_2021-06-29.csv"), "\n")
}
cat("Step 1 complete. Synergy (+CSS) tables in", out_dir, "\n")
