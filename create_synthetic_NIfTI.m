%% Create synthetic NIfTI images
function create_synthetic_NIfTI(numSubjects, spmDir, outDir, seed)

if ~exist('seed', 'var') || isempty(seed)
    rng(20260528, 'twister');
else
    rng(seed, 'twister');
end

maskFile = fullfile(spmDir, 'tpm', 'mask_ICV.nii');
if ~exist(maskFile, 'file')
    error(['Unable to find: ', maskFile]);
end

% Make output directory
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

% Get 1.5 mm  isotropic mask information from SPM - make it a logical
mask = logical(niftiread(maskFile));

% NIfTI dimensions
niftidims = size(mask);

% Loop over subjects and make synthetic NIfTI files
for subjs = 1:numSubjects
    niftiwrite(single(rand(niftidims) .* mask), ...
               fullfile(outDir, ['Subj', num2str(subjs, '%03d'), '.nii.gz']), ...
               'Compressed', true);
end

%% Now read these created images and make a concatenated file out of it
listFiles = dir(fullfile(outDir, '*.nii.gz'));

% Get dimensions
info = niftiinfo(fullfile(listFiles(1).folder, listFiles(1).name));

% Initialize
data = zeros([length(listFiles), prod(info.ImageSize)], 'single');

% Loop over every subject, flatten, and concat
for subjs = 1:length(listFiles)
    tempData = niftiread(fullfile(listFiles(subjs).folder, listFiles(subjs).name));
    data(subjs, :) = tempData(:);
end

% Make a mask
vec_mask = logical(sum(data == 0, 1)) | logical(sum(isnan(data), 1));

% Flatten data and subset to mask only
data = data(:, ~vec_mask);

% Save as HDF5 file
save(fullfile(outDir, 'concatedData_73_compressed.mat'),   'data', 'vec_mask', '-v7.3');
save(fullfile(outDir, 'concatedData_73_uncompressed.mat'), 'data', 'vec_mask', '-v7.3', '-nocompression');