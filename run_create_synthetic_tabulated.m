% Set paths, relative to this script
workDir = fileparts(mfilename('fullpath'));
outDir  = fullfile(workDir, 'samples');

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

% Now call efficientShowcase for the first test case
efficientShowcase('generate', 'tabulated', 33794, 70, outDir, '_DK40_33794_70');

% Now call efficientShowcase for the second test case
efficientShowcase('generate', 'tabulated', 32945, 335, outDir, '_GP_32945_335');

% Change directory again, if required
if ~isempty(tmpDir)
    cd(tmpDir);
end