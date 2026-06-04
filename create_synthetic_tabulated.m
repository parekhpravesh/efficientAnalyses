function create_synthetic_tabulated(numSamples, numColumns, outDir, outSuffix, seed)
% Function to generate synthetic tabulated data
%% Inputs:
% numSamples:   number of samples to be simulated
% numColumns:   number of columns to be simulated
% outDir:       full path to where the tables should be written
% outSuffix:    (optional) suffix to be added to the output file name
% seed:         (optional) random number seed
%
%% Outputs:
% A tabulated data with the specified number of samples and number of
% columns is generated; the first three columns are the participant ID, the
% family ID, and the event ID, followed by actual data
% 
% The tabulated data is saved as a csv and as a parquet file

%% Check inputs
if ~exist('outSuffix', 'var') || isempty(outSuffix)
    outSuffix = '';
end

if ~exist('seed', 'var') || isempty(seed)
    rng(20260527, 'twister');
else
    rng(seed, 'twister');
end

%% Some settings
maxNumInFamily = 5;
numVisits      = 4;

%% Generate IDs
iid_int = sort(repmat(1:numSamples, 1, numVisits));
fid_int = ceil(iid_int / maxNumInFamily);

iid = cellstr([repmat('I', length(iid_int),1), dec2base(iid_int,10)]);
fid = cellstr([repmat('F', length(fid_int),1), dec2base(fid_int,10)]);

clear('iid_int', 'fid_int'); 

% Generate event IDs
allEvents = categorical((1:numVisits)');
eid       = repmat(allEvents, numSamples, 1);

% Now, annihilate visits
toKeep        = randperm(length(iid), numSamples);
toDelete      = setdiff(1:length(iid), toKeep);
eid(toDelete) = [];
iid(toDelete) = [];
fid(toDelete) = [];

%% Generate data
varNames            = strcat({'y_'}, num2str((1:numColumns)', '%03d'));
data                = array2table(rand(numSamples, numColumns), 'VariableNames', varNames);
data.participant_id = iid;
data.family_id      = fid;
data.session_id     = eid;
data                = movevars(data, {'participant_id', 'family_id', 'session_id'}, 'Before', 'y_001');

%% Save in different formats
writetable(data, fullfile(outDir, ['ABCDlike_tabulated', outSuffix, '.csv']));
parquetwrite(fullfile(outDir,     ['ABCDlike_tabulated', outSuffix, '.parquet']), data);