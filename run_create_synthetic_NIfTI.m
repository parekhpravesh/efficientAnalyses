% Set paths, relative to this script
workDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(workDir, 'samples', 'NIfTI');

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

% Change path, if needed
if ~exist('generateSamples.m', 'file')
    tmpDir = pwd;
    cd(workDir);
else
    tmpDir = '';
end

% Now call efficientShowcase
spmDir = '/Applications/Toolboxes/spm12';
efficientShowcase('generate', 'nifti', 100, spmDir, outDir);

% Change directory again, if required
if ~isempty(tmpDir)
    cd(tmpDir);
end