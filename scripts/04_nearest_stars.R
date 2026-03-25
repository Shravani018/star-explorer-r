# ============================================================
# Script 04: Our Nearest Neighbours
# ============================================================

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr",   quietly = TRUE)) install.packages("dplyr")

library(ggplot2)
library(dplyr)

stars <- read.csv("dataset/hygdata_v41.csv", stringsAsFactors = FALSE)

nearest <- stars %>%
  filter(!is.na(dist), dist > 0, dist < 10) %>%
  mutate(
    label = case_when(
      !is.na(proper) & proper != "" ~ proper,
      !is.na(bf)     & bf     != "" ~ bf,
      TRUE                          ~ paste0("HIP ", hip)
    ),
    ci = ifelse(is.na(ci), 0.6, ci),
    star_color = case_when(
      ci < -0.20 ~ "#9bb0ff",
      ci <  0.00 ~ "#aabfff",
      ci <  0.30 ~ "#cad7ff",
      ci <  0.58 ~ "#f8f7ff",
      ci <  0.81 ~ "#ffe87c",
      ci <  1.40 ~ "#ffd2a1",
      TRUE       ~ "#ff6347"
    ),
    dist_ly = round(dist * 3.26156, 2)   # parsecs to light years
  ) %>%
  arrange(dist) %>%
  slice_head(n = 20)

bg <- "#05050f"

p <- ggplot(nearest, aes(x = reorder(label, -dist_ly), y = dist_ly)) +
  geom_col(aes(fill = star_color), width = 0.7, show.legend = FALSE) +
  scale_fill_identity() +
  coord_flip() +
  geom_text(aes(label = paste(dist_ly, "ly")),
            hjust = -0.1, color = "#aaaaaa", size = 3) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title    = "Our 20 Nearest Stellar Neighbours",
    subtitle = "Distance in light years (bar color reflects star temperature)",
    x        = NULL,
    y        = "Distance (light years)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    panel.grid.major = element_line(color = "#1a1a2e"),
    panel.grid.minor = element_blank(),
    text             = element_text(color = "white"),
    axis.text        = element_text(color = "#cccccc"),
    plot.title       = element_text(size = 15, face = "bold"),
    plot.subtitle    = element_text(size = 9,  color = "#888888")
  )

ggsave("outputs/nearest_stars.png", p, width = 10, height = 7, dpi = 180, bg = bg)
cat("Saved outputs/nearest_stars.png\n")