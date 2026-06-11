% Set paths, relative to this script
workDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(workDir, 'samples');

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

% Now call generateSamples for the first test case
generateSamples('tabulated', 33794, 70, outDir, '_DK40_33794_70');

% Now call generateSamples for the second test case
generateSamples('tabulated', 32945, 335, outDir, '_GP_32945_335');

% Change directory again, if required
if ~isempty(tmpDir)
    cd(tmpDir);
end