inDir = '/Users/praveshp/github/efficientAnalyses/efficientAnalyses/samples/NIfTI';

% Define functions
fUncompressed   = @() load(fullfile(inDir, 'concatedData_73_uncompressed.mat'));
fCompressed     = @() load(fullfile(inDir, 'concatedData_73_compressed.mat'));
fUncompressedH5 = @() h5read_mat(fullfile(inDir, 'concatedData_73_uncompressed.mat'));
fCompressedH5   = @() h5read_mat(fullfile(inDir, 'concatedData_73_compressed.mat'));
fNIfTI          = @() read_NIfTI(inDir);

% Get robust timing using timeit
tRead_uncompressed   = timeit(fUncompressed);
tRead_compressed     = timeit(fCompressed);
tRead_uncompressedH5 = timeit(fUncompressedH5);
tRead_compressedH5   = timeit(fCompressedH5);
tRead_NIfTI          = timeit(fNIfTI);

% Save results
save('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_readNIfTI.mat');

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
    did = H5D.open(fid, toLoad{ii});
    res{ii} = H5D.read(did);
    H5D.close(did);
end
H5F.close(fid);
end