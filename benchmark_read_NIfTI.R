if (!require("oro.nifti", quietly = TRUE))
{
  install.packages("oro.nifti")
}
library(oro.nifti)

if (!require("RNifti", quietly = TRUE))
{
  install.packages("RNifti")
}
library(RNifti)

if (!require("this.path", quietly = TRUE))
{
  install.packages("this.path")
}
library(this.path)

if (!require("BiocManager", quietly = TRUE))
{
 install.packages("BiocManager")
}

if (!require("rhdf5", quietly = TRUE))
{
 BiocManager::install("rhdf5")
}
library(rhdf5)

# Get the path of this script
workDir    <- this.path::this.dir()
inDir      <- file.path(workDir, "samples", "NIfTI")
resultsDir <- file.path(workDir, "results")
dir.create(resultsDir, showWarnings = FALSE, recursive = TRUE)

# Paths to concatenated data
file_compressed   <- file.path(inDir, "concatedData_73_compressed.mat")
file_uncompressed <- file.path(inDir, "concatedData_73_uncompressed.mat")

# Make a list of NIfTI files
listNIfTI <- list.files(inDir, pattern = glob2rx("*.nii.*"))

# Initialize
numRepeats            <- 10
t_readNIfTI_oro       <- vector("numeric", length = numRepeats)
t_readNIfTI_rnifti    <- vector("numeric", length = numRepeats)
t_rhdf5_compressed    <- vector("numeric", length = numRepeats)
t_rhdf5_uncompressed  <- vector("numeric", length = numRepeats)

for (rep in 1:numRepeats)
{
  # Read NIfTI images
  t_readNIfTI_oro[rep]      <- system.time(for (file in listNIfTI){nii <- readNIfTI(file.path(inDir, file))})["elapsed"]
  t_readNIfTI_rnifti[rep]   <- system.time(for (file in listNIfTI){nii <- readNifti(file.path(inDir, file))})["elapsed"]
  t_rhdf5_compressed[rep]   <- system.time(h5read(file_compressed,   name = "/"))["elapsed"]
  t_rhdf5_uncompressed[rep] <- system.time(h5read(file_uncompressed, name = "/"))["elapsed"]
}

# Show results
cat(paste0("Time taken: readNIfTI (oro): ",       round(median(t_readNIfTI_oro), 4), "\n"))
cat(paste0("Time taken: readNifti (RNifti): ",    round(median(t_readNIfTI_rnifti), 4), "\n"))
cat(paste0("Time taken: h5read (compressed): ",   round(median(t_rhdf5_compressed), 4), "\n"))
cat(paste0("Time taken: h5read (uncompressed): ", round(median(t_rhdf5_uncompressed), 4), "\n"))


# Clear up and save
rm(nii)
save.image(file=file.path(resultsDir, "benchmarks_readNIfTI_R.rdata"))