function vehicleParameters = fcn_PlotVehicle_fillParametersFromName(vehicleNameString, varargin)
%fcn_PlotVehicle_fillParametersFromName - Parses tire sidewall characters into
%dimensions (SI)
%
% FORMAT:
%
%      vehicleParameters = fcn_PlotVehicle_fillParametersFromName(vehicleNameString, (figNum));
%
% INPUTS:
%
%      vehicleNameString - a character array or string containing a tire's
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
%      vehicleParameters - a structure containing key measurements of the tire
%      as specified by the vehicleNameString. Key fields include:
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PlotVehicle_fillParametersFromName
%     for a full test suite.
%
% This function was written on 2026_02_13 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_02_13 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotVehicle_fillParametersFromName
%   % * Wrote the code originally, using fcn_Plot+Tire_parseTireSidewallCode
%   %   % as starter

% TO-DO:
%
% 2026_02_13 by Sean Brennan, sbrennan@psu.edu
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

        % Validate vehicleNameString that it is characters or string
		fcn_DebugTools_checkInputsToFunctions(vehicleNameString, '_of_char_strings');
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
flag_do_plots = 0; % Default is to NOT show plots
if (0==flag_max_speed) && (MAX_NARGIN == nargin) 
    temp = varargin{end};
    if ~isempty(temp) % Did the user NOT give an empty figure number?
        figNum = temp; %#ok<NASGU>
        flag_do_plots = 1;
    end
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

% Trim leading and trailing spaces off the code string
vehicleNameString = strtrim(string(vehicleNameString));

% Save result
vehicleParameters.rawInput = vehicleNameString;

% Initialize outputs
vehicleParameters.wheelbase_m = NaN;
vehicleParameters.track_m = NaN;
vehicleParameters.frontBumperXoffset_m = NaN;
vehicleParameters.rearBumperXoffset_m = NaN;
vehicleParameters.frontSteeringRoadwheelAngleLimit_rad = NaN;
vehicleParameters.width = NaN;
vehicleParameters.length = NaN;
vehicleParameters.turnRadius_m = NaN;
vehicleParameters.mass_kg = NaN;
vehicleParameters.Iz_kgm_per_s2 = NaN;
vehicleParameters.Caf_N_per_rad = NaN;
vehicleParameters.Car_N_per_rad = NaN;


charactersAsCharType = char(vehicleNameString);

% Remove multiple spaces
charactersAsCharType = regexprep(charactersAsCharType,'\s+',' ');

% Try to capture patterns:
% 1) Optional prefix (P, LT, etc.), then width/aspect/construction/rim: e.g. P225/50R17
pat = '^(?<prefix>[A-Za-z]*)?(?<width>\d{3})/(?<aspect>\d{2,3})(?<construction>[A-Za-z])(?<rim>\d{1,2})(?:\s*(?<rest>.*))?$';
m = regexp(charactersAsCharType, pat, 'names');

if isempty(m)
    % alternative: width mm may be 2 or 3 digits; accept 2-3
    pat2 = '^(?<prefix>[A-Za-z]*)?(?<width>\d{2,3})/(?<aspect>\d{2,3})(?<construction>[A-Za-z])(?<rim>\d{1,2})(?:\s*(?<rest>.*))?$';
    m = regexp(charactersAsCharType, pat2, 'names');
end

if isempty(m)
    error('Unrecognized tire sidewall format: %s', charactersAsCharType);
end

% Parse main numeric fields
vehicleParameters.prefix = string(m.prefix);
width_mm = str2double(m.width);
aspect = str2double(m.aspect);
rim_in = str2double(m.rim);
vehicleParameters.wheelbase_m = width_mm / 1000;        % mm -> m
vehicleParameters.track_m = aspect;
vehicleParameters.rimDiameter_in = rim_in;
vehicleParameters.rimDiameter_m = rim_in * 0.0254;         % 1 inch = 0.0254 m
vehicleParameters.construction = string(m.construction);

% Sidewall height = section width * (aspect/100)
vehicleParameters.frontSteeringRoadwheelAngleLimit_rad = vehicleParameters.wheelbase_m * (vehicleParameters.track_m/100);

% Overall diameter = rim diameter + 2 * sidewall height
vehicleParameters.leftBoundingBoxYoffset_m = vehicleParameters.rimDiameter_m + 2 * vehicleParameters.frontSteeringRoadwheelAngleLimit_rad;
vehicleParameters.rightBoundingBoxYoffset_m = vehicleParameters.leftBoundingBoxYoffset_m / 2;
vehicleParameters.circumference_m = pi * vehicleParameters.leftBoundingBoxYoffset_m;

% Parse optional rest for load index and speed rating (e.g. '94H' or '121/118R')
rest = "";
if isfield(m,'rest') && ~isempty(m.rest)
    rest = strtrim(m.rest);
end

if ~isempty(rest)
    % Handle dual load indexes like 121/118R
    tokens = regexp(rest, '^(?<load>\d{2,3}(?:/\d{2,3})?)(?<speed>[A-Za-z]?)', 'names');
    if ~isempty(tokens)
        vehicleParameters.loadIndex = string(tokens.load);
        vehicleParameters.speedRating = string(tokens.speed);
    else
        % maybe space-separated like '94 H'
        parts = strsplit(rest);
        if ~isempty(parts)
            % pick first numeric token as load
            ln = regexp(parts{1}, '\d{2,3}(?:/\d{2,3})?', 'match');
            if ~isempty(ln)
                vehicleParameters.loadIndex = string(ln{1});
            end
            % pick first letter token as speed
            sp = regexp(rest, '[A-Za-z]$', 'match');
            if ~isempty(sp)
                vehicleParameters.speedRating = string(sp{1});
            end
        end
    end
end


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

