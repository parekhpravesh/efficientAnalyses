if (!require("this.path", quietly = TRUE))
{
  install.packages("this.path")
}
library(this.path)

if (!requireNamespace("BiocManager", quietly = TRUE))
{
  install.packages("BiocManager")
}
if (!require("DelayedMatrixStats", quiety = TRUE))
{
 BiocManager::install("DelayedMatrixStats")
}
if (!require("HDF5Array", quiety = TRUE))
{
 BiocManager::install("HDF5Array")
}

library(HDF5Array)
library(DelayedMatrixStats)
library(DelayedArray)

# Load HDF5 file as a DelayedArray; the variable of interest is called data
workDir         <- this.path::this.dir()
inputFile       <- file.path(workDir, "samples", "NIfTI", "concatedData_73_uncompressed.mat")
dataset_delayed <- HDF5Array(inputFile, name = "data")

# Calculate mean, per column (i.e., voxel-wise)
voxelAverages <- colMeans2(dataset_delayed)

# Calculate standard deviation per column (i.e., voxel-wise)
voxelStd <- colSds(dataset_delayed)

# Show results
cat(paste0("Mean of the data is: ",               round(voxelAverages, 4), "\n"))
cat(paste0("Standard deviation of the data is: ", round(voxelStd, 4), "\n"))
