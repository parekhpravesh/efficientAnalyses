%% Use datastore and tall arrays to calculate mean and standard deviation
% Loading prespecified field named data
workDir = fileparts(mfilename('fullpath'));
inDir   = fullfile(workDir, 'samples', 'NIfTI');
toWork  = fullfile(inDir, 'concatedData_73_uncompressed.mat');
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