# Supplementary Materials — Inventory & Structure

*Companion to:* Liu Y, Chen X, Huang Y, Lu J, Cheung K, Fang S. *Dual-Parameter Synergy-Sensitivity Profiling of Epigenetic-Targeted Drug Combinations in Cancer.* (manuscript to be submitted).

**Policy compliance:** Per the target journal's reproducibility policy, all supplementary files are
provided in the code repository (`/supplementary`) and as article supplementary material, accessible
**without registration or login**.

---

## A. Supplementary Tables

| ID | Title | Content | Source script | File |
|----|-------|---------|---------------|------|
| **Table S1** | Consensus-synergistic drug combinations | Per-block synergy scores under all four reference models (HSA, Bliss, Loewe, ZIP) with two-sided p values, single-agent IC50, relative IC50, and CSS. 36 evaluations across 15 drug pairs. | `03_classify.R` | `supplementary/Table_S1_synergistic_GT5.csv` |
| **Table S2** | Consensus-antagonistic drug combinations | Per-block synergy scores under all four reference models with two-sided p values, single-agent IC50, relative IC50, and CSS. 171 evaluations across 24 drug pairs. | `03_classify.R` | `supplementary/Table_S2_antagonistic_LT-5.csv` |
| **Drug list** | Epigenetic-targeted agent inventory | The epigenetic drugs and their targeted partners screened in this study, with mechanism annotations. | manual | `supplementary/Epigenetic_targeted_drugs_list.xlsx` |

## B. Per-block scored output (primary data)

| ID | Title | Content | Source script | File |
|----|-------|---------|---------------|------|
| **Scored matrix** | Per-block synergy + CSS for all screened blocks | One row per dose–response block (1,151 rows) with ZIP/HSA/Loewe/Bliss synergy scores and p values, IC50s, relative IC50s, CSS, and the four-model consensus classification (`synergistic` / `antagonistic` / `additive` / `discordant`). | `01_synergy_score.R`, `02_css.R`, `03_classify.R` | `results/drugcombs_scored.csv` |

## C. SynergyFinder intermediate outputs

| ID | Content | Source script | File |
|----|---------|---------------|------|
| **Summary score tables (1 and 2)** | Per-block SynergyFinder 2.0 score output for the two source datasets, prior to the CSS merge and consensus classification. | `01_synergy_score.R` | `results/SynergyFinder_summaryScore_table1_2021-06-29.csv`, `results/SynergyFinder_summaryScore_table2_2021-06-29.csv` |
| **Summary tables (1 and 2)** | SynergyFinder 2.0 summary tables for the two source datasets. | `01_synergy_score.R` | `results/SynergyFinder_summary_table1_2021-06-29.csv`, `results/SynergyFinder_summary_table2_2021-06-29.csv` |

> The manuscript's figures (Figures 2–4) and Tables 2–4 are regenerated from
> `results/drugcombs_scored.csv` by `scripts/04_figures.R`; the figure image files themselves are
> supplied with the manuscript as separate files rather than duplicated here.

## D. Supplementary Methods

1. **CSS derivation (Malyutina et al., 2019).** A background drug is held at its IC50 while a foreground
   drug is swept across a concentration range; roles are then reversed. CSS is the fractional sensitivity
   gain of the combination over the stronger single agent. Full formula and edge-case handling are in
   `scripts/02_css.R` (commented).
2. **Dual-threshold rationale.** Single-parameter cutoffs (synergy >5 alone) admit potent-but-
   weakly-synergistic agents. Requiring **both** synergy >5 **and** CSS >50% across all four models
   reclassifies 13 of the 36 consensus-synergistic blocks (36.1%) as sensitivity-insufficient.
3. **Consensus classification.** A block is consensus-synergistic only when all four reference models
   exceed +5, and consensus-antagonistic only when all four fall below -5. Blocks that disagree across
   models are labelled `discordant` and left indeterminate. The classification column in
   `results/drugcombs_scored.csv` is derived from the four model scores, not stored independently.
4. **Data provenance.** All matrices come from DrugCombDB (Liu et al., 2019; Barardo et al., 2021); no new
   experiments were performed. SAS import scripts reproduce the exact epigenetic-targeted subset. The
   source export does not expose per-block cell-line identifiers, so lineage-specific interpretation was
   not attempted.

## E. Naming & submission checklist

- [x] All `.csv` tables are UTF-8, header-row labelled, no merged cells.
- [x] All figure images are supplied with the manuscript as separate files.
- [x] File names match the IDs above exactly (Table S1, Table S2).
- [x] The code repository is mirrored in the article supplementary material as `SI_Code.zip`.
- [x] No login or registration is required to access any file.
- [x] `CITATION.cff` DOI (Zenodo) matches the `README.md` badge.
