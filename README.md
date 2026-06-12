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
    Time taken: load (nibabel):     3.7589
    Time taken: h5py compressed:    1.5186
    Time taken: h5py uncompressed:  0.2905
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

4.  The following code can be run (these are full commands which can be copy-pasted in the terminal to run):

    - Benchmark different ways of performing linear regression: `./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark regression /data/teaching/parekhpravesh/efficientAnalyses/results`

    - Benchmark different ways of performing matrix multiplication: `./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark multiplication /data/teaching/parekhpravesh/efficientAnalyses/results`

    - Benchmark reading NIfTI files and HDF5 concatenated data format: `./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark nifti /data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI /data/teaching/parekhpravesh/efficientAnalyses/results`

    - Benchmark different ways of reading csv and parquet files: `./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b benchmark tabulated /data/teaching/parekhpravesh/efficientAnalyses/samples /data/teaching/parekhpravesh/efficientAnalyses/results`

    - Show an example of lazy loading of concatenated data to estimate mean and standard deviation for every voxel/vertex/connection: `./efficientShowcase_App_glnx64/run_efficientShowcase.sh /opt/matlabruntime/R2024b demo lazy /data/teaching/parekhpravesh/efficientAnalyses/samples/NIfTI /data/teaching/parekhpravesh/efficientAnalyses/results`

5.  To quit the apptainer shell, press `Ctrl + D`
