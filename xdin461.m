function [] = xdin461(varargin)
% XDIN461  DIN 461 style for x-axis of 2D plots
%   XDIN461(xquantity, xunit) applies DIN 461 style to
%   current x-axis.
%   
%   XDIN461(ax, ___) applies DIN 461 style to x-axis of axes ax.
%   
%   XDIN461(___, 'replacePenultimate', replacePenultimate) specifies
%   whether the unit label replaces the penultimate number or is
%   placed between the last and penultimate number.
%   * Default is 0.
%   
%   See also DIN461, YDIN461, FIGURE, PLOT, SUBAXES, XLABEL, YLABEL, 
%   ANNOTATION, SET_DEFAULT_PLOT_PROPERTIES
%
%   Copyright (c) 2018 Oliver Kiethe
%   This file is licensed under the MIT license.

%% Input arguments
p = inputParser;
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    addRequired(p, 'ax', @(x) isa(x, 'matlab.graphics.axis.Axes'));
end % end if
addRequired(p, 'xquantity', @ischar);
addRequired(p, 'xunit', @ischar);
addParameter(p, 'replacePenultimate', 0, @(x) (islogical(x) || isnumeric(x)) && isscalar(x));

parse(p, varargin{:});
if isa(varargin{1}, 'matlab.graphics.axis.Axes')
    ax = p.Results.ax;
else
    ax = gca;
end % end if
xquantity = p.Results.xquantity;
xunit = p.Results.xunit;
replacePenultimate = p.Results.replacePenultimate;

%% Add quantity label
xlabel(ax, xquantity);

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

%% Replace decimal points with comma
xticklabel = strrep(xticklabel, '.', ',');
set(ax, 'XTickLabel', xticklabel);

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
elseif replacePenultimate
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

%% Add arrow
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

%% Add exponent label
% this is necessary because setting the tick labels manualy removes the
% exponent label and there is no way to bring it back (as far as I know)
if strcmp(xscale, 'linear') && xexp ~= 0
    ax.XAxis.Exponent = xexp;
    xpos = [ax.Position(1)+ax.Position(3), ax.Position(2), 0, 0];
    xstr = ['$\times\,10^{' num2str(xexp) '}$'];
    xexplabel = annotation('textbox', xpos, 'String', xstr, 'Interpreter', 'latex', 'FitBoxToText', 'on', 'BackgroundColor', 'none', 'LineStyle', 'none', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
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
        xlabelpos(1) = xlabelobj.Extent(1)*ax.Position(3)+ax.Position(1);
        xlabelpos(2) = xlabelobj.Extent(2)*ax.Position(4)+ax.Position(2);
        xlabelpos(3) = xlabelobj.Extent(3)*ax.Position(3);
        xlabelpos(4) = xlabelobj.Extent(4)*ax.Position(4);
        xarrowpos(1) = xlabelpos(1) + xlabelpos(3) + 0.02*ax.OuterPosition(3);
        xarrowpos(2) = xlabelpos(2)+xlabelpos(4)/2;
        xarrowpos(3) = 0.1*ax.OuterPosition(3);
        xarrowpos(4) = 0;
        xarrow.Position = xarrowpos;
        
        % update exponent label position
        if exist('xexplabel', 'var')
            xexplabel.Position = [ax.Position(1)+ax.Position(3), ax.Position(2), 0, 0];
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
        elseif replacePenultimate
            xticklabel{end-1} = xunit;
        end % end if
        set(ax, 'XTickLabel', xticklabel);
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
    end % end function updateUnitLabelsPositions

end % end function xdin461