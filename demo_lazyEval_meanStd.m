function demo_lazyEval_meanStd(inDir)
%% Use datastore and tall arrays to calculate mean and standard deviation
if ~exist('inDir', 'var') || isempty(inDir)
    workDir = fileparts(mfilename('fullpath'));
    inDir   = fullfile(workDir, 'samples', 'NIfTI');
end

% Loading prespecified field named data
toWork  = fullfile(inDir, 'concatedData_uncompressed.mat');
fds     = fileDatastore(toWork, 'ReadFcn', @(x) getfield(load(x, 'data'), 'data'), 'UniformRead', true);

% Disable creation of parallel pool
mapreducer(0);

% Create a tall array of data
data = tall(fds);

% Let's compute the mean of the NIfTI images
mean_data = mean(data);

% Let's compute the standard deviation as another operation
std_data = std(data);

% Bring the results into memory - do these at the same time to reduce
% multiple evaluations
[mean_data, std_data] = gather(mean_data, std_data);

% Show results
disp(['Mean of the data is (showing first 5 values): ', num2str(mean_data(1:5))]);
disp(['Standard deviation of the data is (showing first 5 values): ', num2str(std_data(1:5))]);