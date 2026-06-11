#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 29 15:11:06 2026

@author: praveshp
"""

import numpy
import timeit
import statsmodels
import sklearn
import os
import statistics
import pickle

# Resolve paths relative to this script
workDir    = os.path.dirname(os.path.realpath(__file__))
resultsDir = os.path.join(workDir, "results")

if not os.path.exists(resultsDir):
    os.makedirs(resultsDir)

# Settings
number     = 1
numRepeats = 10

# Set seed
rng = numpy.random.default_rng(seed=20260526)

# Generate matrices
n = 30000
p = 50
v = 1000

X     = numpy.column_stack((numpy.ones(n), rng.random((n, p-1))))
beta  = rng.random((p, v))
noise = rng.random((n, 1))
y     = X @ beta + noise

# Code for statsmodel
# Even though multiple y can be given at the same time, it throws an error when calling summary
code_loop_statsmodel = """
for cols in range(y.shape[1]):
    mdl = statsmodels.api.OLS(y[:,cols], X).fit()
"""

# Code for looping over scikitlearn
code_loop_scikitlearn = """
for cols in range(y.shape[1]):
    mdl = sklearn.linear_model.LinearRegression(fit_intercept=False).fit(X, y[:,cols])"""

# Benchmark scikit learn
t_scikitLearn = timeit.repeat("sklearn.linear_model.LinearRegression(fit_intercept=False).fit(X, y)", globals=globals(), number=number, repeat=numRepeats)

# Benchmark looping over scikit learn
t_scikitLearn_loop = timeit.repeat(code_loop_scikitlearn, globals=globals(), number=number, repeat=numRepeats)

# Benchmark using statsmodel
t_statsmodel = timeit.repeat(code_loop_statsmodel, globals=globals(), number=number, repeat=numRepeats)

# Benchmark using normal equations
t_normalEqn = timeit.repeat("numpy.linalg.pinv(X.transpose() @ X) @ X.transpose() @ y", globals=globals(), number=number, repeat=numRepeats)

# Benchmark using normal equations without inverse
t_normalEqn_withoutInv = timeit.repeat("numpy.linalg.solve(X.transpose() @ X, X.transpose() @ y)", globals=globals(), number=number, repeat=numRepeats)

# Benchmark using linalg.lstsq
t_lstsqSolve = timeit.repeat("numpy.linalg.lstsq(X, y)", globals=globals(), number=number, repeat=numRepeats)

# Show results
print(f"Time taken: statsmodel (loop):              {statistics.median(t_statsmodel):.4f}")
print(f"Time taken: sklearn (loop):                 {statistics.median(t_scikitLearn_loop):.4f}")
print(f"Time taken: sklearn (without loop):         {statistics.median(t_scikitLearn):.4f}")
print(f"Time taken: linalg.lstsqsolve:              {statistics.median(t_lstsqSolve):.4f}")
print(f"Time taken: normal equation (with pinv):    {statistics.median(t_normalEqn):.4f}")
print(f"Time taken: normal equation (without pinv): {statistics.median(t_normalEqn_withoutInv):.4f}")

# Save for future
data_to_save = {
    't_scikitLearn': t_scikitLearn,
    't_scikitLearn_loop': t_scikitLearn_loop,
    't_statsmodel': t_statsmodel,
    't_normalEqn': t_normalEqn,
    't_normalEqn_withoutInv': t_normalEqn_withoutInv,
    't_lstsqSolve': t_lstsqSolve
}

outName = os.path.join(resultsDir, "benchmarks_linearRegression_Python.pkl")
with open(outName, 'wb') as f:
    pickle.dump(data_to_save, f)