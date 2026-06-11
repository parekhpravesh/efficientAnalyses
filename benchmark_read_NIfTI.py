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
import os

# Resolve paths relative to this script
workDir    = os.path.dirname(os.path.realpath(__file__))
inDir      = os.path.join(workDir, "samples", "NIfTI")
resultsDir = os.path.join(workDir, "results")

if not os.path.exists(resultsDir):
    os.makedirs(resultsDir)

# Settings
numRepeats = 10
number = 1

# File paths
mat_compressed   = os.path.join(inDir, "concatedData_73_compressed.mat")
mat_uncompressed = os.path.join(inDir, "concatedData_73_uncompressed.mat")

# Define the loop for reading multiple NIfTI files
listNIfTI = glob.glob(inDir, "*.nii*")
code_loop = """
for file in listNIfTI:
    nii = nibabel.load(file).get_fdata()
"""

# Define code for reading h5 files
code_h5compressed = """
f = h5py.File(mat_compressed, 'r')
variables = {name: f[name][()] for name in f.keys()}
f.close()
"""

code_h5uncompressed = """
f = h5py.File(mat_uncompressed, 'r')
variables = {name: f[name][()] for name in f.keys()}
f.close()
"""

# Time the reading of NIfTI
t_readNIfTI = timeit.repeat(code_loop, globals=globals(), number=number, repeat=numRepeats)

# Time the reading of concatenated compressed h5
t_readCompressed   = timeit.repeat(code_h5compressed,   globals=globals(), number=number, repeat=numRepeats)
t_readUncompressed = timeit.repeat(code_h5uncompressed, globals=globals(), number=number, repeat=numRepeats)

# Show results
print(f"Time taken: load (nibabel):     {statistics.median(t_readNIfTI):.4f}")
print(f"Time taken: h5py compressed:    {statistics.median(t_readCompressed):.4f}")
print(f"Time taken: h5py uncompressed:  {statistics.median(t_readUncompressed):.4f}")

# Save for future
data_to_save = {
    't_readNIfTI': t_readNIfTI,
    't_readCompressed': t_readCompressed,
    't_readUncompressed': t_readUncompressed
}
    
outName = os.path.join(resultsDir, "benchmarks_readNIfTI_Python.pkl")
with open(outName, 'wb') as f:
    pickle.dump(data_to_save, f)