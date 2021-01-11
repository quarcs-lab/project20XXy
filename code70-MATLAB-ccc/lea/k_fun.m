function k=k_fun(kernel,u1,u2)

% k_fun     Uni- or Bi-variate kernel functions
%
% USAGE:
%   k=k_fun(kernel,u1,u2)
%
% INPUTS:
%   kernel      :   string argument specifying the type of kernel to be used.
%                   Supported kernels are:
%                    'epan' - Epanechnikov kernel
%                    'gauss' - Gaussian kernel
%   u1          :   first vector or matrix with data
%   u2          :   second vector or matrix with data (only in case of
%                   bivarite density function)
%
% OUTPUTS:
%   k           :   kernel
%
% COMMENTS:
%   Note that for kernel density estimation u has to be in
%   the format u = (x - xi)/bw
%   where:
%       x = data
%       xi = grid midpoints
%       bw = bandwidth
%
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (19/05/2007)


if nargin==3         % bivariate case
    s=u1.*u1+u2.*u2; d=2;
else            % univariate case
    s=u1.*u1; d=1;
end;

if  strcmp(kernel,'epan')==1
    c(1)=2; c(2)=pi;
    k = (0.5*(d+2)*(1-s)/c(d)) .* (abs(s)<1);   % Epanechikov kernel function
elseif strcmp(kernel,'gauss')==1
    k = (2*pi)^(-d/2) * exp(-0.5*s);            % Gaussian kernel function
else   error('unknown kernel')
end
