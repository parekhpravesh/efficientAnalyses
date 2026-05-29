# Get data.table and arrow packages
if (!require(data.table, quietly = TRUE))
{
  install.packages("data.table")
}
library("data.table")
if (!require(arrow, quietly = TRUE))
{
  install.packages("arrow")
}
library("arrow")

# Benchmark reading of the files
workDir        <- "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/"
fname1         <- "ABCDlike_tabulated_DK40_33794_70"
fname2         <- "ABCDlike_tabulated_GP_32945_335"
numRepeats     <- 10

# Initialize
tCSV_readCSV_DK40_33794_70 <- vector("numeric", length = numRepeats)
tCSV_fread_DK40_33794_70   <- vector("numeric", length = numRepeats)
tCSV_arrow_DK40_33794_70   <- vector("numeric", length = numRepeats)
tParquet_DK40_33794_70     <- vector("numeric", length = numRepeats)

tCSV_readCSV_GP_32945_335 <- vector("numeric", length = numRepeats)
tCSV_fread_GP_32945_335   <- vector("numeric", length = numRepeats)
tCSV_arrow_GP_32945_335   <- vector("numeric", length = numRepeats)
tParquet_GP_32945_335     <- vector("numeric", length = numRepeats)

toRead_CSV     <- file.path(workDir, paste0(fname1, ".csv"))
toRead_parquet <- file.path(workDir, paste0(fname1, ".parquet"))
for (rep in 1:numRepeats)
{
  # Read using R's base read.csv
  tCSV_readCSV_DK40_33794_70[rep] <- system.time(read.csv(toRead_CSV))["elapsed"]
  
  # Read using data table's fread
  tCSV_fread_DK40_33794_70[rep] <- system.time(fread(toRead_CSV))["elapsed"]
  
  # Read using arrow's read csv
  tCSV_arrow_DK40_33794_70[rep] <- system.time(read_csv_arrow(toRead_CSV))["elapsed"]
  
  # Finally, read using parquet format
  tParquet_DK40_33794_70[rep] <- system.time(read_parquet(toRead_parquet))["elapsed"]
}

toRead_CSV     <- file.path(workDir, paste0(fname2, ".csv"))
toRead_parquet <- file.path(workDir, paste0(fname2, ".parquet"))
for (rep in 1:numRepeats)
{
  # Read using R's base read.csv
  tCSV_readCSV_GP_32945_335[rep] <- system.time(read.csv(toRead_CSV))["elapsed"]
  
  # Read using data table's fread
  tCSV_fread_GP_32945_335[rep] <- system.time(fread(toRead_CSV))["elapsed"]
  
  # Read using arrow's read csv
  tCSV_arrow_GP_32945_335[rep] <- system.time(read_csv_arrow(toRead_CSV))["elapsed"]
  
  # Finally, read using parquet format
  tParquet_GP_32945_335[rep] <- system.time(read_parquet(toRead_parquet))["elapsed"]
}

save.image(file="/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readTabulated_R.rdata")
