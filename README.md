# MRI Radiologist Classifier

## Overview

The script runs a machine learning classifier trained on radiologist scores for MRI scan motion artifact and quality assessment for T1w, T2w, FLAIR 3D isometrics scans. The script processes the output .tsv files from mriqc. Files can be modified or concatenated but must contain the original column names from the mriqc .tsv file. Classification results are outputted to a CSV file.

# Main structure
The repository contains
- **Models directory**: pre-trained models stored in `.rds` format in the 'models/' folder
- Executable `main.R` script: run to implement models on user data
- Configurable `config.R` script: to input user specific parameters


# Workflow overview
- For each MRI sequence (e.g. T1w) and rating type (e.g. motion):
  - a pre-trained model is loaded based on the rating type and sequence
  - data is preprocessed for model input
  - apply the models to classify quality and motion artifact for each scan
  - save the classified results in a CSV file

## User Configuration

### 1. Input data
- **input MRIQC file**: The input file is an MRI Quality Control (MRIQC) dataset that contains metadata and features related to MRI scan quality.

### 2. Path configuration
- Two input parameters should be provided to the `config.R` file:
```
in.data <- 'group_T1w.tsv'
# * input results file from mriqc
out.dir <- 'output/'
# * location where results files will be saved
```
### 3. R Package Installation
- In an R terminal install the package 'pacman':  All other package installations should then be automatically handled by pacman, which will install and load all necessary packages
```
install.packages('pacman')
```

*Note*: if you encounter an error during the 'ranger' package installation you may need to manually install the requisite package 'rcppeigen'.If this is required, it's recommended to install it from the terminal in Linux.

```
# Linux
sudo apt install r-cran-rcppeigen
```

---

## Example usage

1. Configure paths in 'config.R' file
2. Run 'main.R' file

### Output example
```text
---------------------------------------
 MRI Radiologist Classifier
---------------------------------------
 Input MRIQC file: input_data_file.csv
   * Assessing:
     * MRI scans:  150
     * Sequences:  T1w, T2w, FLAIR
     * Rating types:  quality, motion
---------------------------------------

 Assessing T1w scans (n=50):
   * quality model:  MODEL_model-quality_T1w.rds
   * motion model:  MODEL_model-motion_T1w.rds
 Assessing T2w scans (n=50):
   * quality model:  MODEL_model-quality_T2w.rds
   * motion model:  MODEL_model-motion_T2w.rds
 Assessing FLAIR scans (n=50):
   * quality model:  MODEL_model-quality_FLAIR.rds
   * motion model:  MODEL_model-motion_FLAIR.rds
---------------------------------------
 All compatible scans classified!
   * Output file:  results/classification_results.csv
---------------------------------------
