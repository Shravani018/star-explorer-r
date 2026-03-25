# ============================================================
#  Script 02: Milky Way Density Heatmap
# ============================================================
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr",   quietly = TRUE)) install.packages("dplyr")
library(ggplot2)
library(dplyr)
stars <- read.csv("dataset/hygdata_v41.csv", stringsAsFactors = FALSE)

stars <- stars %>%
  filter(!is.na(ra), !is.na(dec), mag < 8) %>%
  mutate(
    ra_deg = ra * 15   # converting hours to degrees
    )

bg <- "#05050f"

sky <- ggplot(stars, aes(x = ra_deg, y = dec)) +
  stat_density_2d(
    aes(fill = after_stat(density)),
    geom  = "raster",
    contour = FALSE) +
  scale_fill_gradientn(
    colors = c("#05050f", "#0d0d2b", "#1a1a6e",
               "#4444cc", "#aaaaff", "#ffffff"),
    name   = "Star Density") +
  scale_x_continuous(
    limits = c(0, 360),
    breaks = seq(0, 360, 60),
    labels = paste0(seq(0, 360, 60), "°")) +
  scale_y_continuous(
    limits = c(-90, 90),
    breaks = seq(-90, 90, 30)) +
  labs(
    title    = "The Milky Way: Full Sky Star Density Map",
    subtitle = paste(nrow(stars), "stars brighter than magnitude 8"),
    x        = "Right Ascension",
    y        = "Declination" ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    panel.grid.major = element_line(color = "#1a1a2e"),
    panel.grid.minor = element_blank(),
    text             = element_text(color = "white"),
    axis.text        = element_text(color = "#aaaaaa"),
    plot.title       = element_text(size = 15, face = "bold"),
    plot.subtitle    = element_text(size = 9,  color = "#888888"),
    legend.key.height = unit(1.2, "cm")
  )
ggsave("outputs/sky_heatmap.png", sky, width = 12, height = 6, dpi = 180, bg = bg)
cat("Saved outputs/sky_heatmap.png\n")