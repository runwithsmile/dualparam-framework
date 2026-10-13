# Dual-Parameter Synergy–Sensitivity Profiling Framework for Epigenetic-Targeted Drug Combinations

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.23340776.svg)](https://doi.org/10.5281/zenodo.23340776)

> **Companion code repository for:** Liu Y, Chen X, Huang Y, Lu J, Cheung K, Fang S. *Dual-Parameter Profiling of Synergistic and Antagonistic Epigenetic-Targeted Drug Combinations in Cancer.* Journal of Cheminformatics (submitted).

This repository provides the **dual-parameter computational framework** described in the manuscript: a pipeline that simultaneously quantifies **synergy** (interaction quality, via four reference models) and **sensitivity** (therapeutic potency, via the Combination Sensitivity Score, CSS) for epigenetic-targeted drug combinations, then applies a dual-threshold filter to suppress false positives.

In full compliance with the *Journal of Cheminformatics* mandatory third-party reproducibility policy, every script, configuration, and intermediate output required to regenerate the manuscript's results is deposited here and is accessible **without registration or login**.

---

## 1. What's in this repository

```
dualparam-framework/
├── README.md                      # this file
├── CITATION.cff                   # citation metadata (Zenodo DOI)
├── LICENSE                        # MIT
├── requirements.txt              # Python dependencies (framework scripts)
├── config/
│   └── params.json                # all analysis parameters (thresholds, models)
├── data/
│   ├── raw/                       # DrugCombDB dose–response matrices (CSV)
│   │   ├── drugcombs_response1_final_EpiTarget.csv
│   │   └── drugcombs_response2_final_EpiTarget.csv
│   └── import/                    # SAS import/preprocessing scripts
│       ├── Code For Import Data (drugcombs_response1_csv).sas
│       └── Code For Import Data (drugcombs_response2_csv).sas
├── scripts/
│   ├── 01_synergy_score.R         # synergy scoring via SynergyFinder 2.0
│   ├── 02_css.R                    # Combination Sensitivity Score (Malyutina 2019)
│   ├── 03_classify.R              # dual-threshold synergy/antagonism classification
│   └── 04_figures.R               # manuscript figure/table generation
├── results/
│   ├── SynergyFinder_summary_table1_*.csv
│   ├── SynergyFinder_summary_table2_*.csv
│   ├── drugcombs_scored.csv        # merged synergy + CSS matrix
│   └── CSS_plots/                  # CSS distribution plots (png/svg)
└── supplementary/                 # supplementary tables & figures (see SUPPLEMENTARY_MATERIALS.md)
    ├── Table_S1_synergistic_GT5.csv        # 36 synergistic pairs (ZIP > 5)
    ├── Table_S2_antagonistic_LT-5.csv      # 171 antagonistic pairs (ZIP < -5)
    └── Epigenetic_targeted_drugs_list.xlsx # epigenetic-targeted agent inventory
```

> **Status note:** The `scripts/*.R` files implementing the dual-parameter framework (synergy via SynergyFinder 2.0, CSS validation, dual-threshold classification, figures) are now deposited. The repository is complete and reproducible. Steps 2–4 run directly on the deposited CSVs; Step 1 regenerates them from `data/raw/` when SynergyFinder 2.0 is installed.

---

## 2. Requirements & installation

| Component | Purpose | Install |
|-----------|---------|---------|
| **SAS** (9.4+) | Import & preprocess raw DrugCombDB exports | Licensed SAS install |
| **R** (≥ 4.0) + `synergyfinder` | Synergy scoring (SynergyFinder 2.0) | `install.packages("synergyfinder")` |
| **R** (≥ 4.0) + `ggplot2`, `data.table` | CSS, classification, figures | `install.packages(c("ggplot2","data.table"))` |
| **Python** (≥ 3.8) *(optional)* | Convenience wrappers / QA | `pip install -r requirements.txt` |

> The manuscript's synergy scores were computed with the **SynergyFinder 2.0** web application (https://synergyfinder.fimm.fi) and cross-checked with the R package of the same name. Either route is reproducible; the R package route is fully scriptable and preferred for archival.

```bash
# clone
git clone https://github.com/runwithsmile/dualparam-framework.git
cd dualparam-framework

# (optional) Python convenience environment
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
```

---

## 3. Data

All dose–response matrices were retrieved from **DrugCombDB** (Liu et al., 2019; Barardo et al., 2021), a curated public repository aggregating previously published pharmacological screening datasets. No new *in vitro* or *in vivo* experiments were performed.

- **Source:** http://drugcombdb.denglab.org
- **Scope:** 208 epigenetic-targeted drug-pair dose-response blocks (evaluations)
- **Cell models:** KBM-7 (hematopoietic), A549 (lung adenocarcinoma), MCF-7 (breast)
- **Raw inputs:** `data/raw/drugcombs_response{1,2}_final_EpiTarget.csv` (epigenetic-targeted subset, already filtered from the full DrugCombDB export)

If you prefer to re-pull from DrugCombDB, the SAS import scripts in `data/import/` reproduce the exact subset used here.

---

## 4. Pipeline

Run the steps in order. Each script reads from the previous step's output and writes to `results/`.

```bash
# Step 1 — Synergy scoring (4 models: HSA, Bliss, Loewe, ZIP) via SynergyFinder 2.0
Rscript scripts/01_synergy_score.R --input data/raw --output results

# Step 2 — Combination Sensitivity Score (CSS), following Malyutina et al. (2019)
Rscript scripts/02_css.R --input data/raw --output results

# Step 3 — Dual-threshold classification
Rscript scripts/03_classify.R --config config/params.json --input results --output results

# Step 4 — Generate manuscript figures & tables
Rscript scripts/04_figures.R --input results --output results --supp supplementary
```

### Parameters (`config/params.json`)

```json
{
  "synergy_models": ["HSA", "Bliss", "Loewe", "ZIP"],
  "synergy_threshold": 5,
  "antagonism_threshold": -5,
  "css_threshold_pct": 50,
  "dual_filter": "synergy_score > 5 AND CSS > 50% across all four models",
  "cell_lines": ["KBM-7", "A549", "MCF-7"]
}
```

The **dual-threshold filter** (synergy score > 5 **and** CSS > 50% across all four models) reduces discordant (false-positive) classifications by **36%** relative to single-parameter classification.

---

## 5. Reproducibility

Every number, figure, and table in the manuscript is regenerated from the deposited code and public inputs. No login-gated or restricted resource is required.

| Manuscript element | Regenerated by | Output file |
|--------------------|----------------|-------------|
| Fig. 1 — synergy-score distribution (4 models) | `04_figures.R` | `results/CSS_plots/fig_synergy_distribution.png` |
| Fig. 2 — dual-parameter synergy–sensitivity landscape | `04_figures.R` | `supplementary/fig_dualparam_landscape.png` |
| Fig. 3 — classification composition | `04_figures.R` | `supplementary/fig_class_bar.png` |
| Table 2 — classified combination profile | `03_classify.R` | `results/drugcombs_scored.csv` |
| Synergistic / antagonistic reference (36 / 171) | deposited | `supplementary/Table_S1_synergistic_GT5.csv`, `Table_S2_antagonistic_LT-5.csv` |
| Dual-threshold false-positive reduction | `03_classify.R` | printed to stdout (computed live on deposited data) |

A single command regenerates everything:

```bash
./run_all.sh   # wraps steps 1–4 (provided at repo root)
```

### 5.1 Checklist before archiving (author action required)

- **Zenodo DOI** — archived at `10.5281/zenodo.23340776` (CITATION.cff `doi` field and top badge updated).
- **GitHub URL** — set to the actual repository `github.com/runwithsmile/dualparam-framework` (GitHub username `runwithsmile`; this differs from the corresponding author's e-mail `liuyongjoy@outlook.com`).
- **Step 1 (SynergyFinder 2.0)** regenerates the synergy + CSS tables from `data/raw/`. The deposited `results/*.csv` are the reference outputs; Steps 2–4 run directly on them without re-running SynergyFinder.
- **Dual-threshold false-positive reduction** is computed live by `scripts/03_classify.R` from the deposited GT5 data: 13 of 36 ZIP>5 synergistic dose–response blocks have CSS≤50 and are reclassified as false positives, giving **36%** (13/36 ≈ 36.1%). The manuscript reports this same **36%** block-level figure, so the repository reproduces the manuscript exactly. (The separate "32% (66/208)" in the manuscript is the single-parameter discordance *rate* among all 208 combinations — a different quantity, left unchanged.)

---

## 6. License

Code is released under the **MIT License** (OSI-approved). See `LICENSE`. There are **no restrictions to use by non-academics**.

---

## 7. How to cite

**Paper (manuscript under review):**
> Liu Y, Chen X, Huang Y, Lu J, Cheung K, Fang S. Dual-Parameter Profiling of Synergistic and Antagonistic Epigenetic-Targeted Drug Combinations in Cancer. *Journal of Cheminformatics*. (submitted).

**This repository (archived with persistent DOI):**
> Liu Y, Chen X, Huang Y, Lu J, Cheung K, Fang S. Dual-Parameter Synergy–Sensitivity Profiling Framework [Data set]. Zenodo. https://doi.org/10.5281/zenodo.23340776

**Tools & data:**
- SynergyFinder 2.0 — Ianevski A, Giri AK, Aittokallio T. *Nucleic Acids Res.* 2020;48(W1):W488–W493. (Ref. #4)
- DrugCombDB — Liu H, Zhang W, Zou B, et al. *Nucleic Acids Res.* 2019;48(D1):D871–D881. (Ref. #12); Barardo D, Burbano L, Zhang W, et al. *Nucleic Acids Res.* 2021;49(D1):D1180–D1189. (Ref. #34)

---

## 8. Acknowledgements

We thank the DrugCombDB and SynergyFinder 2.0 teams for providing open data and software, and the developers of the underlying R/`synergyfinder` ecosystem.
