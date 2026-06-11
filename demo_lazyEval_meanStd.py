#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu May 28 18:06:26 2026

@author: praveshp
"""

import h5py
import dask
import dask.array
import dask.dataframe
import os

# Which file to work on; variable is called data
workDir = os.path.dirname(os.path.realpath(__file__))
toWork  = os.path.join(workDir, "samples", "NIfTI", "concatedData_73_uncompressed.mat")

# Keep file open while reading
with h5py.File(toWork, mode='r') as f:
    delayed_df = dask.array.from_array(f['/data'], chunks='auto')

    # Define our lazy mean and standard functions
    lazy_mean = delayed_df.mean(axis=1)
    lazy_std  = delayed_df.std(axis=1, ddof=1)

    # Get results
    [mean, std] = dask.compute(lazy_mean, lazy_std)


# Show the results
print(f"Mean of the data is: {mean}")
print(f"Standard deviation of the data is: {std}")

# Older solution:
# Open the file
# f = h5py.File(toWork, mode='r')
# [rows, cols] = f['/data'].shape
# value = dask.delayed(f['/data'])
# delayed_df = dask.array.from_delayed(value, (rows,cols), dtype=float)

# Define our lazy mean and standard functions
# lazy_mean = delayed_df.mean(axis=1)
# lazy_std  = delayed_df.std(axis=1, ddof=1)

# Get results
# [mean, std] = dask.compute(lazy_mean, lazy_std)

# Close the file
# f.close()