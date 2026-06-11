%% Demo: Linear regression
rng(20260529, 'twister');

% Set paths, relative to this script
workDir     = fileparts(mfilename('fullpath'));
resultsDir  = fullfile(workDir, 'results');
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

%% Settings
n = 30000;
p = 50;
v = 1000;

%% Simulate X and y
% Same noise level across voxels to keep RAM load low
% Adding an intercept as the first X variable
X        = [ones(n, 1), rand(n, p-1)];
betaTrue = rand(p, v);
noise    = rand(n, 1);
y        = X * betaTrue + noise;

%% Define functions for timeit
f_solve_fitlm                = @() solve_fitlm(X, y);
f_solve_mldivide             = @() solve_mldivide(X, y);
f_solve_linsolve             = @() solve_linsolve(X, y);
f_solve_normalEqn            = @() solve_normalEqn(X, y);
f_solve_normalEqn_withoutInv = @() solve_normalEqn_withoutInv(X, y);

%% Get robust timing using timeit
tSolve_fitlm                = timeit(f_solve_fitlm);
tSolve_mldivide             = timeit(f_solve_mldivide);
tSolve_linsolve             = timeit(f_solve_linsolve);
tSolve_normalEqn            = timeit(f_solve_normalEqn);
tSolve_normalEqn_withoutInv = timeit(f_solve_normalEqn_withoutInv);

% Show results
disp(['Time taken: fitlm (loop): ',                  num2str(tSolve_fitlm)]);
disp(['Time taken: backslash operator: ',            num2str(tSolve_mldivide)]);
disp(['Time taken: linsolve: ',                      num2str(tSolve_linsolve)]);
disp(['Time taken: normal equation with pinv: ',     num2str(tSolve_normalEqn)]);
disp(['Time taken: normal equation avoiding pinv: ', num2str(tSolve_normalEqn_withoutInv)]);

% %% Make sure betas are equivalent
% beta_fitlm     = solve_fitlm(X, y);
% beta_mldivide  = solve_mldivide(X, y);
% beta_linsolve  = solve_linsolve(X, y);
% beta_normalEqn = solve_normalEqn(X, y);
% beta_normalEqn_withoutInv = solve_normalEqn_withoutInv(X, y);

clear X y f*

%% Save results
save(fullfile(resultsDir, 'benchmarks_linearRegression.mat'));

function beta = solve_fitlm(X, y)
% Initialize
numVox = size(y,2);
beta   = zeros(size(X,2), size(y,2));

for v = 1:numVox
    mdl  = fitlm(X, y(:, v), 'Intercept', false);
    beta(:,v) = mdl.Coefficients.Estimate;
end
end

function beta = solve_mldivide(X, y)
beta = X \ y;
end

function beta = solve_linsolve(X, y)
beta = linsolve(X, y);
end

function beta = solve_normalEqn(X, y)
beta = pinv(X' * X) * (X' * y);
end

function beta = solve_normalEqn_withoutInv(X, y)
XtX  = X' * X;
iXtX = XtX \ eye(size(XtX));
beta = iXtX * (X' * y);
end