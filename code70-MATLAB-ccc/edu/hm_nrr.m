function h=hm_nrr(A,k)

% hm_nrr    Normal Reference Rule estimate of smoothing parameters h for multivariate data. 
%
%
% USAGE:
%   h=hmnrr(A,'gauss')
%
% INPUTS:
%   A           :   n-by-d matrix with the data (d is the n. of dimensions)
%   k           :   string argument specifying the type of kernel to be used.
%                   Supported kernels are:
%                    'epan' - Epanechnikov kernel
%                    'gauss' - Gaussian kernel
%
% OUTPUT:
%   h           :   1-by-d vector 0f bandwidths
%
% COMMENTS:
%   See Silverman (1986), Scott (1992) or Wand and Jones (1995) for
%   details.
%
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (22/06/2007)


[n d]=size(A);

if  strcmp(k,'epan')==1
    a=(8*(d+4)*(2*sqrt(pi))^d/vsph(d))^(1/(4+d));       % Epanechikov kernel function
elseif strcmp(k,'gauss')==1
    a=(4/(d+2))^(1/(d+4));                              % Gaussian kernel function
else   error('unknown kernel')
end

%covA = cov(A);
%h=a*sqrtm(covA)*n^(-1/(d+4));

stds = sqrt(diag(cov(A)));
h = ones(d,1);
for i=1:d
    h(i) = a * stds(i) * n^(-1/(d+4));
end
h = h';