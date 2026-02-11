function cellArrayOfPlotHandles = fcn_PlotTire_plotTireXY(cellArrayOfPoints, varargin)
%fcn_PlotTire_plotTireXY - plots the tire's XY coordinate view
% FORMAT:
%
%      cellArrayOfPlotHandles = fcn_PlotTire_plotTireXY(cellArrayOfPoints, (figNum));
%
% INPUTS:
%
%      cellArrayOfPoints - a cell array containing layers of points, with
%      additional complexity depending on the method used
%
%      (OPTIONAL INPUTS)
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      cellArrayOfPlotHandles - a cell array of figure handles, one for each
%      cellArrayOfPoints being plotted
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PlotTire_plotTireXY
%     for a full test suite.
%
% This function was written on 2026_02_10 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_02_10 by Sean Brennan, sbrennan@psu.edu
% - In cellArrayOfPoints
%   % * Wrote function

% TO-DO:
%
% 2026_02_10 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 2; % The largest Number of argument inputs to the function
flag_max_speed = 0; % The default. This runs code with all error checking
if (nargin==MAX_NARGIN && isequal(varargin{end},-1))
	flag_do_debug = 0; % Flag to plot the results for debugging
	flag_check_inputs = 0; % Flag to perform input checking
	flag_max_speed = 1;
else
	% Check to see if we are externally setting debug mode to be "on"
	flag_do_debug = 0; % Flag to plot the results for debugging
	flag_check_inputs = 1; % Flag to perform input checking
	MATLABFLAG_PLOTTIRE_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTTIRE_FLAG_CHECK_INPUTS");
	MATLABFLAG_PLOTTIRE_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTTIRE_FLAG_DO_DEBUG");
	if ~isempty(MATLABFLAG_PLOTTIRE_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTTIRE_FLAG_DO_DEBUG)
		flag_do_debug = str2double(MATLABFLAG_PLOTTIRE_FLAG_DO_DEBUG);
		flag_check_inputs  = str2double(MATLABFLAG_PLOTTIRE_FLAG_CHECK_INPUTS);
	end
end

% flag_do_debug = 1;

if flag_do_debug % If debugging is on, print on entry/exit to the function
	st = dbstack; %#ok<*UNRCH>
	fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
	debug_figNum = 999978; %#ok<NASGU>
else
	debug_figNum = []; %#ok<NASGU>
end

%% check input arguments?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0==flag_max_speed
	if flag_check_inputs
		% Are there the right number of inputs?
		narginchk(MAX_NARGIN-1,MAX_NARGIN);

	end
end

% % Does the user want to specify the displayModel?
% % Set defaults first:
% displayModel = 1; % Default case
% 
% % Check for user input
% if 2 <= nargin
%     temp = varargin{1};
%     if ~isempty(temp)
% 		displayModel = temp;        
%     end
% end

% % Does the user want to specify excursion_definition?
% flag_use_excursion_definition = 0; % Default case
% flag_excursion_is_a_point_type = 1; % Default case
% if 4 <= nargin
%     temp = varargin{2};
%     if ~isempty(temp)
%         % Set the excursion values
%         [flag_excursion_is_a_point_type, excursion_definition] = fcn_Laps_checkZoneType(temp, 'excursion_definition',-1);
%         flag_use_excursion_definition = 1;
%     end
% end

% Does user want to show the plots?
flag_do_plots = 1; % Default is to show plots
figNum = [];
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
	temp = varargin{end};
	if ~isempty(temp) % Did the user NOT give an empty figure number?
		figNum = temp; 
		flag_do_plots = 1;
	end
end

if isempty(figNum)
	temp = figure;
	figNum = get(temp,'Number');
end


%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialize output
Nmodels = size(cellArrayOfPoints,1);
cellArrayOfPlotHandles = cell(Nmodels,1);

%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plots

	outer_diameter = max(cellArrayOfPoints{1,1}(:,2)) - min(cellArrayOfPoints{1,1}(:,2));
	outer_r = outer_diameter/2; %#ok<NASGU>
	
	% Create figure
	h_fig = figure(figNum);
	set(h_fig,'Name','Tire Top View','Color','w');

	for ith_plot = 1:Nmodels
		% subplot(1,Ncolumns,ith_plot)
		axis equal; hold on; box on;
		xlabel('meters'); ylabel('meters');


		XYpoints = cellArrayOfPoints{ith_plot,1};
		
		% If data is not there, plot nan values so that plot handle is
		% populated anyway
		if isempty(XYpoints)
			XYpoints = [nan nan];
		end

		if ith_plot ==1
			% Ensure closed polygon
			if ~isequal(XYpoints(1,:), XYpoints(end,:))
				XYpointsPlotted = [XYpoints; XYpoints(1,:)];
			else
				XYpointsPlotted = XYpoints;
			end
			cellArrayOfPlotHandles{1} = plot(XYpointsPlotted(:,1),XYpointsPlotted(:,2),'-','Color',0.8*[1 1 1],'LineWidth',2,'DisplayName','Bounding box');
		elseif ith_plot == 2
			% Draw outer tire and rim
			cellArrayOfPlotHandles{2} = patch('XData', XYpoints(:,1), 'YData', XYpoints(:,2), ...
				'FaceColor',0.4*[1 1 1], 'EdgeColor', 0.2*[1 1 1],'FaceAlpha',0.8, 'DisplayName','Tire profile'); % tire rubber
		elseif ith_plot == 3
			% Draw tread
			cellArrayOfPlotHandles{3} = plot(XYpoints(:,1),XYpoints(:,2),'-','Color',0.1*[1 1 1],'LineWidth',2,'DisplayName','Tread');
		end

		% % Limits and styling
		% pad = outer_r*0.15;
		% xlim([-outer_r-pad, outer_r+pad]);
		% ylim([-outer_r-pad, outer_r+pad]);
		% set(gca,'FontSize',11);

		hold off;
	end
end

if flag_do_debug
	fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

