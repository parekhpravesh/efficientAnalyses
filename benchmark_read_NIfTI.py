#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 28 14:30:42 2026

@author: praveshp
"""

# Get packages
import timeit
import pickle
import nibabel
import glob
import h5py
import statistics

# Settings
numRepeats = 10
number = 1

# File paths
mat_compressed   = "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/concatedData_73_compressed.mat"
mat_uncompressed = "/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/concatedData_73_uncompressed.mat"

# Define the loop for reading multiple NIfTI files
listNIfTI = glob.glob("/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI/*.nii*")
code_loop = """
for file in listNIfTI:
    nii = nibabel.load(file).get_fdata()
"""

# Define code for reading h5 files
code_h5compressed = """
f = h5py.File(mat_compressed, 'r')
variables = {name: f[name][()] for name in f.keys()}
"""

code_h5uncompressed = """
f = h5py.File(mat_uncompressed, 'r')
variables = {name: f[name][()] for name in f.keys()}
"""

# Time the reading of NIfTI
t_readNIfTI = timeit.repeat(code_loop, globals=globals(), number=number, repeat=numRepeats)

# Time the reading of concatenated compressed h5
t_readCompressed   = timeit.repeat(code_h5compressed,   globals=globals(), number=number, repeat=numRepeats)
t_readUncompressed = timeit.repeat(code_h5uncompressed, globals=globals(), number=number, repeat=numRepeats)

# Save for future
data_to_save = {
    't_readNIfTI': t_readNIfTI,
    't_readCompressed': t_readCompressed,
    't_readUncompressed': t_readUncompressed
}
    
with open('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readNIfTI_Python.pkl', 'wb') as f:
    pickle.dump(data_to_save, f)