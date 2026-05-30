%% Demo: (AB)C vs. A(BC)
n = 5000;

rng(20260529, 'twister');

% Prepare X variable and true beta coefficients
A = rand(n, n);
B = rand(n, n);
C = rand(n, 1);

% Define functions for timeit
f_solve1 = @() doSolve_slow(A, B, C);
f_solve2 = @() doSolve_fast(A, B, C);

% Get robust timing using timeit
tMultiply_slow = timeit(f_solve1);
tMultiply_fast = timeit(f_solve2);

clear A B C f*

% Save results
save('/Users/praveshp/github/efficientAnalyses/efficientAnalyses/results/benchmarks_matMultiply.mat');