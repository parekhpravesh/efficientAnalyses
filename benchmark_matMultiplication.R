# Demo: (AB)C vs A(BC)
if (!require("this.path", quietly = TRUE))
{
  install.packages("this.path")
}
library(this.path)

# Get the path of this script
workDir    <- this.path::this.dir()
resultsDir <- file.path(workDir, "results")
dir.create(resultsDir, showWarnings = FALSE, recursive = TRUE)

# Set seed
set.seed(20260529)

# Prepare X variable and true beta coefficients
n = 5000;
A = matrix(runif(n * n), nrow = n, ncol = n)
B = matrix(runif(n * n), nrow = n, ncol = n)
C = matrix(runif(n), nrow = n, ncol = 1)

numRepeats     <- 10
tMultiply_slow <- vector("numeric", length = numRepeats)
tMultiply_fast <- vector("numeric", length = numRepeats)

for (rep in 1:numRepeats)
{
  tMultiply_slow[rep] <- system.time(A %*% B %*% C)["elapsed"]
  tMultiply_fast[rep] <- system.time(A %*% (B %*% C))["elapsed"]
}

# Show results
cat(paste0("Time taken: slow multiplication: ", round(median(tMultiply_slow), 4), "\n"))
cat(paste0("Time taken: fast multiplication: ", round(median(tMultiply_fast), 4), "\n"))

# Clear up and save
rm(A, B, C)
save.image(file=file.path(resultsDir, "benchmarks_matMultiply_R.rdata"))