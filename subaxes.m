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

outerPosition(1) = mod(p-1, n)/n;
outerPosition(2) = 1-(floor((p-1)/n)+1)/m;
outerPosition(3) = 1/n;
outerPosition(4) = 1/m;

set(h, 'OuterPosition', outerPosition);

end