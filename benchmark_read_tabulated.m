%% Code to benchmark reading tabulated data
%% Settings
% Set paths, relative to this script
workDir     = fileparts(mfilename('fullpath'));
inDir       = fullfile(workDir, 'samples');
resultsDir  = fullfile(workDir, 'results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

fname1  = 'ABCDlike_tabulated_DK40_33794_70';
fname2  = 'ABCDlike_tabulated_GP_32945_335';

%% First benchmark - ABCDlike_tabulated_DK40_33794_70
fcsv     = @() readtable(fullfile(inDir,   [fname1, '.csv']));
fParquet = @() parquetread(fullfile(inDir, [fname1, '.parquet']));

% Get robust timing using timeit
tReadCSV_DK40_33794_70     = timeit(fcsv);
tReadParquet_DK40_33794_70 = timeit(fParquet);

%% Second benchmark - ABCDlike_tabulated_GP_32945_335
fcsv     = @() readtable(fullfile(inDir,   [fname2, '.csv']));
fParquet = @() parquetread(fullfile(inDir, [fname2, '.parquet']));

% Get robust timing using timeit
tReadCSV_GP_32945_335     = timeit(fcsv);
tReadParquet_GP_32945_335 = timeit(fParquet);

%% Make a results table
results      = cell(2, 4);

% File names
results{1,1} = fname1;
results{2,1} = fname2;

% Performance of readtable
results{1,2} = tReadCSV_DK40_33794_70;
results{2,2} = tReadCSV_GP_32945_335;

% Performance of parquetread
results{1,3} = tReadParquet_DK40_33794_70;
results{2,3} = tReadParquet_GP_32945_335;

% Speed-up factor
results{1,4} = tReadCSV_DK40_33794_70 ./ tReadParquet_DK40_33794_70;
results{2,4} = tReadCSV_GP_32945_335  ./ tReadParquet_GP_32945_335;

% Show results
disp(['Time taken: read CSV DK40_33794_70: ',     num2str(tReadCSV_DK40_33794_70)]);
disp(['Time taken: read parquet DK40_33794_70: ', num2str(tReadParquet_DK40_33794_70)]);

disp(['Time taken: read CSV GP_32945_335: ',     num2str(tReadCSV_GP_32945_335)]);
disp(['Time taken: read parquet GP_32945_335: ', num2str(tReadParquet_GP_32945_335)]);

% Make a table
results = cell2table(results, 'VariableNames', {'FileName', 'tReadCSV', 'tReadParquet', 'Parquet_SpeedUp'});

%% Save results
clear f*
save(fullfile(resultsDir, 'benchmarks_readTabulated_MATLAB.mat'));