function [z,P,d_joint,d_marginalN,d_iter,half_life,iterg,d_ergodic]=ske(XYdata,bw,int,k,iterations,alpha)

% ske       Kernel smooth estimate of the stochastic kernel (Quah, 1997)
%           and of the corresponding ergodic distribution. The way in which
%           the ergodic distribution is estimated is in the spirit of
%           Johnson (2005). 
%   Given two cross-sectional series of per capita income (relative to
%   respective sample averages) at time T and T+K (labelled Y_T and
%   Y_T+K), the function:
%       1.  partitions the data support into a number of non-overlapping
%           intervals. The partition is the same for both series;
%       2.  using this partition, it estimates the stochastic kernel
%           (conditional distribution) 
%               p(Y_T+K|Y_T) = p(Y_T, Y_T+K)/p(Y_T)
%           where:
%               p(Y_T, Y_T+K) is the joint distribution of Y_T and Y_T+K
%               p(Y_T) is the marginal distribution
%       3.  it re-scales the stochastic kernel (in the spirit of Johnson
%           2005) so that it assumes the same structure of a Markov chain;
%       4.  it estimates:
%            the ergodic distribution (as explained in Magrini, 1999)
%            the half-life of the chain (as in Shorrocks, 1978)
%            the number of iterations to reach the ergodic
%       5.  it estimates the shape of the distribution after some
%           iterations of the chain
%
% USAGE:
%   [z,P,d_marginalN,d_iter,half_life,iterg,d_ergodic]=ske(XYdata,bw,int,k,iterations,alpha)
% 
% INPUTS:
%   XYdata      :   n-by-2 matrix with the cross-sectional data at two 
%                   different points in time; the first column refers to
%                   time T, the second to time T+K.
%   bw          :   the bandwidth to use. Can be a scalar or a string element
%                   specifying the estimator. Supported estimators are:
%                    'h1_os' - Terrell's OverSmoothed (for Gaussian kernel and univariate data)
%                    'h1_ns' - Basic Normal Scale (Silverman, 1986; for univariate data)
%                    'h1_ste' - 2-stage Solve-the-Equation (for Gaussian kernel and univariate data)
%                    'h1_lscv' - Least Square Cross-Validation (for univariate data) 
%                    'h2_bcv' - Biased Cross-Validation (for bivariate data and Gaussian product kernels) 
%                    'h2_dpi' - L-stage Direct Plug-In (for bivariate data and Gaussian product kernels) 
%                    'hm_nrr' - Multivariate Normal Reference Rule (for multivariate data and product kernels) 
%   int         :   number of non-overlapping intervals for partitioning the support.
%   k           :   String argument specifying the type of kernel to be used.
%                   Supported kernels are:
%                    'epan' - Epanechnikov kernel
%                    'gauss' - Gaussian kernel
%   iterations  :   Number of iterations in order to evaluate transitional dynamics.
%                   If 0, the half-life of the chain is used.
%   alpha       :   sensitivity parameter for adaptive kernel estimation.
%                   The value for alpha must be within 0 and 1 (extremes included):  
%                    if 0, a fixed bandwidth bandwidth is used (as specified by bw). 
%     
% OUTPUT:
%   z           :   grid midpoints of the data support partition
%   P           :   matrix with the heights of the stochastic kernel
%                   estimate. The matrix has the same structure of a Markov
%                   chain
%   d_joint     :   estimate of the joint distribution (T T+K) 
%   d_marginalN :   estimate of the distribution at time T (normalised so
%                   that it sums to 1)
%   d_iter      :   estimate of the distribution after iteration of the
%                   chain
%   half_life   :   half-life of the chain
%   iterg       :   number of iterations to reach the ergodic
%   d_ergodic   :   estimate of the ergodic distribution
%
% COMMENTS:
%   The function makes use of product kernels to estimate the joint distribution. 
%   The marginal distribution is estimated from the joint.
%   The P matrix is estimated in the spirit of Johnson 2005. The fact that
%   the marginal distribution is obtained from the joint ensures that P is a
%   proper stochastic matrix for any number of non-overlapping intervals
%   (int) in the partitioning.
%   The function calls the following functions:
%       k_fun       - by S. Magrini;
%       h1_os       - by S. Magrini (for Gaussian kernel only);
%       h1_ns       - by C. Beardah and adapted for the use with SKE;
%       h1_ste      - by C. Beardah and adapted for the use with SKE (for Gaussian kernel only);
%       h1_lscv     - by C. Beardah and adapted for the use with SKE;
%       h2_bcv      - by C. Beardah and adapted for the use with SKE (for Gaussian kernel only);
%       h2_dpi      - by C. Beardah and adapted for the use with SKE (for Gaussian kernel only);
%       h1_mnrr     - by S. Magrini;
%   
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 7  (26/06/2007)


%%%%    1    PARTITION THE SUPPORT INTO A SET OF NON-OVERLAPPING INTERVALS
%%%     check the data
[n,dim]=size(XYdata);                         % dimensions of the data matrix
if  dim ~= 2                                  % check that the data matrix has 2 columns
    error(' Sorry, the data matrix has not the proper format  ');
end
initial=XYdata(:,1);                        % extract the first column of XYdata into the vector "initial"
final=XYdata(:,2);                          % extract the second column of XYdata into the vector "final"
%%%     retrieve or calculate overall bandwidths
if  isnumeric(bw)==1
    bwo_i = bw(1); bwo_f = bw(2);
