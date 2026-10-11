#!/usr/bin/env Rscript
# 04_figures.R
# ---------------------------------------------------------------------------
# Generate the manuscript's dual-parameter figures from the classified matrix
# (results/drugcombs_scored.csv). Outputs:
#   - results/CSS_plots/fig_synergy_distribution.png  (Fig. 1: 4-model synergy density)
#   - supplementary/fig_dualparam_landscape.png       (Fig. 2: synergy-sensitivity landscape)
#   - supplementary/fig_class_bar.png                 (class composition bar)
# ---------------------------------------------------------------------------
suppressMessages({
  library(data.table)
  library(ggplot2)
})

dt <- fread("results/drugcombs_scored.csv")
dir.create("results/CSS_plots", showWarnings = FALSE, recursive = TRUE)

# Fig. 1 — synergy-score distribution across the four reference models
long <- melt(dt[, .SD, .SDcols = c("block_id", "ZIP_synergy", "HSA_synergy",
                                  "Loewe_synergy", "Bliss_synergy")],
             id.vars = "block_id", variable.name = "model", value.name = "synergy")
p1 <- ggplot(long, aes(x = synergy, fill = model)) +
  geom_density(alpha = 0.4) +
  geom_vline(xintercept = 5,  linetype = 2, color = "grey30") +
  geom_vline(xintercept = -5, linetype = 2, color = "grey30") +
  labs(title = "Synergy-score distribution (four reference models)",
       x = "Synergy score", y = "Density") +
  theme_minimal()
ggsave("results/CSS_plots/fig_synergy_distribution.png", p1, width = 7, height = 5)

# Fig. 2 — dual-parameter synergy-sensitivity landscape
dt[, mean_syn := (ZIP_synergy + HSA_synergy + Loewe_synergy + Bliss_synergy) / 4]
p2 <- ggplot(dt, aes(x = mean_syn, y = css, color = class)) +
  geom_point(alpha = 0.5, size = 1.5) +
  geom_hline(yintercept = 50, linetype = 2, color = "grey30") +
  geom_vline(xintercept = 5,  linetype = 2, color = "grey30") +
  scale_color_manual(values = c(synergistic = "#1b9e77",
                                antagonistic = "#d95f02",
                                discordant = "#7570b3")) +
  labs(title = "Dual-parameter synergy-sensitivity landscape",
       x = "Mean synergy score (4 models)", y = "CSS (%)") +
  theme_minimal()
ggsave("supplementary/fig_dualparam_landscape.png", p2, width = 7, height = 5)

# Fig. 3 — class composition
p3 <- ggplot(dt[, .N, by = class], aes(x = class, y = N, fill = class)) +
  geom_col() +
  geom_text(aes(label = N), vjust = -0.4) +
  labs(title = "Classification composition (dual-threshold)",
       x = "Class", y = "Number of blocks") +
  theme_minimal()
ggsave("supplementary/fig_class_bar.png", p3, width = 6, height = 4)

cat("Figures written to results/CSS_plots/ and supplementary/.\n")
