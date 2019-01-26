function [] = ydin461(varargin)
% YDIN461  DIN 461 style for y-axis of 2D plots
%   YDIN461(yquantity, yunit) applies DIN 461 style to
%   current y-axis.
%   
%   YDIN461(ax, ___) applies DIN 461 style to y-axis of axes ax.
%   
%   YDIN461(___, 'replacePenultimate', replacePenultimate) specifies
%   whether the unit label replaces the penultimate number or is
%   placed between the last and penultimate number.
%   * Default is 0.
%   
%   DIN461(___, 'verticalYLabel', verticalYLabel) specifies whether the
%   ylabel is vertical or horizontal.
%   * Default is 0.
%   
%   See also DIN461, XDIN461, FIGURE, PLOT, SUBAXES, XLABEL, YLABEL, 
%   ANNOTATION, SET_DEFAULT_PLOT_PROPERTIES
%
%   Copyright (c) 2018 Oliver Kiethe
%   This file is licensed under the MIT license.

%% Input arguments
p = inputParser;
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    addRequired(p, 'ax', @(x) isa(x, 'matlab.graphics.axis.Axes'));
end % end if
addRequired(p, 'yquantity', @ischar);
addRequired(p, 'yunit', @ischar);
addParameter(p, 'replacePenultimate', 0, @(x) (islogical(x) || isnumeric(x)) && isscalar(x));
addParameter(p, 'verticalYLabel', 0, @(x) (islogical(x) || isnumeric(x)) && isscalar(x));

parse(p, varargin{:});
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = p.Results.ax;
else
    ax = gca;
end % end if
yquantity = p.Results.yquantity;
yunit = p.Results.yunit;
replacePenultimate = p.Results.replacePenultimate;
verticalYLabel = p.Results.verticalYLabel;

%% Add quantity label
if verticalYLabel
    ylabel(ax, yquantity, 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
else
    ylabel(ax, yquantity, 'Rotation', 0, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end % end if

%% Get exponent
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
yticklabel = strrep(yticklabel, '.', ',');
set(ax, 'YTickLabel', yticklabel);

%% Add unit label
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
elseif replacePenultimate
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

%% Add arrow
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
        
        % update unit label position
        updateUnitLabelPositions();
        
        % update quantity label and arrow position
        ylabelpos(1) = ylabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
        ylabelpos(2) = ylabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
        ylabelpos(3) = ylabelobj.Extent(3)*ax.Position(3);
        ylabelpos(4) = ylabelobj.Extent(4)*ax.Position(4);
        yarrowpos(1) = ylabelpos(1) + ylabelpos(3)/2;
        yarrowpos(2) = ylabelpos(2) + ylabelpos(4) + 0.02*ax.OuterPosition(4);
        yarrowpos(3) = 0;
        yarrowpos(4) = 0.1*ax.OuterPosition(4);
        yarrow.Position = yarrowpos;
        
        % update exponent label position
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
        
        % update unit label position
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
        
        % update unit label position
        updateUnitLabelPositions();
    end % end function onPan

%% Update functions
    function updateTickLabels()
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
        elseif replacePenultimate
            yticklabel{end-1} = yunit;
        end % end if
        set(ax, 'YTickLabel', yticklabel);
    end % end function updateTickLabels

    function updateUnitLabelPositions()
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

end % end function ydin461