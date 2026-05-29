if (!require(oro.nifti, quietly = TRUE))
{
  install.packages("oro.nifti")
}
library(oro.nifti)

if (!require(RNifti, quietly = TRUE))
{
  install.packages("RNifti")
}
library(RNifti)

if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("rhdf5")
library(rhdf5)

# Benchmark reading different HDF5 formats
dir_NIfTI         <- "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/"
file_compressed   <- "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/concatedData_73_compressed.mat"
file_uncompressed <- "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/concatedData_73_uncompressed.mat"
numRepeats        <- 10

# Make a list of NIfTI files
listNIfTI <- list.files(dir_NIfTI, pattern = "*.nii.*")

# Initialize
t_readNIfTI_oro       <- vector("numeric", length = numRepeats)
t_readNIfTI_rnifti    <- vector("numeric", length = numRepeats)
t_rhdf5_compressed    <- vector("numeric", length = numRepeats)
t_rhdf5_uncompressed  <- vector("numeric", length = numRepeats)

for (rep in 1:numRepeats)
{
  # Read NIfTI images
  t_readNIfTI_oro[rep]      <- system.time(for (file in listNIfTI){nii <- readNIfTI(file.path(dir_NIfTI, file))})
  t_readNIfTI_rnifti[rep]   <- system.time(for (file in listNIfTI){nii <- readNifti(file.path(dir_NIfTI, file))})
  t_rhdf5_compressed[rep]   <- system.time(h5read(file_compressed,   name = "/"))["elapsed"]
  t_rhdf5_uncompressed[rep] <- system.time(h5read(file_uncompressed, name = "/"))["elapsed"]
}

rm(nii)
save.image(file="/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readNIfTI_R.rdata")