function Draw(DirName, varargin)
%
% ������� ���������� ������ ����������� ������� � �������� ������
	close all
    % ����������, �� ������� ����� ����� ����������
        if nargin == 0
            DirName = 'Results';
		end
		path = ['out/' DirName];
		
		drawIdealFER = true;
		tmp = strcmpi(varargin,'drawIdealFER'); 
		if any(tmp)
			drawIdealFER = varargin{find(tmp)+1}; 
			tmp(find(tmp)+1)=1; 
			varargin = varargin(~tmp); 
		end
		
		plotHPercent = 0.90;
		plotWPercent = 0.95;
		figSizePercent = 0.9;
		tmp = strcmpi(varargin,'figSizePercent'); 
		if any(tmp)
			figSizePercent = varargin{find(tmp)+1}; 
		end
    % ������� ���������� � ���������� ����������
	    Listing = dir(path);
    % �������������� cell-������ ��� �������� ��� ������, �� ������� �����
    % ������� �������
        Names = cell(0);

    % ���� �� ���� ������ ����������
        for k = 1:length(Listing)
            % ���� ���������, ����� ��������������� ������� ��� ������ �
            % ���� ���������� mat
                if ~Listing(k).isdir
                    FName = Listing(k).name;
                    if length(FName) > 4
                        if isequal(FName(end-3:end), '.mat')
                            % ������� ��� ����� � ������
                                Names{end+1} = FName(1:end-4); %#ok<AGROW>
                        end
                    end
                end
        end

        if isempty(Names)
            error('�� ������� ����� � ������������!');
        end

    % ���������� BER � FER
        % �������� ��� ������� � ���
            f  = cell(2, 1);
            ax = cell(2, 1);
            for k = 1:2
                f{k} = figure;
				ax{k} = axes;
			end;
			fprintf('PROB\tNAME\t\t\t\t\t\tSNR\n')
        % ���� �� ���� ��� ��������� ������
			angle = 360;
            for k = 1:length(Names)
                % �������� �����������
                    load([path, '\', Names{k}, '.mat'], 'Res');
					
                % ���������� ��� ��������� ������ ��������    
                    figure(f{1});
					    hold on;
						set(gcf,'color','w');
						
						set(gcf, 'Units', 'Normalized', 'OuterPosition',...
							[(1-figSizePercent)/2 (1-figSizePercent)/2 ...
							figSizePercent figSizePercent]);
						
						h = plot(Res.h2dBs, Res.NumErBits ./ Res.NumTrBits, ...
                            'LineWidth', 1, 'MarkerSize', 8, ...
                            'Marker', '.');
						PlotLabel(h,['   ' Names{k} '   '],...
							'location','random', 'xIndex',...
							k/length(Names) *length(Res.h2dBs) );
						angle = angle - 25;
					%Getting info for SNR AT 10e-4
					xdata = get(h,'XData'); 
					ydata = get(h,'YData'); 
					for q = 1 : length(xdata)-1
						if (ydata(q) > 10e-4 && ydata(q+1) < 10e-4)
							y1 = ydata(q);
							y2 = ydata(q+1);
							x1 = xdata(q);
							x2 = xdata(q+1);
							b = (10e-4 -y1)*(x2-x1)/(y2-y1) + x1;
							fprintf('10^-4\t%s\t\t% .3f\n', Names{k},b)
						end;
					end
						
                    figure(f{2});
                        hold on;
						set(gcf,'color','w');
						set(gcf, 'Units', 'Normalized', 'OuterPosition',...
							[(1-figSizePercent)/2 (1-figSizePercent)/2 ...
							figSizePercent figSizePercent]);
                        h = plot(Res.h2dBs, Res.NumErFrames ./ ...
                            Res.NumTrFrames, 'LineWidth', 1, ...
                            'MarkerSize', 8, 'Marker', '.');
						PlotLabel(h,['   ' Names{k} '   '],...
							'location','random', 'xIndex',...
							k/length(Names) *length(Res.h2dBs) );
            end
			
        for k = 1:2
            figure(f{k});

            % ������� �����
                grid on;
           		
            % �������� ������� � ��� �������
                if k == 1
                    title('BER');
                else
                    title('FER');
                end
                xlabel('{\ith}^2 (dB)');

            % ���������� ����������� BER
            % � ������ ������ ��� QAM4 � QAM16 �� ����������� 1e-6
			xbounds = xlim;
			if(drawIdealFER)
                
				if k == 1
                    AddNames = cell(0);
                    h2dB = xbounds(1):0.1:10.5;
                    BER = berawgn(h2dB, 'qam', 4);
                    h = plot(h2dB, BER);
                    AddNames{end+1} = 'QPSK'; %#ok<AGROW>
					PlotLabel(h,'QPSK','location','right')
                    h2dB = xbounds(1):0.1:14.4;
                    BER = berawgn(h2dB, 'qam', 16);
                    h = plot(h2dB, BER);
                    AddNames{end+1} = '16-QAM'; %#ok<AGROW>
					PlotLabel(h,'16-QAM','location','right')
				end;
			end
			 % ������� ������������ ������� �� ��� �������
				set(ax{k},'YScale', 'log');
%                 set(ax{k},'XTick',xbounds(1):xbounds(2), 'YScale', 'log');
				set(ax{k},'Position',[(1-plotWPercent)/2 ...
							(1-plotHPercent)/2 ...
							plotWPercent plotHPercent]);
				
            % ������� �������
                if k == 1 && drawIdealFER
                    legend([Names, AddNames], 'Interpreter', 'none');
                else
                    legend(Names, 'Interpreter', 'none');
				end;
				
			% save to image
				if k == 1
                    saveas(gcf,[path '-BER'],'png');
					saveas(gcf,[path '-BER'],'svg');
                else
                    saveas(gcf,[path '-FER'],'png');
					saveas(gcf,[path '-FER'],'svg');
				end;
			
		end;
end
function [htext] = PlotLabel(h,textString,varargin)
%LABEL places a label next to your data.  
% 
% This function provides an option between the legend and text or annotation commands
% for labeling data that you plot.  Edward Tufte
% says that data shouldn't stray far from its label, because
% the viewer of a graph should not need to repeatedly move his or her eyes
% back and forth between plotted data and the legend to connect the dots of
% which data are which.  In this spirit, label can be used to place a
% label directly on a plot close to the data it describes.  
%
%% Syntax 
% 
%  label(h,'string')
%  label(...,'location',LocationString)
%  label(...,'TextProperty',PropertyValue)
%  label(...,'slope')
%  h = label(...)
%
%% Description 
% 
% label(h,'string') places 'string' near the leftmost data described by
% handle h. 
%
% label(...,'location',LocationString) specifies location of the string.
% LocationString can be any of the following:
% 
% * 'left' or 'west' (default) 
% * 'right' or 'east' 
% * 'top' or 'north' 
% * 'bottom' or 'south' 
% * 'center' or 'middle' 
% 
% label(...,'TextProperty',PropertyValue) specifies text properties as
% name-value pairs. 
%
% label(...,'slope') attempts to angle text following the local slope of
% the data. 
%
% htext = label(...) returns the handle htext of the newly-created text
% object. 
% 
%% Initial input error checks: 

assert(ishandle(h)==1,'Unrecognized object handle.')
assert(isempty(get(0,'children'))==0,'No current axes are open.') 
assert(isnumeric(textString)==0,'Label given by textString must be a string.') 
assert(nargin>=2,'Must input an object handle and corresponding label string.') 

%% Set defaults: 

location = 'left'; 
followSlope = false; 

color = get(h,'color'); 
xdata = get(h,'XData'); 
assert(isvector(xdata)==1,'Plotted data must be vector or scalar.') 
ydata = get(h,'YData'); 

gcax = get(gca,'xlim'); 
gcay = get(gca,'ylim'); 
%% Parse inputs

tmp = strncmpi(varargin,'loc',3); 
if any(tmp)
    location = varargin{find(tmp)+1}; 
    tmp(find(tmp)+1)=1; 
    varargin = varargin(~tmp); 
end
%% 
global lastAngle
angle = lastAngle - 25;
angle = 360 - mod(angle,180);
tmp = strncmpi(varargin,'angle',3); 
if any(tmp)
    angle = (varargin{find(tmp)+1});
    tmp(find(tmp)+1)=1; 
    varargin = varargin(~tmp); 
end

xIndex = randi(length(xdata), 1);
tmp = strncmpi(varargin,'xIndex',3); 
if any(tmp)
    xIndex = int8(varargin{find(tmp)+1});
    tmp(find(tmp)+1)=1; 
    varargin = varargin(~tmp); 
end
tmp = strcmpi(varargin,'slope'); 
if any(tmp) 
    followSlope = true; 
    varargin = varargin(~tmp); 
end




if followSlope
    pbp = kearneyplotboxpos(gca); % A modified version of Kelly Kearney's plotboxpos function is included as a subfunction below.  

    % slope is scaled because of axes and plot box may not be equal and square:
    gcaf = pbp(4)/pbp(3); 
    apparentTheta = atand(gcaf*gradient(ydata,xdata).*(gcax(2)-gcax(1))/(gcay(2)-gcay(1)));

end

% Find indices of data within figure window: 
ind = find(xdata>=gcax(1)&xdata<=gcax(2)&ydata>=gcay(1)&ydata<=gcay(2)); 

switch lower(location)
    case {'left','west','leftmost','westmost'}
        horizontalAlignment = 'left'; 
        verticalAlignment = 'bottom'; 
        x = min(xdata(ind));
        y = ydata(xdata==x);
        textString = [' ',textString]; 
        xi = xdata==x; 
        
    case {'right','east','rightmost','eastmost'}
        horizontalAlignment = 'right'; 
        verticalAlignment = 'bottom'; 
        x = max(xdata(ind)); 
        y = ydata(xdata==x);
        textString = [textString,' ']; 
        xi = xdata==x(1); 
        
    case {'top','north','topmost','northmost'}
        horizontalAlignment = 'left'; 
        verticalAlignment = 'top'; 
        y = max(ydata(ind));
        x = xdata(ydata==y);
        xi = xdata==x(1); 
        
    case {'bottom','south','southmost','bottommost'} 
        horizontalAlignment = 'left'; 
        verticalAlignment = 'bottom'; 
        y = min(ydata(ind));
        x = xdata(ydata==y);
        xi = xdata==x(1); 
        
    case {'center','central','middle','centered','middlemost','centermost'}
        horizontalAlignment = 'center'; 
        verticalAlignment = 'bottom'; 
        xi = round(mean(ind)); 
        if ~ismember(xi,ind)
            xi = find(ind<xi,1,'last'); 
        end
        x = xdata(xi); 
        y = ydata(xi);
    case {'random'}
		horizontalAlignment = 'left'; 
        verticalAlignment = 'bottom'; 
		
		xi = xIndex;
		x = xdata(xIndex); 
		y = ydata(xIndex);
		
		if(xIndex > int8(length(xdata)*0.7))
			horizontalAlignment = 'right'; 
		end;
		if(y > max(ydata)*0.999)
			verticalAlignment = 'top'; 
		end;
	otherwise
		error('Unrecognized location string.') 
end
 
% Set rotation preferences: 
if followSlope
    theta = apparentTheta(xi); 
else
    theta = 0; 
end
 htext = text(x,y,textString,'color',color,'horizontalalignment',horizontalAlignment,...
     'verticalalignment',verticalAlignment,'rotation',theta); 
% annotation('textarrow',[x(1) xSide],[y(1) ySide], 'Units','data','String',textString)
% Add any user-defined preferences: 
if length(varargin)>1 
    set(htext,varargin{:});
end


% Clean up: 
if nargout == 0
    clear htext
end

end


function pos = kearneyplotboxpos(h)
%PLOTBOXPOS Returns the position of the plotted axis region. THIS IS A
%SLIGHTLY MODIFIED VERSION OF KELLY KEARNEY'S PLOTBOXPOS FUNCTION. 
%
% pos = plotboxpos(h)
%
% This function returns the position of the plotted region of an axis,
% which may differ from the actual axis position, depending on the axis
% limits, data aspect ratio, and plot box aspect ratio.  The position is
% returned in the same units as the those used to define the axis itself.
% This function can only be used for a 2D plot.  
%
% Input variables:
%
%   h:      axis handle of a 2D axis (if ommitted, current axis is used).
%
% Output variables:
%
%   pos:    four-element position vector, in same units as h

% Copyright 2010 Kelly Kearney

% Check input

if nargin < 1
    h = gca;
end

if ~ishandle(h) || ~strcmp(get(h,'type'), 'axes')
    error('Input must be an axis handle');
end

% Get position of axis in pixels

currunit = get(h, 'units');
set(h, 'units', 'pixels');
axisPos = get(h, 'Position');
set(h, 'Units', currunit);

% Calculate box position based axis limits and aspect ratios

darismanual  = strcmpi(get(h, 'DataAspectRatioMode'),    'manual');
pbarismanual = strcmpi(get(h, 'PlotBoxAspectRatioMode'), 'manual');

if ~darismanual && ~pbarismanual
    
    pos = axisPos;
    
else

    dx = diff(get(h, 'XLim'));
    dy = diff(get(h, 'YLim'));
    dar = get(h, 'DataAspectRatio');
    pbar = get(h, 'PlotBoxAspectRatio');

    limDarRatio = (dx/dar(1))/(dy/dar(2));
    pbarRatio = pbar(1)/pbar(2);
    axisRatio = axisPos(3)/axisPos(4);

    if darismanual
        if limDarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/limDarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * limDarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    elseif pbarismanual
        if pbarRatio > axisRatio
            pos(1) = axisPos(1);
            pos(3) = axisPos(3);
            pos(4) = axisPos(3)/pbarRatio;
            pos(2) = (axisPos(4) - pos(4))/2 + axisPos(2);
        else
            pos(2) = axisPos(2);
            pos(4) = axisPos(4);
            pos(3) = axisPos(4) * pbarRatio;
            pos(1) = (axisPos(3) - pos(3))/2 + axisPos(1);
        end
    end
end

% Convert plot box position to the units used by the axis

temp = axes('Units', 'Pixels', 'Position', pos, 'Visible', 'off', 'parent', get(h, 'parent'));
% set(temp, 'Units', currunit); % <-This line commented-out by Chad Greene, specifically for label function.  
pos = get(temp, 'position');
delete(temp);
end
	