else
    if  strcmp(bw,'h1_os')==1
        bwo_i = h1_os(initial); bwo_f = h1_os(final);
    elseif  strcmp(bw,'h1_ns')==1
        bwo_i = h1_ns(initial,k); bwo_f = h1_ns(final,k);
    elseif  strcmp(bw,'h1_ste')==1
        bwo_i = h1_ste(initial); bwo_f = h1_ste(final);
    elseif  strcmp(bw,'h1_lscv')==1
        bwo_i = h1_lscv(initial,k); bwo_f = h1_lscv(final,k);
    elseif  strcmp(bw,'h2_bcv')==1
        bwo = h2_bcv(XYdata); bwo_i = bwo(1,1); bwo_f = bwo(1,2);      % to be checked! extreme oversmoothing!
    elseif  strcmp(bw,'h2_dpi')==1
        bwo = h2_dpi(XYdata,2); bwo_i = bwo(1,1); bwo_f = bwo(1,2); 
    elseif  strcmp(bw,'hm_nrr')==1
        bwo = hm_nrr(XYdata,k); bwo_i = bwo(1,1); bwo_f = bwo(1,2); 
    end
end
bwo=[bwo_i bwo_f];
%%%     partition the support
min_i = min(initial); max_i = max(initial); min_f = min(final); max_f = max(final);     % extremes of the variables
max_o = max([max_i max_f]); min_o = min([min_i min_f]);                                 % overall max and min
a=min_o-0.5*min(bwo); b=max_o+0.5*min(bwo);                                             % extremes of the support [a b]
ssize=(b-a)/int; s=linspace(a,b,int+1);                                                 % grid 
for i=1:int
    z(i)=s(i)+(ssize/2);                                                                % grid midpoints
end


%%%%    2     ADJUST BANDWIDTHS FOR ADAPTIVE KERNEL ESTIMATION
%%%     pilot estimate of the joint distribution (at all data points)
A=[initial final];
s_pilot=zeros(n,1);
for i=1:n
  s_pilot = s_pilot + k_fun(k,(initial-A(i,1)*ones(size(n)))/bwo_i,(final-A(i,2)*ones(size(n)))/bwo_f);
end;
fjoint_pilot = s_pilot/(n*bwo_i*bwo_f);
%%%     local bandwidths
g=exp(sum(log(fjoint_pilot))/n);            % geometric mean of pilot estimate at all data points
lambda=(fjoint_pilot/g).^(-alpha);          % local bandwidth parameters
bw_i=bwo_i*lambda; bw_f=bwo_f*lambda;       % local bandwidths


%%%%    3   STOCHASTIC KERNEL
%%%     Joint distribution
[Xg,Yg]=meshgrid(z,z);
s = zeros(int,int);
for i=1:n
    s = s + (bw_i(i)*bw_f(i))^(-1) * k_fun(k,(Xg-A(i,1)*ones(size(Xg)))/bw_i(i),(Yg-A(i,2)*ones(size(Yg)))/bw_f(i));
end
d_joint = s'/n;
%%%     Marginal distribution (corresponds to the first variable in matrix "data")
d_marginal=sum(d_joint'.*ssize);                % rough estimate of the marginal distribution
%%      Check if the pdf of the marginal distribution contains zeros
if any(d_marginal == 0)
    error(' Sorry, the pdf of the marginal distribution contains zeros! ');
end
%%%%    Conditional distribution (or stochastic kernel)
d_marginals=repmat(d_marginal',1,int);
d_conditional=d_joint./d_marginals;


%%%%    4   P MATRIX
P=d_joint./d_marginals.*ssize;
%%%     Check if P is a stochastic matrix
if sum(P') ~= ones(1,int)       % check that the row sums of P are equal to 1
    error(' Sorry, the transition probability matrix is not a stochastic matrix ');
end
%%%     Check if an ergodic distribution exists
eigvals_s=sort(abs(eig(P)));    % sort the modulus of the eigenvalues of P
if eigvals_s(int-1)==1          % check that the second eigenvalue is strictly smaller than 1 
    error(' Sorry, the ergodic distribution does not exist ');
end


%%%%    5   ERGODIC DISTRIBUTION  
%%%     5.1 Direct method (as explained in Magrini, 1999)
A=eye(int)-P;
for i=1:int
    Ai=A; Ai(:,i)=[]; Ai(i,:)=[]; cof(i)=(-1^(i+i)*det(Ai));
end
for i=1:int
    d_ergodic(i)=cof(i)/sum(cof');  % vector with the ergodic distribution
end
%%%     5.2 HALF-LIFE OF THE CHAIN
half_life=(-log(2))/log(eigvals_s(int-1));  % as defined by Shorrocks (1978)
%%%     5.3 ITERATIONS TO REACH THE ERGODIC
%%      Check that d_marginal sums to one; if not, normalise d_marginal
if sum(d_marginal') ~= 1
    %warning(' The frequencies of the initial distribution do not sum to 1. Normalising! ');
    for i=1:int
        d_marginalN(i) = d_marginal(i)/sum(d_marginal');
    end
end
d_old = d_marginalN;
P_erg = P;
d_new = d_old*P_erg;        % distribution after one transition
iterg=0;                    % initialize counter
while (max(abs(d_old-d_new)) > 0.0000000001) & (iterg < 10000),
    d_old = d_new;
    P_erg = P_erg*P_erg;    % power of P
    d_new = d_old*P_erg;    % compute a new distribution
    iterg = iterg+1;        % increment counter
end


%%%%    6   TRANSITIONAL DYNAMICS
%%%     Number of iterations
if  iterations == 0;
    niterations = round(half_life);
else niterations = iterations;
end
%%%     Iterate the chain
P_iter=P^niterations;
d_iter=d_marginalN*P_iter;        % distribution after iteration