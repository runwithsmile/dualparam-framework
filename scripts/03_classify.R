#!/usr/bin/env Rscript
# 03_classify.R
# ---------------------------------------------------------------------------
# Dual-parameter classification and false-positive accounting.
#
# Each drug pair (block) is assigned one of three classes using BOTH axes:
#   - synergy  : 4 reference models (ZIP/HSA/Loewe/Bliss) all >  +5
#   - sensitivity : CSS > 50%
#   - antagonism  : all four synergy scores < -5
#
#   synergistic  = (all 4 synergy > +5) AND (css > 50)
#   antagonistic = (all 4 synergy < -5)
#   discordant   = everything else (single-axis calls that the second axis overturns)
#
# The dual-threshold filter suppresses false positives relative to single-
# parameter (synergy-only) screening. The script reports the live reduction
# computed on the deposited data.
# ---------------------------------------------------------------------------
suppressMessages(library(data.table))

syn_cols <- c("ZIP_synergy", "HSA_synergy", "Loewe_synergy", "Bliss_synergy")
thr     <- 5
css_thr <- 50

dt <- rbindlist(lapply(c("results/SynergyFinder_summary_table1_2021-06-29.csv",
                        "results/SynergyFinder_summary_table2_2021-06-29.csv"),
                       fread), fill = TRUE)

dt[, syn_all := ZIP_synergy > thr & HSA_synergy > thr & Loewe_synergy > thr & Bliss_synergy > thr]
dt[, ant_all := ZIP_synergy < -thr & HSA_synergy < -thr & Loewe_synergy < -thr & Bliss_synergy < -thr]
dt[, class := "discordant"]
dt[syn_all & css > css_thr, class := "synergistic"]
dt[ant_all == TRUE,        class := "antagonistic"]

fwrite(dt, "results/drugcombs_scored.csv")

# ---- Manuscript reference counts (combination level, SynergyFinder ZIP cut-offs) ----
gt5 <- fread("supplementary/Table_S1_synergistic_GT5.csv")    # 36 synergistic (ZIP > 5)
lt5 <- fread("supplementary/Table_S2_antagonistic_LT-5.csv")  # 171 antagonistic (ZIP < -5)

single_syn <- nrow(gt5)                       # single-parameter (ZIP-only) synergistic
dual_syn   <- gt5[, sum(css > css_thr)]       # dual-threshold (ZIP>5 & CSS>50) synergistic
reduction  <- (single_syn - dual_syn) / single_syn * 100

cat("=== Dual-parameter classification (block level) ===\n")
print(dt[, .N, by = class])
cat(sprintf("\nManuscript synergistic reference (ZIP>5)      : %d\n", single_syn))
cat(sprintf("Dual-threshold synergistic (ZIP>5 & CSS>%d%%)   : %d\n", css_thr, dual_syn))
cat(sprintf("False-positive reduction vs single-parameter   : %.1f%%\n", reduction))
cat(sprintf("Manuscript antagonistic reference (ZIP<-5)     : %d\n", nrow(lt5)))
cat("\nClassified matrix written to results/drugcombs_scored.csv\n")
