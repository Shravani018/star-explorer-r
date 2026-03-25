# 🌟 star-explorer-r

An astronomical data visualization project built in R, exploring ~120,000 stars from the HYG Star Database.

---

## Overview

A 4-script R pipeline that transforms raw star catalog data into visualizations, covering spectral distribution, sky mapping, brightness physics, and nearest stellar neighbours.

---

## Outputs

| Script | Output(s) | Description |
|---|---|---|
| `01_star_exploration.R` | `hr_diagram.png`, `spectral_distribution.png` | Hertzsprung-Russell diagram + spectral class bar chart |
| `02_sky_heatmap.R` | `sky_heatmap.png` | Full-sky star density heatmap (Milky Way structure) |
| `03_distance_magnitude.R` | `distance_magnitude.png` | Apparent magnitude vs. distance scatter plot |
| `04_nearest_stars.R` | `nearest_stars.png` | Horizontal bar chart of the 20 nearest stellar neighbours |

**Hertzsprung-Russell Diagram** - 96,198 stars plotted by temperature vs. luminosity, revealing the main sequence, red giants, and white dwarfs.

**Stars by Spectral Class** -  K-type stars dominate this magnitude-limited catalog; O-type stars are extremely rare.

**Full Sky Star Density Map** - 41,149 stars brighter than magnitude 8, showing the Milky Way's galactic plane as a bright band.

**Star Brightness vs Distance** - Demonstrates the inverse-square law, with scatter revealing intrinsically luminous distant stars.

**Our 20 Nearest Stellar Neighbours** - Proxima Centauri leads at 4.23 ly; bar color encodes stellar temperature.

---

## Dataset

**HYG Star Database v4.1** - a compiled catalog merging the Hipparcos, Yale Bright Star, and Gliese/Jahreiß catalogs.

- Source: [astronexus/HYG-Database](https://github.com/astronexus/HYG-Database)
- File: `dataset/hygdata_v41.csv`


