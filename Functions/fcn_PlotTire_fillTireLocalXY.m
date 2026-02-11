function cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, varargin)
%fcn_PlotTire_fillTireLocalXY - fills in the tire's XY coordinate view points
% FORMAT:
%
%      cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (figNum));
%
% INPUTS:
%
%      tireParameters - a structure containing key measurements of the tire
%      as specified by the tireCodeCharacters.
%
%      (OPTIONAL INPUTS)
%
%      displayModel - an integer representing the display model to use
%
%          1: (default) square rectange, saved in cell array 1
%
%          2: elliptical cornered rectangle, saved in cell array 2
%             (uses fcn_PlotTire_roundedRectangle)
%          3: tread
%
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      cellArrayOfPoints - a cell array containing layers of points, with
%      additional complexity depending on the method used
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PlotTire_fillTireLocalXY
%     for a full test suite.
%
% This function was written on 2026_02_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotTire_fillTireLocalXY
%   % * Wrote the code originally, using fcn_Laps_break+DataIntoLapIndices
%   %   % as starter
%
% 2026_02_10 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotTire_fillTireLocalXY
%   % * Added rounded-corner rectangle (model 2) form

% TO-DO:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 3; % The largest Number of argument inputs to the function
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
		narginchk(MAX_NARGIN-2,MAX_NARGIN);

		% Validate tireParameters that it is characters or string
		% fcn_DebugTools_checkInputsToFunctions(tireParameters, '_of_char_strings');
		% Required fields check (minimal)
		reqFields = ["sectionWidth_m","radius_m"];
		for fth_field = reqFields
			if ~isfield(tireParameters, fth_field)
				error('Missing field %s in input struct.', fth_field);
			end
		end
	end
end

% Does the user want to specify the displayModel?
% Set defaults first:
displayModel = 1; % Default case

% Check for user input
if 2 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
		displayModel = temp;        
    end
end

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
flag_do_plots = 0; % Default is to show plots
figNum = [];
if (0==flag_max_speed) && (MAX_NARGIN == nargin)
	temp = varargin{end};
	if ~isempty(temp) % Did the user NOT give an empty figure number?
		figNum = temp; 
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

cellArrayOfPoints = cell(displayModel,1);

x = [0 1 1 0]'*tireParameters.sectionWidth_m;
y = [0 0 1 1]'*tireParameters.radius_m*2;

midPoint = [tireParameters.sectionWidth_m/2 tireParameters.radius_m];

XYpoints = [x y]-ones(length(x),1)*midPoint;

cellArrayOfPoints{1,1} = XYpoints;

if displayModel>=2
	% Fill parameters
	L = 1;
	W = 1;
	cornerShape = 'ellipse';
	cornerParams = [L/4 W/20];
	NcornerPoints = 24;

	% Call the fcn_PlotTire_roundedRectangle function
	XYpointsNormalized = fcn_PlotTire_roundedRectangle(L, W, ...
		(cornerShape), (cornerParams), (NcornerPoints), (-1));

	Npoints = size(XYpointsNormalized,1);
	XYpoints = XYpointsNormalized.*(ones(Npoints,1)*[tireParameters.sectionWidth_m tireParameters.radius_m*2]);
	cellArrayOfPoints{2,1} = XYpoints;
end

if displayModel>=3

	% Create a repeating pattern from -1 to 0 in X, and -1 to 1 in Y. This
	% pattern will be flipped in X and then repeated at many angles to
	% define the tire tread
	halfTreadPattern = [
		0.2000   -1
		0.2000    1
		NaN       NaN
		0.2000   -1
		0.7000    0
		NaN       NaN
		0.7000   -1
		0.7000    1
		NaN       NaN
		0.7000    0
		0.9000    0
		];

	fullTreadPattern = fcn_INTERNAL_flipNegateAndAppend(halfTreadPattern, 0);
	treadPattern = [fullTreadPattern; nan nan];

	% Find the radius versus X-posiiton for this tire
	firstNegativeValue = find(XYpointsNormalized(:,2)<0,1);
	positiveNormalizedHalfProfile = [0 0.5; XYpointsNormalized(1:firstNegativeValue-1,:)];
	positiveNormalizedProfile = 2*positiveNormalizedHalfProfile;
	fullNormalizedProfile = fcn_INTERNAL_flipNegateAndAppend(positiveNormalizedProfile, 1);

	% Find the radius multiplier for the tread pattern. This is how much
	% (percentage) the radius is at each x-value
	radiusMultiplier = interp1(fullNormalizedProfile(:,1),fullNormalizedProfile(:,2),treadPattern(:,1));


	% Across many angles in the tire, from 0 to 180, calculate what the
	% pattern looks like from the top
	Nangles = 32;

	allTread = [];
	allAngles = linspace(0,pi,Nangles+1)';
	deltaAngle = allAngles(2)-allAngles(1);


	% Loop through the angles from 0 to 360 degrees (not repeated the
	% ends). Each y value in the tread pattern is an angle, and each x
	% value is a radius. Use these to calculate the XYZ positions of all
	% the points.

	% Find the x pattern and radii for the treadPattern. These don't change
	% with angle
	xPattern = treadPattern(:,1).*tireParameters.sectionWidth_m/2;
	radii = radiusMultiplier*tireParameters.radius_m;

	for ith_angle = 1:Nangles

		% Find the angles for this specific section of tire
		angleStart = allAngles(ith_angle);
		angleEnd = angleStart+deltaAngle;
		angles = interp1([-1 1],[angleStart angleEnd],treadPattern(:,2));


		% Calculate XYZ values
		XYZtread = [xPattern radii.*cos(angles) radii.*sin(angles)];

		% Keep only the positive Z values
		positiveZs = XYZtread(:,3)>=0;

		% Append results into growing array
		allTread = [allTread; XYZtread(positiveZs,1:2); nan nan]; %#ok<AGROW>

		% For debugging
		if 1==0 %flag_do_debug
			figure(23432);clf;
			plot(allTread(:,1),allTread(:,2),'k-','Linewidth',2);
			axis equal
		end
	end
	cellArrayOfPoints{3,1} = allTread;
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

	fcn_PlotTire_plotTireXY(cellArrayOfPoints, (figNum));
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

function fullPattern = fcn_INTERNAL_flipNegateAndAppend(inputHalfPattern, flagKeepOnlyUnique)
% Flips the pattern, change the negative x to positive, and append to
% the end to define the entire pattern from -1 to 1 in x, -1 to 1 in y

Npatterns = size(inputHalfPattern,1);
flippedHalfPattern = flipud(inputHalfPattern.*(ones(Npatterns,1)*[-1 1]));
fullPatternWithRepeats = [flippedHalfPattern; inputHalfPattern];

% Keep only the unique values
if 1==flagKeepOnlyUnique
	[~, indicesUnique] = unique(fullPatternWithRepeats(:,1));
	fullPattern = fullPatternWithRepeats(indicesUnique,:);
else
	fullPattern = fullPatternWithRepeats;
end


% For debugging - plot the pattern?
if 1==0
	figure(38383);clf;
	plot(fullPattern(:,1),fullPattern(:,2),'k-','Linewidth',2);
end
end