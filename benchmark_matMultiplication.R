# Demo: (AB)C vs A(BC)
n = 5000;

# Set seed
set.seed(20260529)

# Prepare X variable and true beta coefficients
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

rm(A, B, C)
save.image(file="/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_matMultiply_R.rdata")

# # Create synthetic data for linear regression
# n = 3000;
# p = 50;
# v = 20000;
# 
# # Set seed
# set.seed(20260529)
# 
# # Prepare X variable and true beta coefficients
# X    = matrix(runif(n * p), nrow = n, ncol = p)
# beta = matrix(runif(p * v), nrow = p, ncol = v)
# 
# # Adding the same amount of noise everywhere to keep RAM usage minimal
# noise = runif(n);
# 
# # y = Xb + e
# y <- X %*% beta + noise;
# 
# # Now benchmark solving for beta coefficients
# # Initialize
# numRepeats             <- 10
# t_linRegression_slow   <- vector("numeric", length = numRepeats)
# t_linRegression_fast   <- vector("numeric", length = numRepeats)
# t_linRegression_solve1 <- vector("numeric", length = numRepeats)
# t_linRegression_solve2 <- vector("numeric", length = numRepeats)
# 
# for (rep in 1:numRepeats)
# {
#   t_linRegression_slow[rep]   <- system.time(pinv(t(X) %*% X) %*% t(X) %*% y)["elapsed"]
#   t_linRegression_fast[rep]   <- system.time(pinv(t(X) %*% X) %*% (t(X) %*% y))["elapsed"]
#   t_linRegression_solve1[rep] <- system.time(solve(t(X) %*% X) %*% (t(X) %*% y))["elapsed"]
#   t_linRegression_solve2[rep] <- system.time(solve(t(X) %*% X, t(X) %*% y))["elapsed"]
# }