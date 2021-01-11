function [h,hvec,score]=h1_lscv(A,k,steps)

% h1_lscv   Least Squares Cross-Validation estimate of smoothing parameter h for univariate data.
%
%           hlscv(A,k,steps) estimates the least square cross-validation
%           value of h
%
%           NB: steps is optional (default = 100)
%
%           Christian C. Beardah 1995  (modified by S. Magrini 2007)
%
%   Calls the following function:
%       h1_ns       - by C. Beardah and modified by S. Magrini;
%   Calls the following sub-function:
%       kde1        - by S. Magrini
%


if nargin==2,
  steps=100;
end;

n=length(A);

inc=512;

M=A*ones(size(A'));

Y1=(M-M');

H=h1_ns(A,k);

hvec=linspace(0.1*H,2*H,steps);

for i=1:length(hvec),

  [y,xa,hbase]=kde1(A,hvec(i),inc,[ ],k);
  
  delta=xa(2)-xa(1);

  L1=delta*sum(y.^2);

  Y=Y1/hvec(i);

  %L2=sum(sum(feval(k,Y)))/(hvec(i)*(n-1))-n*feval(k,0)/(hvec(i)*(n-1));
  L2=sum(sum(k_fun(k,Y)))/(hvec(i)*(n-1))-n*k_fun(k,0)/(hvec(i)*(n-1));

  score(i)=L1-2*L2/n;

end;

[L,I]=min(score);

h=hvec(I);


return

function [fx,xgm,h]=kde1(x,bw,int,range,k)
% kde1      kernel smooth estimate of an univariate distribution.
% 
% USAGE:
%     [fx,xgm,h]=kde1(x,bw,int,range,k)
% 
% INPUTS:
%   x       : n-by-1 vector with the data 
%   bw      : the bandwidth to use. Can be a scalar or a string element
%             specifying the estimator. Supported estimators are:
%                    'hos' - Terrell's OverSmoothed
%                    'hns' - Basic Normal Scale (Silverman, 1986)
%                    'hste' - 2-stage Solve-the-Equation
%                    'hlscv' - Least Square Cross-Validation
%   int     : number of intervals to use
%   range   : range to calculate the intervals over; in the form [xmin xmax]. 
%             If empty, the range goes from the minimum to the maximum of x
%   k       : string argument specifying the type of kernel to be used
%     
% OUTPUT:
%   fx      : bin heights (kde estimate)
%   xgm     : grid midpoints
%   h       : bandwidth size
% 
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (19/05/2007)
n = length(x);                                              % number of observations
if isempty(range)                                           % range
    xmin=min(x); xmax=max(x);
else
    xmin=range(1); xmax=range(2);
end
if isempty(int)                                             % nodes
    int=length(x);
end
xgm=(linspace(xmin,xmax,int))';                             % grid midpoints
% BANDWIDTH ESTIMATION
if  isnumeric(bw)==1
    h = bw;
else
    if  strcmp(bw,'hos')==1
        h = hos(x);
    elseif  strcmp(bw,'hns')==1
        h = hns(x,k);
    elseif  strcmp(bw,'hste')==1
        h = hste(x);                        % requires a Gaussian kernel
    elseif  strcmp(bw,'hlscv')==1
        h = hlscv(x,k)
    end
end
% UNIVARIATE DISTRIBUTION 
s_f = zeros(int,1);
for i=1:n
    s_f = s_f + k_fun(k,(xgm-x(i,:)*ones(size(xgm)))/h);
end
fx = s_f/(n*h);

return
