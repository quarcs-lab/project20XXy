function h=h1_ste(A)

% h1_ste    2-stage Solve-The-Equation estimate of smoothing parameter h for univariate data.
%
%           hste(A) evaluates a 2-stage Solve the Equation value of h
%           for use with univariate data A and a Gaussian kernel
%
%   The function calls the following sub-functions:
%       siqr        - by C. Beardah and modified by S. Magrini;
%       deriv       - by C. Beardah and modified by S. Magrini;
%
%             Christian C. Beardah 1995  (modified by S. Magrini 2007)

n=length(A);

inc=128;

k = 'gauss';
R=1/(2*sqrt(pi));
mu2=1;
r=4;

P=inc*2;

n=length(A);

xmin=min(A);        % Find the minimum value of A.
xmax=max(A);        % Find the maximum value of A.
xrange=xmax-xmin;   % Find the range of A.

if siqr(A)>0,
  s=min([std(A) siqr(A)/1.34]);
  else,
    s=std(A);
end;

% xa holds the x 'axis' vector, defining a grid of x values where 
% the k.d. function will be evaluated and plotted.

ax=xmin-xrange/8;
bx=xmax+xrange/8;

xa=linspace(ax,bx,inc); 

c=zeros(inc,1);
deltax=(bx-ax)/(inc-1);
binx=floor((A-ax)/deltax)+1;

% Obtain the grid counts.

for i=1:n, % Loop over data points in x direction.
  c(binx(i))=c(binx(i))+(xa(binx(i)+1)-A(i))/deltax;
  c(binx(i)+1)=c(binx(i)+1)+(A(i)-xa(binx(i)))/deltax;  
end;

psi6=-15/(16*sqrt(pi)*s^7);

psi8=105/(32*sqrt(pi)*s^9);

k40=deriv(0);

g1=(-2*k40/(mu2*psi6*n))^(1/7);

[k40,k60]=deriv(0);

g2=(-2*k60/(mu2*psi8*n))^(1/9);

% Estimate psi6.

% Obtain the kernel weights.

[kw4,kw6]=deriv((bx-ax)*[0:inc-1]/((inc-1)*g2));

% Apply 'fftshift' to kw.

kw=[kw6,0,kw6([inc:-1:2])]';

% Perform the convolution.

z=real(ifft(fft(c,P).*fft(kw)));

psi6=sum(c.*z(1:inc))/(n*(n-1)*g2^7);

% Now estimate psi4.

% Obtain the kernel weights.

kw4=deriv((bx-ax)*[0:inc-1]/((inc-1)*g1));

% Apply 'fftshift' to kw.

kw=[kw4,0,kw4([inc:-1:2])]';

% Perform the convolution.

z=real(ifft(fft(c,P).*fft(kw)));

psi4=sum(c.*z(1:inc))/(n*(n-1)*g1^5);

ho=0;

h=h1_ns(A,k);

k40=deriv(0);

while abs(ho-h)/abs(h)>0.01,

  temp=h;

  gamma=((2*k40*mu2*psi4*h^5)/(-psi6*R))^(1/7);

% Now estimate psi4.

% Obtain the kernel weights.

  kw4=deriv((bx-ax)*[0:inc-1]/((inc-1)*gamma));

% Apply 'fftshift' to kw.

  kw=[kw4,0,kw4([inc:-1:2])]';

% Perform the convolution.

  z=real(ifft(fft(c,P).*fft(kw)));

  p4=sum(c.*z(1:inc))/(n*(n-1)*gamma^5);

  h=mu2^(-2/5)*R^(1/5)*(p4*n)^(-1/5);

  ho=temp;

end;  

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

function [y4,y6,y8,y10]=deriv(t)
% deriv     4th, 6th, 8th and 10th derivatives of the Normal kernel.
%
%           DERIV(T) finds the derivatives of the Gaussian kernel at the point T.
%
%           Christian C. Beardah 1995
y4=(t.^4-6*t.^2+3).*exp(-0.5*t.^2)/sqrt(2*pi);
if  nargout>1
    y6=(t.^6-15*t.^4+45*t.^2-15).*exp(-0.5*t.^2)/sqrt(2*pi);  
end
if  nargout>2
    y8=(t.^8-28*t.^6+210*t.^4-420*t.^2+105).*exp(-0.5*t.^2)/sqrt(2*pi);
end
if  nargout>3
    y10=(t.^10-45*t.^8+630*t.^6-3150*t.^4+4725*t.^2-945).*exp(-0.5*t.^2)/sqrt(2*pi);
end
return
