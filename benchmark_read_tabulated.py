#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed May 27 16:43:37 2026

@author: praveshp
"""

# Get packages
import timeit
import pickle
import pandas
import polars
import statistics
import os
import pyarrow.csv as pyarrow_csv
import pyarrow.parquet as pyarrow_parquet

# Resolve paths relative to this script
workDir    = os.path.dirname(os.path.realpath(__file__))
inDir      = os.path.join(workDir, "samples")
resultsDir = os.path.join(workDir, "results")

# Settings
toRead_CSV_DK40_33794_70     = os.path.join(inDir, "ABCDlike_tabulated_DK40_33794_70.csv")
toRead_parquet_DK40_33794_70 = os.path.join(inDir, "ABCDlike_tabulated_DK40_33794_70.parquet")
toRead_CSV_GP_32945_335      = os.path.join(inDir, "ABCDlike_tabulated_GP_32945_335.csv")
toRead_parquet_GP_32945_335  = os.path.join(inDir, "ABCDlike_tabulated_GP_32945_335.parquet")
numRepeats = 10
number = 1

# Examples of reading the datasets and converting to pandas
# data_pandas     = pandas.read_csv(toRead_CSV_DK40_33794_70)
# data_polars     = polars.read_csv(toRead_CSV_DK40_33794_70).to_pandas()
# data_pyarrowCSV = pyarrow_csv.read_csv(toRead_CSV_DK40_33794_70).to_pandas()
# data_pyarrowPQ  = pyarrow_parquet.read_table(toRead_parquet_DK40_33794_70).to_pandas()
# data_pandasPQ   = pandas.read_parquet(toRead_parquet_DK40_33794_70)
# data_polarsPQ   = polars.read_parquet(toRead_parquet_DK40_33794_70).to_pandas()

# Time reading csv using different ways: for ABCDlike_tabulated_DK40_33794_70
t_pandasCSV_DK40_33794_70  = timeit.repeat("pandas.read_csv(toRead_CSV_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)
t_pyarrowCSV_DK40_33794_70 = timeit.repeat("pyarrow_csv.read_csv(toRead_CSV_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)
t_polarsCSV_DK40_33794_70  = timeit.repeat("polars.read_csv(toRead_CSV_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)

# Time using parquet using different ways: for ABCDlike_tabulated_DK40_33794_70
t_pyarrowPQ_DK40_33794_70  = timeit.repeat("pyarrow_parquet.read_table(toRead_parquet_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)
t_pandasPQ_DK40_33794_70   = timeit.repeat("pandas.read_parquet(toRead_parquet_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)
t_polarsPQ_DK40_33794_70   = timeit.repeat("polars.read_parquet(toRead_parquet_DK40_33794_70)", globals=globals(), number=number, repeat=numRepeats)


# Time reading csv using different ways: for ABCDlike_tabulated_GP_32945_335
t_pandasCSV_GP_32945_335  = timeit.repeat("pandas.read_csv(toRead_CSV_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)
t_pyarrowCSV_GP_32945_335 = timeit.repeat("pyarrow_csv.read_csv(toRead_CSV_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)
t_polarsCSV_GP_32945_335  = timeit.repeat("polars.read_csv(toRead_CSV_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)

# Time using parquet using different ways: for ABCDlike_tabulated_GP_32945_335
t_pyarrowPQ_GP_32945_335  = timeit.repeat("pyarrow_parquet.read_table(toRead_parquet_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)
t_pandasPQ_GP_32945_335   = timeit.repeat("pandas.read_parquet(toRead_parquet_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)
t_polarsPQ_GP_32945_335   = timeit.repeat("polars.read_parquet(toRead_parquet_GP_32945_335)", globals=globals(), number=number, repeat=numRepeats)


# Show results
print(f"Time taken: read CSV DK40_33794_70 (pandas):      {statistics.median(t_pandasCSV_DK40_33794_70):.4f}")
print(f"Time taken: read CSV DK40_33794_70 (pyarrow):     {statistics.median(t_pyarrowCSV_DK40_33794_70):.4f}")
print(f"Time taken: read CSV DK40_33794_70 (polars):      {statistics.median(t_polarsCSV_DK40_33794_70):.4f}")

print(f"Time taken: read parquet DK40_33794_70 (pandas):  {statistics.median(t_pandasPQ_DK40_33794_70):.4f}")
print(f"Time taken: read parquet DK40_33794_70 (pyarrow): {statistics.median(t_pyarrowPQ_DK40_33794_70):.4f}")
print(f"Time taken: read parquet DK40_33794_70 (polars):  {statistics.median(t_polarsPQ_DK40_33794_70):.4f}")

print(f"Time taken: read CSV GP_32945_335 (pandas):       {statistics.median(t_pandasCSV_GP_32945_335):.4f}")
print(f"Time taken: read CSV GP_32945_335 (pyarrow):      {statistics.median(t_pyarrowCSV_GP_32945_335):.4f}")
print(f"Time taken: read CSV GP_32945_335 (polars):       {statistics.median(t_polarsCSV_GP_32945_335):.4f}")

print(f"Time taken: read parquet GP_32945_335 (pandas):   {statistics.median(t_pandasPQ_GP_32945_335):.4f}")
print(f"Time taken: read parquet GP_32945_335 (pyarrow):  {statistics.median(t_pyarrowPQ_GP_32945_335):.4f}")
print(f"Time taken: read parquet GP_32945_335 (polars):   {statistics.median(t_polarsPQ_GP_32945_335):.4f}")

# Save for future
data_to_save = {
    't_pandasCSV_DK40_33794_70': t_pandasCSV_DK40_33794_70,
    't_pyarrowCSV_DK40_33794_70': t_pyarrowCSV_DK40_33794_70,
    't_polarsCSV_DK40_33794_70': t_polarsCSV_DK40_33794_70,
    't_pyarrowPQ_DK40_33794_70': t_pyarrowPQ_DK40_33794_70,
    't_pandasPQ_DK40_33794_70': t_pandasPQ_DK40_33794_70,
    't_polarsPQ_DK40_33794_70': t_polarsPQ_DK40_33794_70,
    't_pandasCSV_GP_32945_335': t_pandasCSV_GP_32945_335,
    't_pyarrowCSV_GP_32945_335': t_pyarrowCSV_GP_32945_335,
    't_polarsCSV_GP_32945_335': t_polarsCSV_GP_32945_335,
    't_pyarrowPQ_GP_32945_335': t_pyarrowPQ_GP_32945_335,
    't_pandasPQ_GP_32945_335': t_pandasPQ_GP_32945_335,
    't_polarsPQ_GP_32945_335': t_polarsPQ_GP_32945_335,
}
    
outName = os.path.join(resultsDir, "benchmarks_readTabulated_Python.pkl")
with open(outName, 'wb') as f:
    pickle.dump(data_to_save, f)
    
    
# To open
# with open('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readTabulated_Python.pkl', 'rb') as f:
#     loaded_data = pickle.load(f)
# globals().update(loaded_data)
