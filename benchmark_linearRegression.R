# Install and load required libraries
if (!require("pracma", quietly = TRUE))
{
  install.packages("pracma")
}
if (!require("this.path", quietly = TRUE))
{
  install.packages("this.path")
}
library(pracma)
library(this.path)

# Get the path of this script
workDir    <- this.path::this.dir()
resultsDir <- file.path(workDir, "results")
dir.create(resultsDir, showWarnings = FALSE, recursive = TRUE)

# Settings
n = 30000;
p = 50;
v = 1000;

# Set seed
set.seed(20260526)

# Prepare X variable and true beta coefficients
X    = cbind(rep(1, times = n), matrix(runif(n * (p-1)), nrow = n, ncol = (p-1)))
beta = matrix(runif(p * v), nrow = p, ncol = v)

# Adding the same amount of noise everywhere to keep RAM usage minimal
noise = runif(n);

# y = Xb + e
y <- X %*% beta + noise

# Now benchmark solving for beta coefficients
# Initialize
numRepeats                      <- 10
t_linRegression_lm              <- vector("numeric", length = numRepeats)
t_linRegression_lm_loop         <- vector("numeric", length = numRepeats)
t_linRegression_normalEqn       <- vector("numeric", length = numRepeats)
t_linRegression_normalEqn_noInv <- vector("numeric", length = numRepeats)
t_linRegression_QRsolve         <- vector("numeric", length = numRepeats)

for (rep in 1:numRepeats)
{
  # Fit all y together using lm
  t_linRegression_lm[rep]  <- system.time(lm(y ~ -1 + X))["elapsed"]

  # Fit each y separately using lm
  t_linRegression_lm_loop[rep] <- system.time(
    {
      for (cols in 1:v)
      {
       lm(y[,cols] ~ -1 + X)
      }
    }
  )["elapsed"]

  # Normal equations with and without inverse
  t_linRegression_normalEqn[rep]        <- system.time(pinv(t(X) %*% X) %*% (t(X) %*% y))["elapsed"]
  t_linRegression_normalEqn_noInv[rep]  <- system.time(solve(t(X) %*% X, t(X) %*% y))["elapsed"]

  # Using QR solve
  t_linRegression_QRsolve[rep]          <- system.time(qr.solve(X, y))["elapsed"]
}

# Show results
cat(paste0("Time taken: fitlm (loop): ",                    round(median(t_linRegression_lm_loop), 4), "\n"))
cat(paste0("Time taken: fitlm (without loop): ",            round(median(t_linRegression_lm), 4), "\n"))
cat(paste0("Time taken: qr.solve: ",                        round(median(t_linRegression_QRsolve), 4), "\n"))
cat(paste0("Time taken: normal equation (with pinv): ",     round(median(t_linRegression_normalEqn), 4), "\n"))
cat(paste0("Time taken: normal equation (without pinv): ",  round(median(t_linRegression_normalEqn_noInv), 4), "\n"))


# Clear up and save
rm(X, y, beta, noise)
save.image(file=file.path(resultsDir, "benchmarks_linRegression_R.rdata"))