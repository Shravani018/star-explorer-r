#-----------------------------------------------
# Runs the full pipeline and saves all outputs to outputs/
#-----------------------------------------------

if (!dir.exists("outputs")) dir.create("outputs")
scripts <- c(
  "scripts/01_star_exploration.R",
  "scripts/02_sky_heatmap.R",
  "scripts/03_distance_magnitude.R",
  "scripts/04_nearest_stars.R")
for (script in scripts) {
  cat("\nRunning", script, "\n")
  source(script)}
cat("\nDone outputs saved to outputs/\n")