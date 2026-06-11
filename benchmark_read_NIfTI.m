function benchmark_read_NIfTI(inDir, resultsDir)
%% Code to benchmark reading NIfTI files and concatenated data
% Set paths, relative to this script
if ~exist('resultsDir', 'var') || isempty(resultsDir)
    workDir     = fileparts(mfilename('fullpath'));
    resultsDir  = fullfile(workDir, 'results');
end

if ~exist('inDir', 'var') || isempty(inDir)
    workDir = fileparts(mfilename('fullpath'));
    inDir   = fullfile(workDir, 'samples', 'NIfTI');
end

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

% Define functions
fUncompressed   = @() load(fullfile(inDir, 'concatedData_73_uncompressed.mat'), 'data', 'vec_mask');
fCompressed     = @() load(fullfile(inDir, 'concatedData_73_compressed.mat'), 'data', 'vec_mask');
fUncompressedH5 = @() h5read_mat(fullfile(inDir, 'concatedData_73_uncompressed.mat'));
fCompressedH5   = @() h5read_mat(fullfile(inDir, 'concatedData_73_compressed.mat'));
fNIfTI          = @() read_NIfTI(inDir);

% Get robust timing using timeit
tRead_uncompressed   = timeit(fUncompressed);
tRead_compressed     = timeit(fCompressed);
tRead_uncompressedH5 = timeit(fUncompressedH5);
tRead_compressedH5   = timeit(fCompressedH5);
tRead_NIfTI          = timeit(fNIfTI);

% Show results
disp(['Time taken: read NIfTI: ',                    num2str(tRead_NIfTI)]);
disp(['Time taken: read compressed HDF5 (load): ',   num2str(tRead_compressed)]);
disp(['Time taken: read uncompressed HDF5 (load): ', num2str(tRead_uncompressed)]);
disp(['Time taken: read compressed HDF5 (h5): ',     num2str(tRead_compressedH5)]);
disp(['Time taken: read uncompressed HDF5 (h5): ',   num2str(tRead_uncompressedH5)]);

% Save results
clear f*
save(fullfile(resultsDir, 'benchmarks_readNIfTI.mat'));
end

function read_NIfTI(inDir)
listFiles = dir(fullfile(inDir, '*.nii.gz'));

% Get dimensions
info = niftiinfo(fullfile(listFiles(1).folder, listFiles(1).name));

% Initialize
data = zeros([info.ImageSize, length(listFiles)], 'single');

% Loop over every subject and concat
for subjs = 1:length(listFiles)
    data(:, :, :, subjs) = niftiread(fullfile(listFiles(subjs).folder, listFiles(subjs).name));
end
end

function res = h5read_mat(inFile)
% See also, https://www.mathworks.com/matlabcentral/answers/329759
info = h5info(inFile);
toLoad = strcat({'/'}, {info.Datasets(:).Name});

% Initialize
res = cell(length(toLoad),1);

% Keep dataset open
fid = H5F.open(inFile);

for ii = 1:length(toLoad)
    try
        did = H5D.open(fid, toLoad{ii});
        res{ii} = H5D.read(did);
        H5D.close(did);
    catch
        H5F.close(fid);
    end
end
H5F.close(fid);
end