# 🌍 Poland Biodiversity Shiny Dashboard - Developer Documentation

## 🏗️ Architecture Overview

### 📦 Module Structure
The application follows a modular architecture with four main modules:
- **🔍 Filter Module**: Manages data filtering controls
- **🗺️ Map Module**: Handles the interactive map visualization
- **📍 Locality Module**: Controls locality frequency analysis
- **📊 Timeline Module**: Manages temporal visualizations


### ⚡ Data Flow
1. Raw data → data_processing.R → Cleaned dataset
2. User input → Filter Module → Filtered dataset
3. Filtered dataset → Other modules → Visualizations

## 💻 Development Setup

### 🛠️ Local Development Environment
1. Clone the repository
2. Create an RProject in the root directory
3. Install required packages:
```r
install.packages(c(
  "shiny", "bslib", "tidyverse", "tools", "thematic",
  "bsicons", "fontawesome", "plotly", "ggthemes",
  "shinyBS", "data.table", "vroom", "ggmap",
  "leaflet", "hrbrthemes", "reactable", "htmltools"
))
```
## 📁 Project Structure
```r 

├── app.R                  # Application entry point
│── Tests/   
│       ├── test_functions.R   # Test file
│── data_extract_script.R   # Extracting Poland Data
├── R/                     # Core application logic
│   ├── data_processing.R  # Data transformation pipeline
│   ├── utils.R           # Shared utilities and constants
│   └── modules/          # Shiny modules
│       ├── filter_module.R    # Data filtering logic
│       ├── map_module.R      # Map visualization
│       ├── locality_module.R  # Locality analysis
│       └── timeline_module.R  # Time-based visualizations
└── www/                   # Static assets (CSS and Icon)
```

#### You can visit the dashboard [here]( https://sajadghashami.shinyapps.io/Appsilon/)

Enjoy <br>
Sajad
