% Set paths, relative to this script
workDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(workDir, 'samples', 'NIfTI');

if ~exist(outDir, 'dir')
    mkdir(outDir);
end

% Change path, if needed
if ~exist('efficientShowcase.m', 'file')
    tmpDir = pwd;
    cd(workDir);
else
    tmpDir = '';
end

% Now call efficientShowcase
% spmDir = '/Applications/Toolboxes/spm12';
spmDir = 'This needs to be replaced with SPM12/SPM25 folder';
if ~exist(spmDir, 'dir')
    error('Unable to find SPM12/SPM25 directory; spmDir needs to be set in the script');
end
efficientShowcase('generate', 'nifti', 100, spmDir, outDir);

% Change directory again, if required
if ~isempty(tmpDir)
    cd(tmpDir);
end