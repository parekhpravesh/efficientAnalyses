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
                p                 = inputParser;
                p.KeepUnmatched   = true;
                validationFcn_str = @(s) isstring(s) | ischar(s);
                validationFcn_num = @(s) isnumeric(s);

                switch lower(command)
                    case 'generate'
                        switch moduleName
                            case 'tabulated'
                                showHelp('genTabulated');
                                % Add positional and optional required arguments
                                addRequired(p, 'numSamples', validationFcn_num);
                                addRequired(p, 'numColumns', validationFcn_num);
                                addOptional(p, 'outDir',     '', validationFcn_str);
                                addOptional(p, 'outSuffix',  '', validationFcn_str);
                                addOptional(p, 'seed',       20260527, validationFcn_num);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call create_synthetic_tabulated
                                disp('Calling create_synthetic_tabulated');
                                create_synthetic_tabulated(p.Results.numSamples, ...
                                                           p.Results.numColumns, ...
                                                           p.Results.outDir,     ...
                                                           p.Results.outSuffix,  ...
                                                           p.Results.seed);
                                disp('Completed');

                            case 'nifti'
                                showHelp('genNIfTI');
                                % Add positional and optional required arguments
                                addRequired(p, 'numSubjects', validationFcn_num);
                                addRequired(p, 'spmDir',      validationFcn_str);
                                addOptional(p, 'outDir',      '', validationFcn_str);
                                addOptional(p, 'seed',        20260528, validationFcn_num);

                                % Parse inputs
                                parse(p, varargin{:});

                                % Call create_synthetic_NIfTI
                                disp('Calling create_synthetic_NIfTI');
                                create_synthetic_NIfTI(p.Results.numSubjects, ...
                                                       p.Results.spmDir,      ...
                                                       p.Results.outDir,      ...
                                                       p.Results.seed);
                                disp('Completed');
                        end

                    case 'benchmark'
                        % No inputs to be parsed
                        switch moduleName
                            case 'tabulated'
                                showHelp('benchTabulated');
                                disp('Calling benchmark_read_tabulated');
                                benchmark_read_tabulated;
                                disp('Completed');

                            case 'nifti'
                                showHelp('benchNIfTI');
                                disp('Calling benchmark_read_NIfTI');
                                benchmark_read_NIfTI;
                                disp('Completed');

                            case 'multiplication'
                                showHelp('benchMultiplication');
                                disp('Calling benchmark_matMultiplication');
                                benchmark_matMultiplication;
                                disp('Completed');

                            case 'regression'
                                showHelp('benchRegression');
                                disp('Calling benchmark_linearRegression');
                                benchmark_linearRegression;
                                disp('Completed');
                        end

                    case 'demo'
                        % No inputs to be parsed
                        switch moduleName
                            case 'lazy'
                                showHelp('lazy');
                                disp('Calling demo_lazyEval_meanStd');
                                demo_lazyEval_meanStd;
                                disp('Completed');
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
        disp('Syntax: efficientShowcase benchmark tabulated');

    case 'benchNIfTI'
        disp('Syntax: efficientShowcase benchmark nifti');

    case 'benchMultiplication'
        disp('Syntax: efficientShowcase benchmark multiplication');

    case 'benchRegression'
        disp('Syntax: efficientShowcase benchmark regression');

    case 'lazy'
        disp('Syntax: efficientShowcase demo lazy');
end
end