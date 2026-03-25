# ============================================================
#  Script 03: Distance & Magnitude Explorer
# ============================================================

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))

if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr",   quietly = TRUE)) install.packages("dplyr")

library(ggplot2)
library(dplyr)

stars <- read.csv("dataset/hygdata_v41.csv", stringsAsFactors = FALSE)

stars <- stars %>%
  filter(
    !is.na(dist), !is.na(mag), !is.na(ci),
    dist > 0, dist < 300,
    ci > -0.5, ci < 2.5
  ) %>%
  mutate(
    star_color = case_when(
      ci < -0.20 ~ "#9bb0ff",
      ci <  0.00 ~ "#aabfff",
      ci <  0.30 ~ "#cad7ff",
      ci <  0.58 ~ "#f8f7ff",
      ci <  0.81 ~ "#ffe87c",
      ci <  1.40 ~ "#ffd2a1",
      TRUE       ~ "#ff6347"
    )
  )

bg <- "#05050f"

p <- ggplot(stars, aes(x = dist, y = mag)) +
  geom_point(aes(color = ci), alpha = 0.15, size = 0.4, shape = 16) +
  scale_color_gradientn(
    colors = c("#9bb0ff","#cad7ff","#ffffff","#ffe87c","#ffd2a1","#ff6347"),
    limits = c(-0.4, 2.0),
    name   = "Color Index") +
  scale_y_reverse() +
  labs(
    title    = "Star Brightness vs Distance",
    subtitle = "Closer stars appear brighter (but not always)",
    x        = "Distance (parsecs)",
    y        = "Apparent Magnitude (bright ↑)") +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    panel.grid.major = element_line(color = "#1a1a2e"),
    panel.grid.minor = element_blank(),
    text             = element_text(color = "white"),
    axis.text        = element_text(color = "#aaaaaa"),
    plot.title       = element_text(size = 15, face = "bold"),
    plot.subtitle    = element_text(size = 9,  color = "#888888"))

ggsave("outputs/distance_magnitude.png", p, width = 10, height = 7, dpi = 180, bg = bg)
cat("Saved outputs/distance_magnitude.png\n")