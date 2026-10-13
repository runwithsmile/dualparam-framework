# Supplementary Materials — Inventory & Structure

*Companion to:* Liu Y, Chen X, Huang Y, Lu J, Cheung K, Fang S. *Dual-Parameter Profiling of Synergistic and Antagonistic Epigenetic-Targeted Drug Combinations in Cancer.* (manuscript to be submitted).

**Policy compliance:** Per the the target journal's reproducibility policy, all supplementary files are provided in the code repository (`/supplementary`) and as article supplementary material, accessible **without registration or login**.

---

## A. Supplementary Tables

| ID | Title | Content | Source script | File |
|----|-------|---------|---------------|------|
| **Table S1** | Full 206-combination synergy–sensitivity profile | Per-combination synergy scores (HSA, Bliss, Loewe, ZIP), CSS, cell-line coverage, dual-parameter classification | `03_classify.R` | `supplementary/Table_S1_206_combinations.csv` |
| **Table S2** | Synergistic / antagonistic / neutral classification | Binary labels per combination under the dual-threshold filter (synergy >5 AND CSS >50% across all 4 models) | `03_classify.R` | `supplementary/Table_S2_classification.csv` |
| **Table S3** | HDAC-inhibitor subclass breakdown | Counts and representative pairs for the dominant HDAC–PARP synergistic class (61% of synergistic set) | `03_classify.R` | `supplementary/Table_S3_HDAC_PARP.csv` |
| **Table S4** | Drug list & mechanism classes | Epigenetic agents (DNMTi, HDACi, LSD1i, EZH2i) + targeted agents, with HEDD / My Cancer Genome provenance | manual | `supplementary/Table_S4_drug_list.csv` |
| **Table S5** | Cell-line dose–response matrices | Raw DrugCombDB matrices for KBM-7, A549, MCF-7 (mirrors `data/raw/`) | `data/import/*.sas` | `supplementary/Table_S5_matrices.zip` |

## B. Supplementary Figures

| ID | Title | Content | Source script | File |
|----|-------|---------|---------------|------|
| **Fig. S1** | Synergy-score distributions (4 models) | Histograms/violin plots of HSA/Bliss/Loewe/ZIP scores across 206 combinations | `04_figures.R` | `supplementary/Fig_S1_synergy_distribution.png` |
| **Fig. S2** | Dual-parameter synergy–sensitivity landscape | Scatter of synergy score vs. CSS, colored by class; highlights dual-high combos | `04_figures.R` | `supplementary/Fig_S2_landscape.png` |
| **Fig. S3** | Representative pairs | Hydralazine–Gefitinib (synergistic) and Tranylcypromine–Imatinib (antagonistic) dose–response surfaces | `04_figures.R` | `supplementary/Fig_S3_pairs.png` |
| **Fig. S4** | CSS distribution & threshold | CSS histogram with the 50% cutoff overlaid | `02_css.R` | `supplementary/Fig_S4_css.png` |
| **Fig. S5** | LSD1–BCR-ABL antagonism mechanism | Wnt/β-catenin pathway schematic supporting the Tranylcypromine–Imatinib case | manual | `supplementary/Fig_S5_mechanism.png` |

## C. Supplementary Methods

1. **CSS derivation (Malyutina et al., 2019).** A background drug is held at its IC₅₀ while a foreground drug is swept across a concentration range; roles are then reversed. CSS is the fractional sensitivity gain of the combination over the stronger single agent. Full formula and edge-case handling in `scripts/02_css.R` (commented).
2. **Dual-threshold rationale.** Single-parameter cutoffs (synergy >5 alone) admit potent-but-weakly-synergistic agents. Requiring **both** synergy >5 **and** CSS >50% across all four models removes 32% of false positives (validated by leave-one-model-out stability).
3. **Cell-line selection.** KBM-7 (hematopoietic), A549 (lung adenocarcinoma), MCF-7 (breast) chosen to span lineages and test cross-lineage generalizability.
4. **Data provenance.** All matrices from DrugCombDB (Liu et al., 2019; Barardo et al., 2021); no new experiments. SAS import scripts reproduce the exact epigenetic-targeted subset.

## D. Naming & submission checklist

- [ ] All `.csv` tables are UTF-8, header-row labeled, no merged cells.
- [ ] All figures are ≥600 px wide, ≤10 MB, RGB.
- [ ] File names match the IDs above exactly (Table S1 …, Fig S1 …).
- [ ] `supplementary/` zipped as `Supplementary_Materials.zip` for journal upload **and** mirrored in the repo.
- [ ] No login/registration required to access any file.
- [ ] `CITATION.cff` DOI (Zenodo) filled and matches `README.md` badge.
