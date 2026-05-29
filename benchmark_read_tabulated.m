%% Benchmark reading ABCDlike tabulated data
%% Settings
workDir = '/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples';
fname1  = 'ABCDlike_tabulated_DK40_33794_70';
fname2  = 'ABCDlike_tabulated_GP_32945_335';

%% First benchmark - ABCDlike_tabulated_DK40_33794_70
fcsv     = @() readtable(fullfile(workDir,   [fname1, '.csv']));
fParquet = @() parquetread(fullfile(workDir, [fname1, '.parquet']));

% Get robust timing using timeit
tReadCSV_DK40_33794_70     = timeit(fcsv);
tReadParquet_DK40_33794_70 = timeit(fParquet);

%% Second benchmark - ABCDlike_tabulated_GP_32945_335
fcsv     = @() readtable(fullfile(workDir,   [fname2, '.csv']));
fParquet = @() parquetread(fullfile(workDir, [fname2, '.parquet']));

% Get robust timing using timeit
tReadCSV_GP_32945_335     = timeit(fcsv);
tReadParquet_GP_32945_335 = timeit(fParquet);

save('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readTabulated_MATLAB.mat');

% %% Read csv format
% tInit    = tic;
% data1    = readtable(fullfile(workDir, 'ABCDlike_tabulated.csv'));
% tReadCSV = toc(tInit);
% 
% %% Read parquet format
% tInit        = tic;
% data2        = parquetread(fullfile(workDir, 'ABCDlike_tabulated.parquet'));
% tReadParquet = toc(tInit);