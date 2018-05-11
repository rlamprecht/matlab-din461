function [] = din461(xquantity, yquantity, xunit, yunit, ax)
% DIN461  Apply DIN 461 style to diagram.
%   DIN461(XQUANTITY, YQUANTITY, XUNIT, YUNIT) applies DIN 461 style to
%   current axes.
%   
%   DIN461(XQUANTITY, YQUANTITY, XUNIT, YUNIT, AX) applies DIN 461 style to
%   axes AX.
%   
%   See also FIGURE, PLOT, SUBPLOT, XLABEL, YLABEL, ANNOTATION

%% check inputs
switch nargin
    case 4
        ax = gca;
    case 3
        ax = gca;
        yunit = [];
    case 2
        ax = gca;
        yunit = [];
        xunit = [];
    case 1
        ax = gca;
        yunit = [];
        xunit = [];
        yquantity = [];
    case 0
        ax = gca;
        yunit = [];
        xunit = [];
        yquantity = [];
        xquantity = [];
end % end switch

%% add quantity labels
xlabel(xquantity);
ylabel(yquantity, 'Rotation', 0, 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'middle');

%% add unit labels
if strcmp(xunit, '°') || strcmp(xunit, '''') || strcmp(xunit, '''''')
    xticklabel = get(ax, 'XTickLabel');
    for i = 1:length(xticklabel)
        xticklabel{i} = [xticklabel{i} xunit];
    end % end for i
    set(ax, 'XTickLabel', xticklabel);
else
    xtickdist = ax.Position(3)/(length(get(ax, 'XTick'))-1);
    xpos = [ax.Position(1)+ax.Position(3)-xtickdist, ax.Position(2), xtickdist, 0];
    annotation('textbox', xpos, 'String', xunit, 'FitBoxToText', 'on', 'LineStyle', 'none', 'HorizontalAlignment', 'center');
end % end if

if strcmp(yunit, '°') || strcmp(yunit, '''') || strcmp(yunit, '''''')
    yticklabel = get(ax, 'YTickLabel');
    for i = 1:length(yticklabel)
        yticklabel{i} = [yticklabel{i} yunit];
    end % end for i
    set(ax, 'YTickLabel', yticklabel);
else
    ytickdist = ax.Position(4)/(length(get(ax, 'YTick'))-1);
    ypos = [ax.Position(1), ax.Position(2)+ax.Position(4)-ytickdist, 0, ytickdist];
    annotation('textbox', ypos, 'String', yunit, 'FitBoxToText', 'on', 'LineStyle', 'none', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end % end if

%% add arrows
xlabelobj = get(ax, 'XLabel');
set(xlabelobj, 'Units', 'normalized');
xlabelposition(1) = xlabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
xlabelposition(2) = xlabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
xlabelposition(3) = xlabelobj.Extent(3)*ax.Position(3);
xlabelposition(4) = xlabelobj.Extent(4)*ax.Position(4);
annotation('arrow', 'Position', [xlabelposition(1)+xlabelposition(3)+0.02, xlabelposition(2)+xlabelposition(4)/2, 0.1, 0], 'HeadLength', 6, 'HeadWidth', 6);

ylabelobj = get(ax, 'YLabel');
set(ylabelobj, 'Units', 'normalized');
ylabelposition(1) = ylabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
ylabelposition(2) = ylabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
ylabelposition(3) = ylabelobj.Extent(3)*ax.Position(3);
ylabelposition(4) = ylabelobj.Extent(4)*ax.Position(4);
annotation('arrow', 'Position', [ylabelposition(1)+ylabelposition(3)/2, ylabelposition(2)+ylabelposition(4)+0.02, 0, 0.1], 'HeadLength', 6, 'HeadWidth', 6);

end % end function