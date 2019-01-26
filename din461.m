function [] = din461(varargin)
% DIN461  DIN 461 style for 2D plots
%   DIN461(xquantity, yquantity, xunit, yunit) applies DIN 461 style to
%   current axes.
%   
%   DIN461(ax, ___) applies DIN 461 style to axes ax.
%   
%   DIN461(___, 'replacePenultimate', replacePenultimate) specifies
%   whether the unit labels replace the penultimate number or are
%   placed between the last and penultimate number.
%   * E. g. replacePenultimate = [0 1] will place the x-unit label between 
%     the last and penultimate number and replace the penultimate number 
%     on the y-axis with the y-unit label.
%   * Default is [0 0].
%   
%   DIN461(___, 'verticalYLabel', verticalYLabel) specifies whether the
%   ylabel is vertical or horizontal.
%   * Default is 0.
%   
%   See also FIGURE, PLOT, SUBAXES, XLABEL, YLABEL, ANNOTATION,
%   SET_DEFAULT_PLOT_PROPERTIES
%
%   Copyright (c) 2018 Oliver Kiethe
%   This file is licensed under the MIT license.

%% Input arguments
p = inputParser;
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    addRequired(p, 'ax', @(x) isa(x, 'matlab.graphics.axis.Axes'));
end % end if
addRequired(p, 'xquantity', @ischar);
addRequired(p, 'yquantity', @ischar);
addRequired(p, 'xunit', @ischar);
addRequired(p, 'yunit', @ischar);
addParameter(p, 'replacePenultimate', [0 0], @(x) (islogical(x) || isnumeric(x)) && length(x) == 2);
addParameter(p, 'verticalYLabel', 0, @(x) (islogical(x) || isnumeric(x)) && isscalar(x));

parse(p, varargin{:});
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = p.Results.ax;
else
    ax = gca;
end % end if
xquantity = p.Results.xquantity;
yquantity = p.Results.yquantity;
xunit = p.Results.xunit;
yunit = p.Results.yunit;
replacePenultimate = p.Results.replacePenultimate;
verticalYLabel = p.Results.verticalYLabel;

