function h=h2_dpi(A,l)

% h2_dpi    L-stage Direct Plug-In estimate of smoothing parameters h for bi-variate data.
%
%           Christian C. Beardah 1996     (modified by S. Magrini 2007)
%
% COMMENTS:
%   Requires a Gaussian kernel.
%   See Wand and Jones (1994), "Multivariate Plug-In Bandwidth Selection", "Computational Statistics".
%   L can be 0, 1, 2 or 3.
%   Calls the following sub-finctions:
%       psim, deriv and knorm by C. Beardah
%



k = 'gauss';
if nargin < 2
    l=2;
end
n=length(A);



% Transform A so rows have st. dev.=1:
oldA=A;
A=(oldA-ones(n,1)*mean(oldA))*diag(1./std(oldA));


if k=='gauss',
  R=1/(4*pi);
  mu2=2;

  K22=1/(2*pi);
  K40=3/(2*pi);
  K04=3/(2*pi);
  
  K42=-3/(2*pi);
  K24=-3/(2*pi);
  K60=-15/(2*pi);
  K06=-15/(2*pi);

  K44=9/(2*pi);
  K62=15/(2*pi);
  K26=15/(2*pi);
  K80=105/(2*pi);
  K08=105/(2*pi);
end;

sigma1=std(A(:,1));
sigma2=std(A(:,2));

rho=corrcoef(A);
rho=rho(1,2);

if l==3,

  lam100=945;
  lam010=945;
  lam82=105+840*rho^2;
  lam28=105+840*rho^2;
  lam64=45+540*rho^2+360*rho^4;
  lam46=45+540*rho^2+360*rho^4;

  psi100=lam100/(128*pi*sigma1^11*sigma2*(1-rho^2)^5.5);
  psi010=lam010/(128*pi*sigma1*sigma2^11*(1-rho^2)^5.5);
  psi82=lam82/(128*pi*sigma1^9*sigma2^3*(1-rho^2)^5.5);
  psi28=lam28/(128*pi*sigma1^3*sigma2^9*(1-rho^2)^5.5);
  psi64=lam64/(128*pi*sigma1^7*sigma2^5*(1-rho^2)^5.5);
  psi46=lam46/(128*pi*sigma1^5*sigma2^7*(1-rho^2)^5.5);

% The following are the smoothing parameters for 
% estimation of psi80, psi08, psi62, psi26 and psi44:

  a80=(-2*K80/(mu2*(psi100+psi82)*n))^(1/12);
  a08=(-2*K08/(mu2*(psi28+psi010)*n))^(1/12);
  a62=(-2*K62/(mu2*(psi82+psi64)*n))^(1/12);
  a26=(-2*K26/(mu2*(psi46+psi28)*n))^(1/12);
  a44=(-2*K44/(mu2*(psi64+psi46)*n))^(1/12);

  psi80=psim('80',A,a80);
  psi08=psim('08',A,a08);
  psi62=psim('62',A,a62);
  psi26=psim('26',A,a26);
  psi44=psim('44',A,a44);

end;

if l==2 | l==3,

  if l==2,
    lam80=105;
    lam08=105;
    lam62=15+90*rho^2;
    lam26=15+90*rho^2;
    lam44=9+72*rho^2+24*rho^4;

    psi80=lam80/(64*pi*sigma1^9*sigma2*(1-rho^2)^4.5);
    psi08=lam08/(64*pi*sigma1*sigma2^9*(1-rho^2)^4.5);
    psi62=lam62/(64*pi*sigma1^7*sigma2^3*(1-rho^2)^4.5);
    psi26=lam26/(64*pi*sigma1^3*sigma2^7*(1-rho^2)^4.5);
    psi44=lam44/(64*pi*sigma1^5*sigma2^5*(1-rho^2)^4.5);
  end;

% The following are the smoothing parameters for 
% estimation of psi60, psi06, psi42 and psi24:

  a60=(-2*K60/(mu2*(psi80+psi62)*n))^0.1;
  a06=(-2*K06/(mu2*(psi26+psi08)*n))^0.1;
  a42=(-2*K42/(mu2*(psi62+psi44)*n))^0.1;
  a24=(-2*K24/(mu2*(psi44+psi26)*n))^0.1;

  psi60=psim('60',A,a60);
  psi06=psim('06',A,a06);
  psi42=psim('42',A,a42);
  psi24=psim('24',A,a24);

