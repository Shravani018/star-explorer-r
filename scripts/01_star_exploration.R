# ============================================================
#  Script 01: HR Diagram + Color Distribution
# ============================================================

options(repos = c(CRAN = "https://packagemanager.posit.co/cran/__linux__/jammy/latest"))
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("dplyr",   quietly = TRUE)) install.packages("dplyr")
library(ggplot2)
library(dplyr)

# Loading dataset
stars <- read.csv("dataset/hygdata_v41.csv", stringsAsFactors = FALSE)
cat("Stars loaded:", nrow(stars), "\n")
stars <- stars %>%
  filter(
    !is.na(ci), !is.na(absmag),
    dist > 0, dist < 500,
    absmag > -10, absmag < 20,
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
    ),
    spectral_group = case_when(
      grepl("^O", spect) ~ "O",
      grepl("^B", spect) ~ "B",
      grepl("^A", spect) ~ "A",
      grepl("^F", spect) ~ "F",
      grepl("^G", spect) ~ "G",
      grepl("^K", spect) ~ "K",
      grepl("^M", spect) ~ "M",
      TRUE               ~ "Other"
    )
  )

cat("Stars after filter:", nrow(stars), "\n")
# Vizualisation 1: Hertzsprung Russell diagram
bg <- "#05050f"
hr <- ggplot(stars, aes(x = ci, y = absmag)) +
  geom_point(aes(color = ci), alpha = 0.2, size = 0.4, shape = 16) +
  scale_color_gradientn(
    colors = c("#9bb0ff","#cad7ff","#ffffff","#ffe87c","#ffd2a1","#ff6347"),
    limits = c(-0.4, 2.0),
    guide  = "none") +
  scale_y_reverse(breaks = seq(-10, 20, 5)) +
  scale_x_continuous(breaks = seq(-0.5, 2.5, 0.5)) +
  annotate("text", x = 0.2,  y = 7,    label = "Main Sequence",
           color = "#888888", size = 3.2, angle = -38, fontface = "italic") +
  annotate("text", x = 1.6,  y = -1.5, label = "Red Giants",
           color = "#ff9966", size = 3,   fontface = "italic") +
  annotate("text", x = 0.05, y = 14,   label = "White Dwarfs",
           color = "#aabfff", size = 3,   fontface = "italic") +
  labs(
    title    = "Hertzsprung-Russell Diagram",
    subtitle = paste(nrow(stars), "stars — temperature vs luminosity"),
    x        = "B-V Color Index  (hot → cool)",
    y        = "Absolute Magnitude  (bright ↑)") +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    panel.grid.major = element_line(color = "#1a1a2e"),
    panel.grid.minor = element_blank(),
    text             = element_text(color = "white"),
    axis.text        = element_text(color = "#aaaaaa"),
    plot.title       = element_text(size = 15, face = "bold"),
    plot.subtitle    = element_text(size = 9,  color = "#888888")
  )
ggsave("outputs/hr_diagram.png", hr, width = 10, height = 7, dpi = 180, bg = bg)
cat("Saved outputs/hr_diagram.png\n")


# Vizualisation 2: Star color dist
color_counts <- stars %>%
  filter(spectral_group %in% c("O","B","A","F","G","K","M")) %>%
  group_by(spectral_group) %>%
  summarise(count = n(), .groups = "drop") %>%
  mutate(
    spectral_group = factor(spectral_group, levels = c("O","B","A","F","G","K","M")),
    fill_color = c("#9bb0ff","#aabfff","#cad7ff","#f8f7ff","#ffe87c","#ffd2a1","#ff6347")
  )

bar <- ggplot(color_counts, aes(x = spectral_group, y = count, fill = spectral_group)) +
  geom_col(width = 0.7, show.legend = FALSE) +
  scale_fill_manual(values = setNames(color_counts$fill_color,
                                      color_counts$spectral_group)) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title    = "Stars by Spectral Class",
    subtitle = "M-type red dwarfs dominate the galaxy",
    x        = "Spectral Class",
    y        = "Number of Stars") +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = bg, color = NA),
    panel.background = element_rect(fill = bg, color = NA),
    panel.grid.major = element_line(color = "#1a1a2e"),
    panel.grid.minor = element_blank(),
    text             = element_text(color = "white"),
    axis.text        = element_text(color = "#aaaaaa"),
    plot.title       = element_text(size = 15, face = "bold"),
    plot.subtitle    = element_text(size = 9,  color = "#888888")
  )

ggsave("outputs/spectral_distribution.png", bar,
       width = 8, height = 5, dpi = 180, bg = bg)
cat("Saved in outputs/spectral_distribution.png\n")