%% Add quantity labels
xlabel(ax, xquantity);
if verticalYLabel
    ylabel(ax, yquantity, 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
else
    ylabel(ax, yquantity, 'Rotation', 0, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end % end if

%% Get exponent
xtick = get(ax, 'XTick');
xscale = get(ax, 'XScale');
xticklabel = get(ax, 'XTickLabel');
if strcmp(xscale, 'linear')
    ind = find(xtick);
    xexp = round(log10(xtick(ind(1))/str2double(xticklabel{ind(1)})));
else
    xexp = 0;
end % end if

ytick = get(ax, 'YTick');
yscale = get(ax, 'YScale');
yticklabel = get(ax, 'YTickLabel');
if strcmp(yscale, 'linear')
    ind = find(ytick);
    yexp = round(log10(ytick(ind(1))/str2double(yticklabel{ind(1)})));
else
    yexp = 0;
end % end if

%% Replace decimal points with comma
xticklabel = strrep(xticklabel, '.', ',');
set(ax, 'XTickLabel', xticklabel);

yticklabel = strrep(yticklabel, '.', ',');
set(ax, 'YTickLabel', yticklabel);

%% Add unit labels
if (strcmp(xunit, '°') || strcmp(xunit, '''') || strcmp(xunit, '''''')) && strcmp(xscale, 'linear')
    if strcmp(xunit, '°') && strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
        for i = 1:length(xticklabel)
            xticklabel{i} = strrep(['$' xticklabel{i} '^{\circ}$'], ',', '{,}');
        end % end for i
    else
        for i = 1:length(xticklabel)
            xticklabel{i} = [xticklabel{i} xunit];
        end % end for i
    end % end if
    set(ax, 'XTickLabel', xticklabel);
elseif replacePenultimate(1)
    xticklabel{end-1} = xunit;
    set(ax, 'XTickLabel', xticklabel);
else
    xtickdistance = ax.Position(3)/(length(get(ax, 'XTick'))-1);
    xl = xlim(ax);
    if strcmp(xscale, 'linear')
        if length(xtick) > 1
            xtickdistance = (xtick(end)-xtick(1))/(length(xtick)-1)/diff(xl)*ax.Position(3);
            xtickend = (xl(2)-xtick(end))/diff(xl)*ax.Position(3);
        else
            xtickdistance = ax.Position(3);
            xtickend = (xl(1)-xtick(end))/diff(xl)*ax.Position(3);
        end % end if
    else
        if length(xtick) > 1
            xtickdistance = log10(xtick(end)/xtick(1))/(length(xtick)-1)/log10(xl(2)/xl(1))*ax.Position(3);
            xtickend = log10(xl(2)/xtick(end))/log10(xl(2)/xl(1))*ax.Position(3);
        else
            xtickdistance = ax.Position(3);
            xtickend = log10(xl(1)/xtick(end))/log10(xl(2)/xl(1))*ax.Position(3);
        end % end if
    end % end if
    xpos = [ax.Position(1)+ax.Position(3)-xtickdistance-xtickend, ax.Position(2), xtickdistance, 0];
    xunitlabel = annotation('textbox', xpos, 'String', xunit, 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
end % end if

if (strcmp(yunit, '°') || strcmp(yunit, '''') || strcmp(yunit, '''''')) && strcmp(yscale, 'linear')
    if strcmp(yunit, '°') && strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
        for i = 1:length(yticklabel)
            yticklabel{i} = strrep(['$' yticklabel{i} '^{\circ}$'], ',', '{,}');
        end % end for i
    else
        for i = 1:length(yticklabel)
            yticklabel{i} = [yticklabel{i} yunit];
        end % end for i
    end % end if
    set(ax, 'YTickLabel', yticklabel);
elseif replacePenultimate(2)
    yticklabel{end-1} = yunit;
    set(ax, 'YTickLabel', yticklabel);
else
    ytickdistance = ax.Position(4)/(length(get(ax, 'YTick'))-1);
    yl = ylim(ax);
    if strcmp(yscale, 'linear')
        if length(ytick) > 1
            ytickdistance = (ytick(end)-ytick(1))/(length(ytick)-1)/diff(yl)*ax.Position(4);
            ytickend = (yl(2)-ytick(end))/diff(yl)*ax.Position(4);
        else
            ytickdistance = ax.Position(4);
            ytickend = (yl(1)-ytick(end))/diff(yl)*ax.Position(4);
        end % end if
    else
        if length(ytick) > 1
            ytickdistance = log10(ytick(end)/ytick(1))/(length(ytick)-1)/log10(yl(2)/yl(1))*ax.Position(4);
            ytickend = log10(yl(2)/ytick(end))/log10(yl(2)/yl(1))*ax.Position(4);
        else
            ytickdistance = ax.Position(4);
            ytickend = log10(yl(1)/ytick(end))/log10(yl(2)/yl(1))*ax.Position(4);
        end % end if
    end % end if
    ypos = [ax.Position(1), ax.Position(2)+ax.Position(4)-ytickdistance-ytickend, 0, ytickdistance];
    yunitlabel = annotation('textbox', ypos, 'String', yunit, 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end % end if

%% Add arrows
xlabelobj = get(ax, 'XLabel');
set(xlabelobj, 'Units', 'normalized');
xlabelpos(1) = xlabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
xlabelpos(2) = xlabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
xlabelpos(3) = xlabelobj.Extent(3)*ax.Position(3);
xlabelpos(4) = xlabelobj.Extent(4)*ax.Position(4);
xarrowpos(1) = xlabelpos(1) + xlabelpos(3) + 0.02*ax.OuterPosition(3);
xarrowpos(2) = xlabelpos(2)+xlabelpos(4)/2;
xarrowpos(3) = 0.1*ax.OuterPosition(3);
xarrowpos(4) = 0;
xarrow = annotation('arrow', 'Position', xarrowpos, 'HeadLength', 6, 'HeadWidth', 6);

ylabelobj = get(ax, 'YLabel');
set(ylabelobj, 'Units', 'normalized');
ylabelpos(1) = ylabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
ylabelpos(2) = ylabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
ylabelpos(3) = ylabelobj.Extent(3)*ax.Position(3);
ylabelpos(4) = ylabelobj.Extent(4)*ax.Position(4);
yarrowpos(1) = ylabelpos(1) + ylabelpos(3)/2;
yarrowpos(2) = ylabelpos(2) + ylabelpos(4) + 0.02*ax.OuterPosition(4);
yarrowpos(3) = 0;
yarrowpos(4) = 0.1*ax.OuterPosition(4);
yarrow = annotation('arrow', 'Position', yarrowpos, 'HeadLength', 6, 'HeadWidth', 6);

%% Add exponent label
% this is necessary because setting the tick labels manualy removes the
% exponent label and there is no way to bring it back (as far as I know)
if strcmp(xscale, 'linear') && xexp ~= 0
    ax.XAxis.Exponent = xexp;
    xpos = [ax.Position(1)+ax.Position(3), ax.Position(2), 0, 0];
    xstr = ['$\times\,10^{' num2str(xexp) '}$'];
    xexplabel = annotation('textbox', xpos, 'String', xstr, 'Interpreter', 'latex', 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
end % end if

if strcmp(yscale, 'linear') && yexp ~= 0
    ax.YAxis.Exponent = yexp;
    ypos = [ax.Position(1), ax.Position(2)+ax.Position(4), 0, 0];
    ystr = ['$\times\,10^{' num2str(yexp) '}$'];
    yexplabel = annotation('textbox', ypos, 'String', ystr, 'Interpreter', 'latex', 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
end % end if

%% Set resize callback
superOnResize = get(ax.Parent, 'SizeChangedFcn');
set(ax.Parent, 'SizeChangedFcn', @onResize);
    function onResize(hObject, event)
        if(~isempty(superOnResize))
            superOnResize(hObject, event);
        end % end if
        
        % update tick labels
        updateTickLabels();
        
        % update unit label positions
        updateUnitLabelPositions();
        
        % update quantity label and arrow positions
        xlabelpos(1) = xlabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
        xlabelpos(2) = xlabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
        xlabelpos(3) = xlabelobj.Extent(3)*ax.Position(3);
        xlabelpos(4) = xlabelobj.Extent(4)*ax.Position(4);
        xarrowpos(1) = xlabelpos(1) + xlabelpos(3) + 0.02*ax.OuterPosition(3);
        xarrowpos(2) = xlabelpos(2)+xlabelpos(4)/2;
        xarrowpos(3) = 0.1*ax.OuterPosition(3);
        xarrowpos(4) = 0;
        xarrow.Position = xarrowpos;
        
        ylabelpos(1) = ylabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
        ylabelpos(2) = ylabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
        ylabelpos(3) = ylabelobj.Extent(3)*ax.Position(3);
        ylabelpos(4) = ylabelobj.Extent(4)*ax.Position(4);
        yarrowpos(1) = ylabelpos(1) + ylabelpos(3)/2;
        yarrowpos(2) = ylabelpos(2) + ylabelpos(4) + 0.02*ax.OuterPosition(4);
        yarrowpos(3) = 0;
        yarrowpos(4) = 0.1*ax.OuterPosition(4);
        yarrow.Position = yarrowpos;
        
        % update exponent label positions
        if exist('xexplabel', 'var')
            xexplabel.Position = [ax.Position(1)+ax.Position(3), ax.Position(2), 0, 0];
        end % end if
        
        if exist('yexplabel', 'var')
            yexplabel.Position = [ax.Position(1), ax.Position(2)+ax.Position(4), 0, 0];
        end % end if
    end % end function onResize

%% Set zoom callback
zh = zoom(ax.Parent);
superOnZoom = zh.ActionPostCallback;
zh.ActionPostCallback = @onZoom;
    function onZoom(hObject, event)
        if(~isempty(superOnZoom))
            superOnZoom(hObject, event);
        end % end if
        
        % update tick labels
        updateTickLabels();
        
        % update unit label positions
        updateUnitLabelPositions();
    end % end function onZoom

%% Set pan callback
ph = pan(ax.Parent);
superOnPan = ph.ActionPostCallback;
ph.ActionPostCallback = @onPan;
    function onPan(hObject, event)
        if(~isempty(superOnPan))
            superOnPan(hObject, event);
        end % end if
        
        % update tick labels
        updateTickLabels();
        
        % update unit label positions
        updateUnitLabelPositions();
    end % end function onPan

%% Update functions
    function updateTickLabels()
        xtick = get(ax, 'XTick');
        xticklabel = cell(length(xtick), 1);
        for j = 1:length(xtick)
            if strcmp(xscale, 'linear') || sum(mod(log10(xtick), 1))
                xticklabel{j} = strrep(num2str(xtick(j)/10^xexp), '.', ',');
            else
                xticklabel{j} = ['10^{' num2str(log10(xtick(j))) '}'];
                if strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
                    xticklabel{j} = ['$' xticklabel{j} '$'];
                end % end if
            end % end if
        end % end for j
        if (strcmp(xunit, '°') || strcmp(xunit, '''') || strcmp(xunit, '''''')) && strcmp(xscale, 'linear')
            if strcmp(xunit, '°') && strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
                for j = 1:length(xticklabel)
                    xticklabel{j} = strrep(['$' xticklabel{j} '^{\circ}$'], ',', '{,}');
                end % end for j
            else
                for j = 1:length(xticklabel)
                    xticklabel{j} = [xticklabel{j} xunit];
                end % end for j
            end % end if
        elseif replacePenultimate(1)
            xticklabel{end-1} = xunit;
        end % end if
        set(ax, 'XTickLabel', xticklabel);
        
        ytick = get(ax, 'YTick');
        yticklabel = cell(length(ytick), 1);
        for j = 1:length(ytick)
            if strcmp(yscale, 'linear')  || sum(mod(log10(ytick), 1))
                yticklabel{j} = strrep(num2str(ytick(j)/10^yexp), '.', ',');
            else
                yticklabel{j} = ['10^{' num2str(log10(ytick(j))) '}'];
                if strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
                    yticklabel{j} = ['$' yticklabel{j} '$'];
                end % end if
            end % end if
        end % end for j
        if (strcmp(yunit, '°') || strcmp(yunit, '''') || strcmp(yunit, '''''')) && strcmp(yscale, 'linear')
            if strcmp(yunit, '°') && strcmp(get(ax, 'TickLabelInterpreter'), 'latex')
                for j = 1:length(yticklabel)
                    yticklabel{j} = strrep(['$' yticklabel{j} '^{\circ}$'], ',', '{,}');
                end % end for j
            else
                for j = 1:length(yticklabel)
                    yticklabel{j} = [yticklabel{j} yunit];
                end % end for j
            end % end if
        elseif replacePenultimate(2)
            yticklabel{end-1} = yunit;
        end % end if
        set(ax, 'YTickLabel', yticklabel);
    end % end function updateTickLabels

    function updateUnitLabelPositions()
        if exist('xunitlabel', 'var')
            xtick = get(ax, 'XTick');
            xl = xlim(ax);
            if strcmp(xscale, 'linear')
                if length(xtick) > 1
                    xtickdistance = (xtick(end)-xtick(1))/(length(xtick)-1)/diff(xl)*ax.Position(3);
                    xtickend = (xl(2)-xtick(end))/diff(xl)*ax.Position(3);
                else
                    xtickdistance = ax.Position(3);
                    xtickend = (xl(1)-xtick(end))/diff(xl)*ax.Position(3);
                end % end if
            else
                if length(xtick) > 1
                    xtickdistance = log10(xtick(end)/xtick(1))/(length(xtick)-1)/log10(xl(2)/xl(1))*ax.Position(3);
                    xtickend = log10(xl(2)/xtick(end))/log10(xl(2)/xl(1))*ax.Position(3);
                else
                    xtickdistance = ax.Position(3);
                    xtickend = log10(xl(1)/xtick(end))/log10(xl(2)/xl(1))*ax.Position(3);
                end % end if
            end % end if
            xpos = [ax.Position(1)+ax.Position(3)-xtickdistance-xtickend, ax.Position(2), xtickdistance, 0];
            delete(xunitlabel);
            xunitlabel = annotation('textbox', xpos, 'String', xunit, 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
        end % end if
        
        if exist('yunitlabel', 'var')
            ytick = get(ax, 'YTick');
            yl = ylim(ax);
            if strcmp(yscale, 'linear')
                if length(ytick) > 1
                    ytickdistance = (ytick(end)-ytick(1))/(length(ytick)-1)/diff(yl)*ax.Position(4);
                    ytickend = (yl(2)-ytick(end))/diff(yl)*ax.Position(4);
                else
                    ytickdistance = ax.Position(4);
                    ytickend = (yl(1)-ytick(end))/diff(yl)*ax.Position(4);
                end % end if
            else
                if length(ytick) > 1
                    ytickdistance = log10(ytick(end)/ytick(1))/(length(ytick)-1)/log10(yl(2)/yl(1))*ax.Position(4);
                    ytickend = log10(yl(2)/ytick(end))/log10(yl(2)/yl(1))*ax.Position(4);
                else
                    ytickdistance = ax.Position(4);
                    ytickend = log10(yl(1)/ytick(end))/log10(yl(2)/yl(1))*ax.Position(4);
                end % end if
            end % end if
            ypos = [ax.Position(1), ax.Position(2)+ax.Position(4)-ytickdistance-ytickend, 0, ytickdistance];
            delete(yunitlabel);
            yunitlabel = annotation('textbox', ypos, 'String', yunit, 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
        end % end if
    end % end function updateUnitLabelsPositions

end % end function din461