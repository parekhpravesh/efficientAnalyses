%% Generate some synthetic data: ABCD size
function create_ABCDlike_tabulated(numSamples, numColumns, outDir, outSuffix, seed)
if ~exist('outSuffix', 'var') || isempty(outSuffix)
    outSuffix = '';
end

if ~exist('seed', 'var') || isempty(seed)
    rng(20260527, 'twister');
else
    rng(seed, 'twister');
end

% Some settings
maxNumInFamily = 5;
numVisits      = 4;

% Generate IDs
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

% Generate data
varNames            = strcat({'y_'}, num2str((1:numColumns)', '%03d'));
data                = array2table(rand(numSamples, numColumns), 'VariableNames', varNames);
data.participant_id = iid;
data.family_id      = fid;
data.session_id     = eid;
data                = movevars(data, {'participant_id', 'family_id', 'session_id'}, 'Before', 'y_001');

% Save in different formats
writetable(data, fullfile(outDir, ['ABCDlike_tabulated', outSuffix, '.csv']));
parquetwrite(fullfile(outDir, ['ABCDlike_tabulated', outSuffix, '.parquet']), data);