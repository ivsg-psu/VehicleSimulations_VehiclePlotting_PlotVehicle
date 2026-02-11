function fcn_PlotTire_plotTireDimensions(tireParameters, varargin)
%fcn_PlotTire_plotTireDimensions - Plots tire dimensions with labeling
% FORMAT:
%
%      tireParameters = fcn_PlotTire_plotTireDimensions(tireCodeCharacters, (figNum));
%
% INPUTS:
%
%      tireCodeCharacters - a character array or string containing a tire's
%      sidewall specification, for example: '205/55R16', 'P225/50R17 94H',
%      'LT265/70R17 121/118R'
%
%      (OPTIONAL INPUTS)
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      tireParameters - a structure containing key measurements of the tire
%      as specified by the tireCodeCharacters. Key fields include:
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PlotTire_plotTireDimensions
%     for a full test suite.
%
% This function was written on 2026_02_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotTire_plotTireDimensions
%   % * Wrote the code originally, using fcn_Laps_break+DataIntoLapIndices
%   %   % as starter

% TO-DO:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
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

		% Validate tireParameters that it is characters or string
		% fcn_DebugTools_checkInputsToFunctions(tireParameters, '_of_char_strings');
		% Required fields check (minimal)
		reqFields = ["sectionWidth_m","sidewallHeight_m","rimDiameter_m","overallDiameter_m"];
		for fth_field = reqFields
			if ~isfield(tireParameters, fth_field)
				error('Missing field %s in input struct.', fth_field);
			end
		end
	end
end


%
% % Set the start values
% [flag_start_is_a_point_type, start_zone_definition] = fcn_Laps_checkZoneType(start_zone_definition, 'start_definition', -1);
%
%
% % The following area checks for variable argument inputs (varargin)
%
% % Does the user want to specify the end_definition?
% % Set defaults first:
% end_zone_definition = start_zone_definition; % Default case
% flag_end_is_a_point_type = flag_start_is_a_point_type; % Inheret the start case
% % Check for user input
% if 3 <= nargin
%     temp = varargin{1};
%     if ~isempty(temp)
%         % Set the end values
%         [flag_end_is_a_point_type, end_zone_definition] = fcn_Laps_checkZoneType(temp, 'end_definition', -1);
%     end
% end
%
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

% Geometry (meters)
rim_d = tireParameters.rimDiameter_m;
outer_d = tireParameters.overallDiameter_m;
side_h = tireParameters.sidewallHeight_m;
section_w = tireParameters.sectionWidth_m; % nominal tread width

% Coordinates for circles (center at origin)
theta = linspace(0,2*pi,360);
rim_r = rim_d/2;
outer_r = outer_d/2;
x_rim = rim_r * cos(theta);
y_rim = rim_r * sin(theta);
x_outer = outer_r * cos(theta);
y_outer = outer_r * sin(theta);

% Mark sidewall height (from rim edge to outer surface)
% use radial line at 60 degrees for visibility
ang = pi/3;
xr_in = rim_r * cos(ang);
yr_in = rim_r * sin(ang);
xr_out = outer_r * cos(ang);
yr_out = outer_r * sin(ang);
plot([xr_in xr_out],[yr_in yr_out],'r-','LineWidth',2);
mid_x = (xr_in+xr_out)/2; mid_y = (yr_in+yr_out)/2;


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


	% Create figure
	h_fig = figure(figNum);
	set(h_fig,'Name','Tire Cross-Section','Color','w');
	axis equal; hold on; box on;
	xlabel('meters'); ylabel('meters');



	% Draw outer tire and rim
	patch(x_outer, y_outer, [0.9 0.9 0.9], 'EdgeColor', [0.2 0.2 0.2]); % tire rubber
	plot(x_rim, y_rim, 'k-', 'LineWidth', 2);                           % rim

	% Draw section width line at top (approx flat tread)
	tread_half = min(section_w/2, outer_r*0.95);
	plot([-tread_half, tread_half], [outer_r, outer_r], 'k-', 'LineWidth', 3);

	% Draw centerline and radial lines to show sidewall
	plot([0, 0], [-outer_r*1.1, outer_r*1.1], ':', 'Color', [0.5 0.5 0.5]);

	% Annotations
	text(xr_out*1.05, yr_out*1.05, sprintf('Overall Ø = %.3f m', outer_d), 'Color','k');
	text(0.02, -outer_r*1.02, sprintf('Rim Ø = %.3f m (%.1f in)', rim_d, tireParameters.rimDiameter_in), 'Color','k');
	text(mid_x*1.05, mid_y*1.05, sprintf('Sidewall = %.3f m', side_h), 'Color','r');

	% Circumference and radius annotations
	text(-outer_r*0.98, outer_r*0.2, sprintf('Radius = %.3f m', outer_r/1), 'Color','b');
	text(-outer_r*0.98, outer_r*0.1, sprintf('Circumf. = %.3f m', tireParameters.circumference_m), 'Color','b');

	% Limits and styling
	pad = outer_r*0.15;
	xlim([-outer_r-pad, outer_r+pad]);
	ylim([-outer_r-pad, outer_r+pad]);
	title(sprintf('Tire: %s', string(tireParameters.rawInput)));
	set(gca,'FontSize',11);

	hold off;
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

