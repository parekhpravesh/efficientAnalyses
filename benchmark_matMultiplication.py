#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri May 29 13:46:42 2026

@author: praveshp
"""

import numpy
import timeit
import statistics
import pickle

# Settings
number     = 1
numRepeats = 10

# Set seed
rng = numpy.random.default_rng(seed=20260526)

# Generate matrices
n = 5000
A = rng.random((n, n))
B = rng.random((n, n))
C = rng.random((n, 1))

# Time matrix multiplications
tMultiply_slow = timeit.repeat("A @ B @ C", globals=globals(), number=number, repeat=numRepeats)
tMultiply_fast = timeit.repeat("A @ (B @ C)", globals=globals(), number=number, repeat=numRepeats)

# Save for future
data_to_save = {
    'tMultiply_slow': tMultiply_slow,
    'tMultiply_fast': tMultiply_fast
}
    
with open('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_matMultiplication_Python.pkl', 'wb') as f:
    pickle.dump(data_to_save, f)