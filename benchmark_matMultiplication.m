function benchmark_matMultiplication(resultsDir)
%% Demo: (AB)C vs. A(BC)
rng(20260529, 'twister');

% Set paths, relative to this script
if ~exist('resultsDir', 'var') || isempty(resultsDir)
    workDir     = fileparts(mfilename('fullpath'));
    resultsDir  = fullfile(workDir, 'results');
end

if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

% Prepare variables
n = 5000;
A = rand(n, n);
B = rand(n, n);
C = rand(n, 1);

% Define functions for timeit
f_solve1 = @() doSolve_slow(A, B, C);
f_solve2 = @() doSolve_fast(A, B, C);

% Get robust timing using timeit
tMultiply_slow = timeit(f_solve1);
tMultiply_fast = timeit(f_solve2);

% Show results
disp(['Time taken: slow multiplication: ', num2str(tMultiply_slow)]);
disp(['Time taken: fast multiplication: ', num2str(tMultiply_fast)]);

clear A B C f*

% Save results
save(fullfile(resultsDir, 'benchmarks_matMultiply.mat'));
end

function result = doSolve_slow(A, B, C)
result = (A * B) * C;
end

function result = doSolve_fast(A, B, C)
result = A * (B * C);
end