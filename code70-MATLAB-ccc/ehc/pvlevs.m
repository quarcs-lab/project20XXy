function pvl=pvlevs(P,levels)

% pvlevs    Percentage contour levels:
%           given a matrix P reporting the heights of a bivariate density function
%           estimate, it calculates the hights corresponding to a set of
%           percentages of the volume of the density function.
%
% USAGE:
%   pvl=pvlevs(P,levels)
% 
% INPUTS:
%   P       :   n-by-n matrix with the heights of a bivariate density function estimate
%   levels  :   Vector with percentage levels. If empty, the following
%               levels are used: [95 90 75 50 25 10]
%
% OUTPUT:
%   pvl     :   vector of hights corresponding to the set of percentage levels
%               of the density function volume
% 
% COMMENTS:
%   The vector pvl can then be used as an input of the contour function to
%   plot contour levels that correspond to chosen percentage levels of the
%   volume. Percentage contours are particularly suited to identifying
%   modes in density estimates.
%   For this purpouse, when the vector "levels" contains only one
%   percentage level (say, i), the function returns an array [pvli pvli]
%   (see the help of the function contour for details).
%   
% Author: Stefano Magrini
% s.magrini@unive.it
% Revision: 1  (25/07/2006)


if  isempty(levels)
    levels = [95 90 75 50 25 10];
end

n=length(P);
ph = reshape(P,n*n,1);
phs = sort(ph);
phsc = cumsum(phs); phscr = phsc/max(phsc);

levels = 1 - (levels/100);
pvl = ones(1,length(levels));

counter = 1;
while   counter < 1+length(levels)
    loc = phscr - levels(counter);
    locneg = loc;
    for i=1:length(loc)
        if  loc(i)<0
            locneg(i)=abs(loc(i));
        else
            locneg(i)=Inf;
        end
    end
    ind1 = find(locneg==min(locneg));
    
    locpos = loc;
    for i=1:length(loc)
        if  loc(i)<0
            locpos(i)=Inf;
        else
            locpos(i)=loc(i);
        end
    end
    ind2 = find(locpos==min(locpos));
    
    zeroper = abs(loc(ind1))/(loc(ind2)-loc(ind1));
    pvl(counter) = phs(ind1)+(phs(ind2)-phs(ind1))*zeroper;
    counter = counter + 1;
end

if  length(levels)==1
    pvl = [pvl pvl];
end