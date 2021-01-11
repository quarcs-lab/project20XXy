function h=h1_os(x) 

% h1_os     Terrell's OverSmoothed estimate of smoothing parameter h for univariate data.
%           NB: Assumes the kernel is standard Gaussian
%
% USAGE:
%   h=hos(x)
% 
% INPUTS:
%   x           :   n-by-1 vector with the data
%
% OUTPUT:
%   hos        :   oversmoothed bandwidth based on standard deviation
%
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (23/08/2006)


n = length(x);
stdev = std(x);

h = n^(-1/5) * stdev * ((3*35^(-1/5)) * (1/(2*sqrt(pi)))^(1/5));