function h=h2_bcv(A)

% h2_bcv    Biased Cross-Validation estimate of smoothing parameters h for bi-variate data. 
%           
%           Christian C. Beardah 1993-94   (modified by S. Magrini 2007)
%
% COMMENTS:
%   Requires a Gaussian kernel.
%   It is a hybrid of crossvalidation and direct plug-in estimates.
%    The main attraction of Biased Cross-Validation is that it is more stable
%    than Least Squares Cross-Validation in the sense that its asymptotic
%    variance is considerably lower. However, this reduction in variance
%    comes at the expense of an increase in bias, with BCV tending to be
%    larger than the Normal Scale estimate. Asymptotically BCV has a
%    relative slow convergence rate. 
%    (comment taken from KDETOOLS in WAFO toolbox version 2.1.0 April 2004)
%   Calls the following sub-finctions:
%       bcv2, remzero and knorm by C. Beardah
%


[n d]=size(A); 
if d~=2, 
   error('Wrong shape of data') 
end
%k = 'gauss';

% Transform A so rows have st. dev.=1:
oldA=A;
A=(oldA-ones(n,1)*mean(oldA))*diag(1./std(oldA));

maxit=100;

tol=1e-2;

gradf=zeros(2,1);

delta=1e-6;

i=0;

vx(1)=h1_ste(A(:,1));            % modified by S. Magrini
vy(1)=h1_ste(A(:,2));            % modified by S. Magrini

x0=vx(1);
y0=vy(1);

fn(1)=bcv2(A,vx(1),vy(1));

i=1; % i is the iteration counter.

while i <= maxit,

  gradf(1)=(bcv2(A,x0+delta,y0)-bcv2(A,x0-delta,y0))/(2*delta);
  gradf(2)=(bcv2(A,x0,y0+delta)-bcv2(A,x0,y0-delta))/(2*delta);

  gradf=gradf/(i*norm(gradf));

  r0=[x0 y0]';

  for j=1:31,
    M(j,:)=(r0+(j-16)*gradf/15)';
  end;

  L=(M(:,1)>0) & (M(:,2)>0);

  L=remzero([M,L]);

  M=L(:,1:2);
  
  [rM,cM]=size(M);
  
  for j=1:length(M),
    t(j,1)=bcv2(A,M(j,1),M(j,2));
  end;

  [N,I]=min(t);

  r=M(I,:)';

  vx(i+1)=r(1); % Store iterate.
  vy(i+1)=r(2); 

  fn(i+1)=N;

  if (abs(norm(r-r0)) < tol),

    h=r';

% Transform values of h back:

    h=diag(std(oldA))*h';
    h = h';
    return;
  end;

  i=i+1; % Update the iteration counter.

  x0=r(1);
  y0=r(2);

  clear t
 
end; % of while statement.

disp('Maximum number of iterations reached - terminating execution.');
return


function z=bcv2(A,h1,h2)
% BCV2        Biased cross-validation criterion function.
%          
%             Christian C. Beardah 1993-94 
n=length(A);
A1=A(:,1);
A2=A(:,2);
M1=A1*ones(size(A1'));
T1=(M1-M1')/h1;
M2=A2*ones(size(A2'));
T2=(M2-M2')/h2;
z=1/(4*pi*n*h1*h2);
T=T1.^2+T2.^2;
T=(T.^2-8*T+8).*knorm(T1).*knorm(T2);
T=T-diag(diag(T));
z=z+sum(sum(T))/(4*n*(n-1)*h1*h2);
return

function X=remzero(X)
% REMZERO     Removes rows containing zeroes from a matrix or vector.
%
%             Christian C. Beardah 1993
[r c]=size(X);
if r>1 & c>1,
  [i j]=find(X==0);
  X(i,:)=[];
  else,
    X=X(find(X));
end;
return

function k=knorm(x,y,z)
% KNORM       Uni-, Bi- or Tri-variate Normal Density Function.
%
%             Christian C. Beardah
if nargin==3,
  s=x.*x+y.*y+z.*z;
  elseif nargin==2,
    s=x.*x+y.*y;
    else,
      s=x.*x;
end;
k=(2*pi)^(-nargin/2)*exp(-0.5*s); 
return