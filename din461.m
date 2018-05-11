function [] = din461(xquantity, yquantity, xunit, yunit, replaceNext2last, ax)
% DIN461  Apply DIN 461 style to diagram.
%   DIN461(XQUANTITY, YQUANTITY, XUNIT, YUNIT) applies DIN 461 style to
%   current axes.
%   
%   DIN461(XQUANTITY, YQUANTITY, XUNIT, YUNIT, REPLACENEXT2LAST) specifies
%   whether the unit labels replace the next to last number or are
%   placed between the last and next to last number.
%   * E. g. REPLACENEXT2LAST = [0 1] will place the x-unit label between 
%     the last and next to last number and replace the next to last number 
%     on the y-axis with the y-unit label. 
%   
%   DIN461(XQUANTITY, YQUANTITY, XUNIT, YUNIT, REPLACENEXT2LAST, AX) 
%   applies DIN 461 style to axes AX.
%   
%   See also FIGURE, PLOT, SUBPLOT, XLABEL, YLABEL, ANNOTATION

%% check inputs
if nargin < 6
    ax = gca;
end
if nargin < 5
    replaceNext2last = [0 0];
end
if nargin < 4
    yunit = [];
end
if nargin < 3
    xunit = [];
end
if nargin < 2
    yquantity = [];
end
if nargin < 1
    xquantity = [];
end

%% add quantity labels
xlabel(ax, xquantity);
ylabel(ax, yquantity, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'middle');

%% add unit labels
if strcmp(xunit, '°') || strcmp(xunit, '''') || strcmp(xunit, '''''')
    ax.XAxis.TickLabelFormat = ['%g' xunit];
elseif replaceNext2last(1)
    xtickdist = ax.Position(3)/(length(get(ax, 'XTick'))-1);
    xpos = [ax.Position(1)+ax.Position(3)-xtickdist*1.5, ax.Position(2)/2, xtickdist, ax.Position(2)/2];
    annotation('textbox', xpos, 'String', xunit, 'FitBoxToText', 'off', 'BackgroundColor', 'w', 'LineStyle', 'none', 'HorizontalAlignment', 'center');
else
    xtickdist = ax.Position(3)/(length(get(ax, 'XTick'))-1);
    xpos = [ax.Position(1)+ax.Position(3)-xtickdist, ax.Position(2), xtickdist, 0];
    annotation('textbox', xpos, 'String', xunit, 'FitBoxToText', 'on', 'LineStyle', 'none', 'HorizontalAlignment', 'center');
end % end if

if strcmp(yunit, '°') || strcmp(yunit, '''') || strcmp(yunit, '''''')
    ax.YAxis.TickLabelFormat = ['%g' yunit];
elseif replaceNext2last(2)
    ytickdist = ax.Position(4)/(length(get(ax, 'YTick'))-1);
    ypos = [0, ax.Position(2)+ax.Position(4)-ytickdist*1.5, ax.Position(1), ytickdist];
    annotation('textbox', ypos, 'String', yunit, 'FitBoxToText', 'off', 'BackgroundColor', 'w', 'LineStyle', 'none', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
else
    ytickdist = ax.Position(4)/(length(get(ax, 'YTick'))-1);
    ypos = [ax.Position(1), ax.Position(2)+ax.Position(4)-ytickdist, 0, ytickdist];
    annotation('textbox', ypos, 'String', yunit, 'FitBoxToText', 'on', 'LineStyle', 'none', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end % end if

%% add arrows
xlabelobj = get(ax, 'XLabel');
set(xlabelobj, 'Units', 'normalized');
xlabelpos(1) = xlabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
xlabelpos(2) = xlabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
xlabelpos(3) = xlabelobj.Extent(3)*ax.Position(3);
xlabelpos(4) = xlabelobj.Extent(4)*ax.Position(4);
annotation('arrow', 'Position', [xlabelpos(1)+xlabelpos(3)+0.02, xlabelpos(2)+xlabelpos(4)/2, 0.1, 0], 'HeadLength', 6, 'HeadWidth', 6);

ylabelobj = get(ax, 'YLabel');
set(ylabelobj, 'Units', 'normalized');
ylabelpos(1) = ylabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
ylabelpos(2) = ylabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
ylabelpos(3) = ylabelobj.Extent(3)*ax.Position(3);
ylabelpos(4) = ylabelobj.Extent(4)*ax.Position(4);
annotation('arrow', 'Position', [ylabelpos(1)+ylabelpos(3)/2, ylabelpos(2)+ylabelpos(4)+0.02, 0, 0.1], 'HeadLength', 6, 'HeadWidth', 6);

end % end function