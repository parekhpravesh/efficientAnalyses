function efficientShowcase(command, moduleName, varargin)
% Caller function for generating samples using compiled version of MATLAB
%% Inputs:
% --------
% command:          should be one of the following (case in-sensitive):
%                       * help
%                       * generate
%                       * benchmark
%                       * demo
% 
% moduleName:       should be one of the following (case in-sensitive):
%                       * if command is `generate`:
%                           * tabulated
%                           * nifti
%                       * if command is `benchmark`:
%                           * tabulated
%                           * nifti
%                           * multiplication
%                           * regression
%                       * if command is `demo`
%                           * lazy

%% Validate command
if ~exist('command', 'var') || isempty(command)
    showHelp('generic');
    disp('No command specified; exiting now');
else
    command = lower(command);
    validCommands = {'help', 'h', 'generate', 'benchmark', 'demo'};
    if ~ismember(command, validCommands)
        disp(['Unknown command specified: ', command, '; see help below']);
        showHelp('generic');
    else
        % Validate moduleName
        if ~exist('moduleName', 'var') || isempty(moduleName)
            disp('No module name specified; see help below:');
            showHelp('generic');
        else
            validModules = {'tabulated', 'nifti', 'multiplication', 'regression', 'lazy'};
            moduleName   = lower(moduleName);
            if ~ismember(moduleName, validModules)
                disp(['Unknown module specified: ', moduleName, '; see help below:']);
                showHelp('generic');
            else
                p               = inputParser;
                p.KeepUnmatched = true;
                validationFcn   = @(s) isstring(s) || ischar(s) || isnumeric(s);

                switch lower(command)
                    case 'generate'
                        switch moduleName
                            case 'tabulated'
                                showHelp('genTabulated');
                                % Add positional and optional required arguments
                                addRequired(p, 'numSamples', validationFcn);
                                addRequired(p, 'numColumns', validationFcn);
                                addOptional(p, 'outDir',     '', validationFcn);
                                addOptional(p, 'outSuffix',  '', validationFcn);
                                addOptional(p, 'seed',       20260527, validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Assign outputs
                                numSamples = p.Results.numSamples;
                                numColumns = p.Results.numColumns;
                                outDir     = p.Results.outDir;
                                outSuffix  = p.Results.outSuffix;
                                seed       = p.Results.seed;

                                % Convert to numeric, if required
                                if isdeployed
                                    if ~isnumeric(numSamples)
                                        numSamples = str2double(numSamples);
                                    end
                                    if ~isnumeric(numColumns)
                                        numColumns = str2double(numColumns);
                                    end
                                    if ~isnumeric(seed)
                                    seed = str2double(seed);
                                    end
                                end

                                % Call create_synthetic_tabulated
                                disp('Calling create_synthetic_tabulated');
                                create_synthetic_tabulated(numSamples, numColumns, ...
                                                           outDir,     outSuffix,  ...
                                                           seed);
                                disp('Completed');

                            case 'nifti'
                                showHelp('genNIfTI');
                                % Add positional and optional required arguments
                                addRequired(p, 'numSubjects', validationFcn);
                                addRequired(p, 'spmDir',      validationFcn);
                                addOptional(p, 'outDir',      '', validationFcn);
                                addOptional(p, 'seed',        20260528, validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Assign outputs
                                numSubjects = p.Results.numSubjects;
                                spmDir      = p.Results.spmDir;
                                outDir      = p.Results.outDir;
                                seed        = p.Results.seed;

                                % Convert to numeric, if required
                                if isdeployed
                                    if ~isnumeric(numSubjects)
                                        numSubjects = str2double(numSubjects);
                                    end
                                    if ~isnumeric(seed)
                                        seed = str2double(seed);
                                    end
                                end

                                % Call create_synthetic_NIfTI
                                disp('Calling create_synthetic_NIfTI');
                                create_synthetic_NIfTI(numSubjects, spmDir, ...
                                                       outDir, seed);
                                disp('Completed');

                            otherwise
                                disp('Incorrect command and module name combination; see help below:');
                                showHelp('generic');
                        end

                    case 'benchmark'
                        switch moduleName
                            case 'tabulated'
                                showHelp('benchTabulated');
                                % Add optional arguments
                                addOptional(p, 'inDir',      '', validationFcn);
                                addOptional(p, 'resultsDir', '', validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call benchmark_read_tabulated
                                disp('Calling benchmark_read_tabulated');
                                benchmark_read_tabulated(p.Results.inDir, p.Results.resultsDir);
                                disp('Completed');

                            case 'nifti'
                                showHelp('benchNIfTI');
                                % Add optional arguments
                                addOptional(p, 'inDir',      '', validationFcn);
                                addOptional(p, 'resultsDir', '', validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call benchmark_read_NIfTI
                                disp('Calling benchmark_read_NIfTI');
                                benchmark_read_NIfTI(p.Results.inDir, p.Results.resultsDir);
                                disp('Completed');

                            case 'multiplication'
                                showHelp('benchMultiplication');
                                % Add optional arguments
                                addOptional(p, 'resultsDir', '', validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call benchmark_matMultiplication
                                disp('Calling benchmark_matMultiplication');
                                benchmark_matMultiplication(p.Results.resultsDir);
                                disp('Completed');

                            case 'regression'
                                showHelp('benchRegression');
                                % Add optional arguments
                                addOptional(p, 'resultsDir', '', validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call benchmark_linearRegression
                                disp('Calling benchmark_linearRegression');
                                benchmark_linearRegression(p.Results.resultsDir);
                                disp('Completed');

                            otherwise
                                disp('Incorrect command and module name combination; see help below:');
                                showHelp('generic');

                        end

                    case 'demo'
                        switch moduleName
                            case 'lazy'
                                showHelp('lazy');
                                % Add optional arguments
                                addOptional(p, 'inDir', '', validationFcn);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call demo_lazyEval_meanStd
                                disp('Calling demo_lazyEval_meanStd');
                                demo_lazyEval_meanStd(p.Results.inDir);
                                disp('Completed');

                            otherwise
                                disp('Incorrect command and module name combination; see help below:');
                                showHelp('generic');

                        end
                end
            end
        end
    end
end
end

function showHelp(helpType)
if ~exist('helpType', 'var') || isempty(helpType)
    helpType = 'generic';
end

switch helpType
    case 'generic'
        disp('Welcome to efficient showcase!')
        disp('The following are valid ways of calling efficientShowcase:')
        disp(' ');
        disp('Create tabulated data:            efficientShowcase generate tabulated');
        disp('Create NIfTI data:                efficientShowcase generate nifti');
        disp('Benchmark reading tabulated:      efficientShowcase benchmark tabulated');
        disp('Benchmark reading NIfTI:          efficientShowcase benchmark nifti');
        disp('Benchmark matrix multiplication:  efficientShowcase benchmark multiplication');
        disp('Benchmark linear regression:      efficientShowcase benchmark regression');
        disp('Demo for lazy evaulation:         efficientShowcase demo lazy');
        disp(' ');
        disp('Parekh, Pravesh');
        disp('J. Craig Venter Institute, La Jolla, California, USA');
        disp('Contact: pparekh@jcvi.org or on GitHub: @parekhpravesh');
        disp('Code: https://github.com/parekhpravesh/efficientAnalyses');

    case 'genTabulated'
        disp(['Syntax: efficientShowcase generate tabulated ', ...
              '<numSamples> <numColumns> <outDir> <outSuffix> <seed>']);
        disp('Parameters are position specific');
        disp('<outDir>, <outSuffix>, and <seed> are optional');

    case 'genNIfTI'
        disp(['Syntax: efficientShowcase generate nifti ', ...
            '<numSubjects> <spmDir> <outDir> <seed>']);
        disp('Parameters are position specific');
        disp('<seed> is optional');

    case 'benchTabulated'
        disp('Syntax: efficientShowcase benchmark tabulated inputDir outputDir');
        disp('Parameters are position specific');
        disp('<inputDir> and <outputDir> are optional');

    case 'benchNIfTI'
        disp('Syntax: efficientShowcase benchmark nifti inputDir outputDir');
        disp('Parameters are position specific');
        disp('<inputDir> and <outputDir> are optional');

    case 'benchMultiplication'
        disp('Syntax: efficientShowcase benchmark multiplication outputDir');
        disp('Parameters are position specific');
        disp('<outputDir> is optional');

    case 'benchRegression'
        disp('Syntax: efficientShowcase benchmark regression outputDir');
        disp('Parameters are position specific');
        disp('<outputDir> is optional');

    case 'lazy'
        disp('Syntax: efficientShowcase demo lazy inputDir');
        disp('Parameters are position specific');
        disp('<inputDir> is optional');
end
end