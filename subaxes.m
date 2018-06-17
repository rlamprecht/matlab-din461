function h = subaxes(m, n, p)
% SUBAXES Create axes in tiled positions without margin.
%   SUBAXES(m, n, p) divides the current figure into an m-by-n grid and
%   creates an axes for a subplot in the position specified by p.
%   
%   See also SUBPLOT
%   
%   Copyright (c) 2018 Oliver Kiethe
%   This file is licensed under the MIT license.
 
h = subplot(m, n, p);

p = p - 1;

pM = 1 + max(floor(p/n)) - min(floor(p/n));
pN = 1 + max(mod(p, n)) - min(mod(p, n));

outerPosition(1) = mod(min(p), n)/n;
outerPosition(2) = 1-(floor((max(p))/n)+1)/m;
outerPosition(3) = 1/n*pN;
outerPosition(4) = 1/m*pM;

set(h, 'OuterPosition', outerPosition);

end