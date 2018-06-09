function set_default_plot_properties(varargin)
% SET_DEFAULT_PLOT_PROPERTIES Sets the default plot properies.
%   SET_DEFAULT_PLOT_PROPERTIES() Sets some plot properties to some default
%   values.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'fontname', fontname) specifies the
%   default fontname.
%   * Default is 'Times'.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'fontsize', fontsize) specifies the
%   default fontsize.
%   * Default is 12.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'grid', grid) specifies whether the
%   grid is on or off by default.
%   * Default is 'on'.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'background', background) specifies
%   the default background color.
%   * Default is 'w'.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'interpreter', interpreter) specifies
%   the default text interpreter.
%   * Default is 'latex'.
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'figsize', figsize) specifies the
%   default figure size.
%   * Default is [150 100].
%   
%   SET_DEFAULT_PLOT_PROPERTIES(___, 'colorOrder', colorOrder) specifies
%   the default color order.
%   * Default is 'brgk' (blue-red-green-black).
%
% See also FIGURE, PLOT, XLABEL, YLABEL, LEGEND, ANNOTATION

%% Input arguments
p = inputParser;
addParameter(p, 'fontname', 'Times', @ischar);
addParameter(p, 'fontsize', 12, @isnumeric);
addParameter(p, 'grid', 'on', @ischar);
addParameter(p, 'background', 'w', @(x) ischar(x) || isnumeric(x));
addParameter(p, 'interpreter', 'latex', @ischar);
addParameter(p, 'figsize', [150 100], @isnumeric);
addParameter(p, 'colorOrder', 'brgk', @ischar);

parse(p, varargin{:});
fontname = p.Results.fontname;
fontsize = p.Results.fontsize;
grid = p.Results.grid;
background = p.Results.background;
interpreter = p.Results.interpreter;
figsize = p.Results.figsize;
switch p.Results.colorOrder
    case 'brgk'
        colorOrder = [      0         0    1.0000; ...
                       1.0000         0         0; ...
                            0    0.5000         0; ...
                            0         0         0];
    case 'new'
        colorOrder = [     0    0.4470    0.7410; ...
                      0.8500    0.3250    0.0980; ...
                      0.9290    0.6940    0.1250; ...
                      0.4940    0.1840    0.5560; ...
                      0.4660    0.6740    0.1880; ...
                      0.3010    0.7450    0.9330; ...
                      0.6350    0.0780    0.1840];
    case 'old'
        colorOrder = [      0         0    1.0000; ...
                            0    0.5000         0; ...
                       1.0000         0         0; ...
                            0    0.7500    0.7500; ...
                       0.7500         0    0.7500; ...
                       0.7500    0.7500         0; ...
                       0.2500    0.2500    0.2500];
    case 'grayscale'
        colorOrder = [      0         0         0; ...
                       0.4000    0.4000    0.4000; ...
                       0.8000    0.8000    0.8000];
    otherwise
        colorOrder = [     0    0.4470    0.7410; ...
                      0.8500    0.3250    0.0980; ...
                      0.9290    0.6940    0.1250; ...
                      0.4940    0.1840    0.5560; ...
                      0.4660    0.6740    0.1880; ...
                      0.3010    0.7450    0.9330; ...
                      0.6350    0.0780    0.1840];
end % end switch

%% Figure
set(0, 'defaultFigureColor', background);
set(0, 'defaultFigureRenderer', 'painters');
% Figure position in middle of screen
set(0, 'Units', 'pixels');
screen = get(0, 'ScreenSize');
% Figure size
fig_size = figsize.*get(0, 'ScreenPixelsPerInch')./25.4;
xpos = screen(3)/2-fig_size(1)/2;
ypos = screen(4)/2-fig_size(2)/2-10;
set(0, 'defaultFigurePosition', [xpos ypos fig_size])
set(0, 'defaultFigurePaperunits', 'centimeters');
set(0, 'defaultFigurePapersize', figsize);

%% Text
set(0, 'defaultTextInterpreter', interpreter);
set(0, 'defaultTextFontname', fontname);
set(0, 'defaultTextFontangle', 'normal');
set(0, 'defaultTextFontsize', fontsize);

%% Annotations
set(0, 'defaultTextboxshapeInterpreter', interpreter);
set(0, 'defaultTextboxshapeFontname', fontname);
set(0, 'defaultTextboxshapeFontangle', 'normal');
set(0, 'defaultTextboxshapeFontsize', fontsize);
set(0, 'defaultTextarrowshapeInterpreter', interpreter);
set(0, 'defaultTextarrowshapeFontname', fontname);
set(0, 'defaultTextarrowshapeFontangle', 'normal');
set(0, 'defaultTextarrowshapeFontsize', fontsize);

%% Axes
set(0, 'defaultAxesColorOrder', colorOrder);
set(0, 'defaultAxesLineStyleOrder', '-|--|:|-.');
set(0, 'defaultAxesGridColor', 'k');
set(0, 'defaultAxesGridAlpha', 0.8);
set(0, 'defaultAxesMinorGridColor', 'k');
set(0, 'defaultAxesMinorGridAlpha', 0.4);
set(0, 'defaultAxesGridLineStyle', ':');
set(0, 'defaultAxesXGrid', grid);
set(0, 'defaultAxesYGrid', grid);
set(0, 'defaultAxesBox', 'on');
set(0, 'defaultAxesFontsize', fontsize);
set(0, 'defaultAxesFontname', fontname);
set(0, 'defaultAxesFontangle', 'normal');

%% Legend
set(0, 'defaultLegendInterpreter', interpreter);
% Changing the axes font size automatically sets the legend font size 
% to 90% of the axes font size.

end