function Clev=rncl(C,h,levels)

% rncl      Rename contour labels:
%           in a contour plot, substitutes the label values of contours generated
%           by the function contour with new values.
%   The Matlab function [C,h]=contour(...) draws a contour plot. Contour
%   lines are then labelled using clabel(C,h). The output is a contour plot
%   with lines labelled according the matrix C.
%   rncl(C,h,levels) produces a new contour matrix in which the
%   original contour line labels are substituted by the values in the
%   vector levels. The number of elements in the vector levels must be
%   equal to the number of contour lines produced by the contour function.
%
% USAGE:
%   Clev=rncl(C,h,levels)
% 
% INPUTS:
%   C           :   contour matrix created by the function contour: 
%                   [C,h]=contour(...)
%   h           :   vector of handles to graphic objects created by the
%                   funtion contour: [C,h]=contour(...)
%   levels      :   vector of new values for the contour labels
%
% OUTPUT:
%   Clev        :   new contour matrix in which original contour line
%                   labels are substituted by the values specified in the
%                   vector levels
% EXAMPLE:
%       [C,h]=contour(Z,3);
%       levels=[0.90 0.75 0.50];
%       Clev=rncl(C,h,levels);
%       clabel(Clev,h);
%  This example draws a contour plot of matrix Z with 3 contour levels and
%  lables the contour lines according to the values in vector levels 
%
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (23/07/2006)


Clev=C;
Clen=length(C');
hlen=length(h);
hpos=ones(1,hlen);
hpos(1,1)=1;
for i=2:hlen
    hpos(1,i)=hpos(1,i-1)+C(2,hpos(1,i-1))+1;
end
Clev(1,1)=levels(1)/100;
lev=1;
for i=2:hlen
    if C(1,hpos(i))==C(1,hpos(i-1))
        Clev(1,hpos(i))=Clev(1,hpos(i-1));
    else
        Clev(1,hpos(i))=levels(lev+1)/100; lev=lev+1;
    end
end