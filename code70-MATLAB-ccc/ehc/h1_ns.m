function h=h1_ns(A,k)

% h1_ns     Normal Scale estimate of smoothing parameter h for univariate data.
%
%           hns(A,k) evaluates an 'optimal' value of h for use 
%           with uni-variate data A and with kernel given by the 
%           function in k:
%             'gauss' is the normal function
%             'epan' is the Epanechnikov function
%           See Silverman (1986) page 76 for details. 
%
%           Christian C. Beardah 1994-95 (modified by S. Magrini 2007)
%
%   Calls the following sub-function:
%       siqr        - by C. Beardah and modified by S. Magrini;
%


n=length(A);

if strcmp(k,'k_gauss')==1 | strcmp(k,'gauss')==1 | strcmp(k,'knorm')==1,           % Gaussian kernel
    const=1.0592;
  elseif strcmp(k,'k_epan')==1 | strcmp(k,'kepan')==1 | strcmp(k,'epan')==1,       % Epanechnikov kernel
    const=2.34;
end;

if siqr(A)>0,
  s=min([std(A) siqr(A)/1.34]);
  else,
    s=std(A);
end;

h=const*s*n^(-1/5);

return

function y=siqr(x)
% siqr      Sample Interquartile Range. 
%
%           SIQR(X) calculates the sample interquarile range (IQR) of X.
%
%           Christian C. Beardah 1995
n=length(x);
[order index]=sort(x);
mlo=ceil(n/4);
mhi=ceil(3*n/4);
if mlo>0 & mlo<n,
  zlo=(order(mlo)+order(mlo+1))/2;
end;
if mhi>0 & mhi<n,
  zhi=(order(mhi)+order(mhi+1))/2;
end;
y = zhi - zlo;

return