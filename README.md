# efficientAnalyses

Code and tutorials demonstrating how to perform large-scale statistical analyses in a computationally efficient manner

# OHBM 2026 Educational Course

If you are attending the OHBM 2026 educational course `The Research Lifecycle: A Primer on Open and Sustainable Science Practices`, below are the instructions for running the code on [NeuroDesk](https://neurodesk.org/).

1.  Go to [`play-europe.neurodesk.org`](play-europe.neurodesk.org) [thank you to Steffen Bollmann!] After you have successfully logged in, you will be greeted with a window showing a variety of applications that you can launch

2.  Launch a terminal

3.  All the required code and supporting files are available here: `/data/teaching/parekhpravesh/efficientAnalyses`

    ```{bash}
    cd /data/teaching/parekhpravesh/efficientAnalyses
    ```

## Running Python code

1.  Set up virtual environment:

    ```{bash}
    mamba env create -f environment.yml
    ```

    The new environment will be named `efficient`

2.  Change the shell:

    ```{bash}
    eval "$(mamba shell hook --shell bash)"
    ```

3.  Activate your new environment:

    ```{bash}
    mamba activate efficient
    ```

4.  Run code!

    For example, to benchmark the code for different ways of reading NIfTI files, run:

    ```{bash}
    python benchmark_read_NIfTI.py
    ```

    The output should look something like:

    ``` text
    python benchmark_read_NIfTI.py
    Time taken: load (nibabel):     3.7589
    Time taken: h5py compressed:    1.5186
    Time taken: h5py uncompressed:  0.2905
    ```

5.  The following code can be run:

    - `benchmark_linearRegression.py`: benchmark different ways of doing linear regression [warning, this can take a while to run!]
    - `benchmark_matMultiplication.py`: benchmark different ways of performing matrix multiplication
    - `benchmark_read_NIfTI.py`: benchmark reading NIfTI files and HDF5 concatenated data format
    - `benchmark_read_tabulated.py`: benchmark different ways of reading csv and parquet files
    - `demo_lazyEval_meanStd.py`: shows an example of lazy loading of concatenated data to estimate mean and standard deviation for every voxel/vertex/connection

6.  To quit the environment:

    ```{bash}
    mamba deactivate
    ```

## Running R code

The first three steps are the same as Python code, so these can be skipped if you have already done them before.

1.  Set up virtual environment:

    ```{bash}
    mamba env create -f environment.yml
    ```

    The new environment will be named `efficient`

2.  Change the shell:

    ```{bash}
    eval "$(mamba shell hook --shell bash)"
    ```

3.  Activate your new environment:

    ```{bash}
    mamba activate efficient
    ```

4.  Run code!

    For example, to benchmark the code for different ways of reading NIfTI files, run:

    ```{bash}
    Rscript benchmark_read_NIfTI.R
    ```

    The output should look something like:

    ``` text
    Rscript benchmark_read_NIfTI.R
    Time taken: readNIfTI (oro): 24.9335
    Time taken: readNifti (RNifti): 3.761
    Time taken: h5read (compressed): 1.8315
    Time taken: h5read (uncompressed): 0.611
    ```

    The following code can be run:

    - `benchmark_linearRegression.R`: benchmark different ways of doing linear regression [warning, this can take a while to run!]
    - `benchmark_matMultiplication.R`: benchmark different ways of performing matrix multiplication
    - `benchmark_read_NIfTI.R`: benchmark reading NIfTI files and HDF5 concatenated data format
    - `benchmark_read_tabulated.R`: benchmark different ways of reading csv and parquet files
    - `demo_lazyEval_meanStd.R`: shows an example of lazy loading of concatenated data to estimate mean and standard deviation for every voxel/vertex/connection

5.  To quit the environment:

    ```{bash}
    mamba deactivate
    ```

## Running MATLAB code

The MATLAB code is compiled, so it does not require an active MATLAB license. However, we do need MATLAB runtime. The current code was compiled using MATLAB R2024b.

1.  Launch the MATLAB R2024b runtime singularity image:

    ```{bash}
    apptainer shell /cvmfs/neurodesk.ardc.edu.au/containers/matlabruntime_2024b_20260521/matlabruntime_2024b_20260521.simg
    ```

2.  Change the directory:

    ```{bash}
    cd /data/teaching/parekhpravesh/efficientAnalyses
    ```

3.  To run code, call the shell script `run_efficientShowcase.sh` located in the folder `/data/teaching/parekhpravesh/efficientAnalyses/efficientShowcase_App_glnx64`. The MATLAB runtime path needs to be additionally provided.

    For example, to benchmark the code for different ways of reading NIfTI files, run:

    ```{bash}
    ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark nifti /data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI /data/teaching/parekhpravesh/efficientAnalyses/results
    ```

    In the example above, `./efficientShowcase_App_glnx64/run_efficientShowcase.sh` is pointing to the `run_efficientShowcase.sh` shell script by providing its relative path. The path `/opt/matlabruntime/R2024b` is where the MATLAB runtime is located. The third and fourth parameters `benchmark` and `nifti` determines what is going to be executed (in this case, the code `benchmark_read_NIfTI.m`). The second to last parameter `/data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI` points the code to where the sample NIfTI files are. The last parameter `/data/teaching/parekhpravesh/efficientAnalyses/results` indicates where the results are saved.

    The output should look something like:

    ``` text
    Time taken: read NIfTI: 5.2153
    Time taken: read compressed HDF5 (load): 1.5521
    Time taken: read uncompressed HDF5 (load): 0.34318
    Time taken: read compressed HDF5 (h5): 1.5624
    Time taken: read uncompressed HDF5 (h5): 0.35013
    ```

4.  The following code can be run (these are full commands which can be copy-pasted in the terminal to run):

    - Benchmark different ways of performing linear regression:

      ```{bash}
      ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark regression /data/teaching/parekhpravesh/efficientAnalyses/results
      ```

    - Benchmark different ways of performing matrix multiplication:

      ```{bash}
      ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark multiplication /data/teaching/parekhpravesh/efficientAnalyses/results
      ```

    - Benchmark reading NIfTI files and HDF5 concatenated data format:

      ```{bash}
      ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark nifti /data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI /data/teaching/parekhpravesh/efficientAnalyses/results
      ```

    - Benchmark different ways of reading csv and parquet files:

      ```{bash}
      ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark tabulated /data/teaching/parekhpravesh/efficientAnalyses/samples /data/teaching/parekhpravesh/efficientAnalyses/results
      ```

    - Show an example of lazy loading of concatenated data to estimate mean and standard deviation for every voxel/vertex/connection:

      ```{bash}
      ./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b demo lazy /data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI
      ```

5.  To quit the apptainer shell, press `Ctrl + D`

## All outputs

### Python benchmarks

1.  `python benchmark_read_tabulated.py`

    > Time taken: read CSV DK40_33794_70 (pandas): 0.5168
    >
    > Time taken: read CSV DK40_33794_70 (pyarrow): 0.1014
    >
    > Time taken: read CSV DK40_33794_70 (polars): 0.0565
    >
    > Time taken: read parquet DK40_33794_70 (pandas): 0.0352
    >
    > Time taken: read parquet DK40_33794_70 (pyarrow): 0.0267
    >
    > Time taken: read parquet DK40_33794_70 (polars): 0.0347
    >
    > Time taken: read CSV GP_32945_335 (pandas): 2.4182
    >
    > Time taken: read CSV GP_32945_335 (pyarrow): 0.8239
    >
    > Time taken: read CSV GP_32945_335 (polars): 0.2363
    >
    > Time taken: read parquet GP_32945_335 (pandas): 0.1718
    >
    > Time taken: read parquet GP_32945_335 (pyarrow): 0.0956
    >
    > Time taken: read parquet GP_32945_335 (polars): 0.1163

2.  `python benchmark_read_NIfTI.py`

    > Time taken: load (nibabel): 3.7589
    >
    > Time taken: h5py compressed: 1.5186
    >
    > Time taken: h5py uncompressed: 0.2905

3.  `python benchmark_matMultiplication.py`

    > Time taken: slow multiplication: 4.3037
    >
    > Time taken: fast multiplication: 0.0791

4.  `python benchmark_linearRegression.py`

    > Time taken: statsmodel (loop): 790.4925
    >
    > Time taken: sklearn (loop): 304.8564
    >
    > Time taken: sklearn (without loop): 5.0831
    >
    > Time taken: linalg.lstsqsolve: 5.4595
    >
    > Time taken: normal equation (with pinv): 1.3450
    >
    > Time taken: normal equation (without pinv): 2.4025

5.  `python demo_lazyEval_meanStd.py`

    > Mean of the data is (showing first 5 values): [0.5241272 0.4819637 0.47562316 0.49318522 0.46541995]
    >
    > Standard deviation of the data is (showing first 5 values): [0.26059029 0.276205 0.29182348 0.29652286 0.2833085 ]

### R benchmarks

1.  `Rscript benchmark_read_tabulated.R`

    > Time taken: read.csv DK40_33794_70: 7.727
    >
    > Time taken: fread DK40_33794_70: 0.064
    >
    > Time taken: read_csv_arrow DK40_33794_70: 0.054
    >
    > Time taken: read_parquet DK40_33794_70: 0.0155
    >
    > Time taken: read.csv GP_32945_335: 53.8785
    >
    > Time taken: fread GP_32945_335: 0.269
    >
    > Time taken: read_csv_arrow GP_32945_335: 0.8475
    >
    > Time taken: read_parquet GP_32945_335: 0.042

2.  `Rscript benchmark_read_NIfTI.R`

    > Time taken: readNIfTI (oro): 24.9335
    >
    > Time taken: readNifti (RNifti): 3.761
    >
    > Time taken: h5read (compressed): 1.8315
    >
    > Time taken: h5read (uncompressed): 0.611

3.  `Rscript benchmark_matMultiplication.R`

    > Time taken: slow multiplication: 4.4785
    >
    > Time taken: fast multiplication: 0.237

4.  `Rscript benchmark_linearRegression.R`

    > Time taken: fitlm (loop): 544.675
    >
    > Time taken: fitlm (without loop): 20.5105
    >
    > Time taken: qr.solve: 10.0345
    >
    > Time taken: normal equation (with pinv): 0.4085
    >
    > Time taken: normal equation (without pinv): 0.199

5.  `Rscript demo_lazyEval_meanStd.R`

    > Mean of the data is (showing first 5 values): 0.5241
    >
    > Mean of the data is (showing first 5 values): 0.482
    >
    > Mean of the data is (showing first 5 values): 0.4756
    >
    > Mean of the data is (showing first 5 values): 0.4932
    >
    > Mean of the data is (showing first 5 values): 0.4654
    >
    > Standard deviation of the data is (showing first 5 values): 0.2606
    >
    > Standard deviation of the data is (showing first 5 values): 0.2762
    >
    > Standard deviation of the data is (showing first 5 values): 0.2918
    >
    > Standard deviation of the data is (showing first 5 values): 0.2965
    >
    > Standard deviation of the data is (showing first 5 values): 0.2833

### MATLAB benchmarks

1.  `benchmark_read_tabulated.m`

    > Calling benchmark_read_tabulated
    >
    > Time taken: read CSV DK40_33794_70: 1.2101
    >
    > Time taken: read parquet DK40_33794_70: 0.073162
    >
    > Time taken: read CSV GP_32945_335: 5.4379
    >
    > Time taken: read parquet GP_32945_335: 0.24545

2.  `benchmark_read_NIfTI.m`

    > Calling benchmark_read_NIfTI
    >
    > Time taken: read NIfTI: 5.2153
    >
    > Time taken: read compressed HDF5 (load): 1.5521
    >
    > Time taken: read uncompressed HDF5 (load): 0.34318
    >
    > Time taken: read compressed HDF5 (h5): 1.5624
    >
    > Time taken: read uncompressed HDF5 (h5): 0.35013

3.  `benchmark_matMultiplication.m`

    > Calling benchmark_matMultiplication
    >
    > Time taken: slow multiplication: 4.4736
    >
    > Time taken: fast multiplication: 0.011341

4.  `benchmark_linearRegression.m`

    > Time taken: fitlm (loop): 226.0817
    >
    > Time taken: backslash operator: 2.188
    >
    > Time taken: linsolve: 2.2205
    >
    > Time taken: normal equation with pinv: 0.084184
    >
    > Time taken: normal equation avoiding pinv: 0.081155

5.  `demo_lazyEval_meanStd.m`

    > Calling demo_lazyEval_meanStd
    >
    > Evaluating tall expression using the Local MATLAB Session:
    >
    > \- Pass 1 of 1: 0% complete
    >
    > \- Pass 1 of 1: 100% complete
    >
    > \- Pass 1 of 1: Completed in 3.4 sec
    >
    > Evaluation completed in 4.7 sec
    >
    > Mean of the data is (showing first 5 values): 0.52413 0.48196 0.47562 0.49319 0.46542
    >
    > Standard deviation of the data is (showing first 5 values): 0.26059 0.27621 0.29182 0.29652 0.28331