end;

if l==1 | l==2 | l==3,

  if l==1,
    lam06=15;
    lam60=15;
    lam24=3+12*rho^2;
    lam42=3+12*rho^2;

    psi60=-lam60/(32*pi*sigma1^7*sigma2*(1-rho^2)^3.5);
    psi06=-lam06/(32*pi*sigma1*sigma2^7*(1-rho^2)^3.5);
    psi42=-lam42/(32*pi*sigma1^5*sigma2^3*(1-rho^2)^3.5);
    psi24=-lam24/(32*pi*sigma1^3*sigma2^5*(1-rho^2)^3.5);
  end;

% The following are the smoothing parameters for 
% estimation of psi40, psi04 and psi22:

  a40=(-2*K40/(mu2*(psi60+psi42)*n))^0.125;
  a04=(-2*K04/(mu2*(psi24+psi06)*n))^0.125;
  a22=(-2*K22/(mu2*(psi42+psi24)*n))^0.125;

  psi40=psim('40',A,a40);
  psi04=psim('04',A,a04);
  psi22=psim('22',A,a22);

end;

if l==0,

  lam04=3;
  lam40=3;
  lam22=3/2;

  psi40=-lam40/(16*pi*sigma1^5*sigma2*(1-rho^2)^2.5);
  psi04=-lam04/(16*pi*sigma1*sigma2^5*(1-rho^2)^2.5);
  psi22=-lam22/(16*pi*sigma1^3*sigma2^3*(1-rho^2)^2.5);

end;

h1=(psi04^0.75*R/(n*mu2^2*psi40^0.75*(sqrt(psi40*psi04)+psi22)))^(1/6);
h2=h1*(psi40/psi04)^0.25;

h=real([h1, h2]);

% Transform values of h back:

h=h*diag(std(oldA));
% h=h*sqrtm(cov(oldA));

return

function p=psim(m,A,h)
% PSIM        Calculate psi_m by brute force.
%
%             PSIM(M,A,H)
%
%             Christian C. Beardah 1996
n=length(A);
Xi=zeros(n,n);
Xj=Xi;
Yi=Xi;
Yj=Xi;
o=ones(1,n);
Xj=A(:,1)*o;
Xi=Xj';
Yj=A(:,2)*o;
Yi=Yj';
p=sum(sum(deriv2((Xi-Xj)/h,(Yi-Yj)/h,m)))/(h*n^2);

return

function k=deriv2(x,y,d)
% DERIV2      High order partial derivatives of the Normal kernel.
%
%             Example: k42=deriv2(0,0,'42')
%
%             DERIV2(X,Y,D) finds the partial derivatives of the kernel K 
%             at the point (X,Y).  D defines the derivative. 
%
%             Christian C. Beardah 1995
k=zeros(size(x));
xd=str2num(d(1));
yd=str2num(d(2));
if xd==0,
  xterm=1;
  elseif xd==2,
    xterm=x.^2-1;  
    elseif xd==4,
      xterm=x.^4-6*x.^2+3;
      elseif xd==6,
        xterm=x.^6-15*x.^4+45*x.^2-15;
        elseif xd==8,
          xterm=x.^8-28*x.^6+210*x.^4-420*x.^2+105;
end;
if yd==0,
  yterm=1;
  elseif yd==2,
    yterm=y.^2-1;  
    elseif yd==4,
      yterm=y.^4-6*y.^2+3;
      elseif yd==6,
        yterm=y.^6-15*y.^4+45*y.^2-15;
        elseif yd==8,
          yterm=y.^8-28*y.^6+210*y.^4-420*y.^2+105;
end;
k=xterm.*yterm.*knorm(x,y);
return

function k=knorm(x,y,z)
% KNORM       Uni-, Bi- or Tri-variate Normal Density Function.
if nargin==3,
  s=x.*x+y.*y+z.*z;
  elseif nargin==2,
    s=x.*x+y.*y;
    else,
      s=x.*x;
end;
k=(2*pi)^(-nargin/2)*exp(-0.5*s); 
return