function cellArrayOfGlobalPoints = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw, varargin)
%fcn_PlotTire_poseTireLocalToGlobal - fills in the tire's XY coordinate view points
% FORMAT:
%
%      cellArrayOfGlobalPoints = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw,  (figNum));
%
% INPUTS:
%
%      cellArrayOfLocalXYPoints - a cell array containing layers of points,
%      with additional complexity depending on the method used
%
%      XYZ: a 1x3 array of the X, Y, and Z location to set the tire pose
%
%      rollPitchYaw: a 1x3 array of the roll, pitch, and yaw location to
%      set the tire pose
%
%      (OPTIONAL INPUTS)
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%      cellArrayOfGlobalPoints - a cell array containing layers of points,
%      each moved to the new pose
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%
%     See the script: script_test_fcn_PlotTire_poseTireLocalToGlobal
%     for a full test suite.
%
% This function was written on 2026_02_08 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% REVISION HISTORY:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotTire_poseTireLocalToGlobal
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
MAX_NARGIN = 4; % The largest Number of argument inputs to the function
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

		% % Validate cellArrayOfLocalXYPoints that it is characters or string
		% % fcn_DebugTools_checkInputsToFunctions(cellArrayOfLocalXYPoints, '_of_char_strings');
		% % Required fields check (minimal)
		% reqFields = ["sectionWidth_m","radius_m"];
		% for fth_field = reqFields
		% 	if ~isfield(cellArrayOfPoints, fth_field)
		% 		error('Missing field %s in input struct.', fth_field);
		% 	end
		% end
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
Ncells = size(cellArrayOfLocalXYPoints,1);
cellArrayOfGlobalPoints = cell(Ncells,1);
for ith_cellArray = 1:Ncells
	localPoints = cellArrayOfLocalXYPoints{ith_cellArray,1};
	Npoints = size(localPoints,1);
	Ndimensions = size(localPoints,2);

	if Ndimensions==2
		localXYZ = [localPoints, zeros(Npoints,1)];
	else
		localXYZ = localPoints;
	end

    localXYZrotated = rotatePointsXYZ(localXYZ, rollPitchYaw(1), rollPitchYaw(2), rollPitchYaw(3));

	% Add the XYZ offset to the localXYZrotated points
	localXYZoffset = localXYZrotated + ones(Npoints,1)*XYZ; % Add the XYZ offset

	cellArrayOfGlobalPoints{ith_cellArray} = localXYZoffset;
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
	fcn_PlotTire_plotTireXY(cellArrayOfGlobalPoints, (figNum));

	% % Create figure
	% h_fig = figure(figNum);
	% set(h_fig,'Name','Tire Top View','Color','w');
	% axis equal; hold on; box on;
	% xlabel('meters'); ylabel('meters');
	% 
	% for ith_cellArray = 1:Ncells
	% 	localXYZ = cellArrayOfLocalXYPoints{ith_cellArray,1};
	% 	globalXYZ = cellArrayOfGlobalPoints{ith_cellArray};
	% 
	% 	subplot(1,2,1);
	% 	hold on; grid on;
	% 	patch(localXYZ(:,1),localXYZ(:,2),'.-','DisplayName',sprintf('Layer %.0f',ith_cellArray));
	% 	title('Local XYZ');
	% 	axis equal
	% 
	% 	pad = 0.05; % 5% padding
	% 	xl = xlim; yl = ylim;
	% 	cx = mean(xl); cy = mean(yl);
	% 	rx = (xl(2)-xl(1))/2 * (1+pad);
	% 	ry = (yl(2)-yl(1))/2 * (1+pad);
	% 	xlim([cx-rx, cx+rx]);
	% 	ylim([cy-ry, cy+ry]);
	% 
	% 
	% 	subplot(1,2,2);
	% 	hold on; grid on;
	% 	patch(globalXYZ(:,1),globalXYZ(:,2),'.-','DisplayName',sprintf('Layer %.0f',ith_cellArray));
	% 	title('Global XYZ');
	% 	axis equal
	% 
	% 	pad = 0.05; % 5% padding
	% 	xl = xlim; yl = ylim;
	% 	cx = mean(xl); cy = mean(yl);
	% 	rx = (xl(2)-xl(1))/2 * (1+pad);
	% 	ry = (yl(2)-yl(1))/2 * (1+pad);
	% 	xlim([cx-rx, cx+rx]);
	% 	ylim([cy-ry, cy+ry]);
	% 
	% end


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

function P_rot = rotatePointsXYZ(P, roll, pitch, yaw, varargin)
% rotatePointsXYZ  Rotate 3xN points by roll (φ), pitch (θ), yaw (_psi).
%   P      - 3xN matrix of points (columns)
%   roll   - rotation about x (φ)
%   pitch  - rotation about y (θ)
%   yaw    - rotation about z (_psi)
%   'Degrees',true  - interpret angles as degrees (default false)
%
%   Uses R = Rz(yaw)*Ry(pitch)*Rx(roll) (apply roll then pitch then yaw).

% USAGE:
% P = [1 0 0; 0 1 0; 0 0 1]'; % 3x3 points
% P_rot = rotatePointsXYZ(P, deg2rad(10), deg2rad(20), deg2rad(30));


% Notes
%
% Conventions vary: if you want intrinsic (body-fixed) rotations or a
% different order (e.g., roll→pitch→yaw as successive body rotations), use
% R = Rx(φ)Ry(θ)Rz(_psi) or reverse the multiplication order accordingly.
%
% Confirm whether angles are applied in intrinsic (body) or extrinsic
% (fixed) frame and choose the matrix order to match.

p = inputParser;
addParameter(p,'Degrees',false,@(x) islogical(x) || isnumeric(x));
parse(p,varargin{:});
if p.Results.Degrees
    roll = deg2rad(roll);
    pitch = deg2rad(pitch);
    yaw = deg2rad(yaw);
end

c_phi = cos(roll); s_phi = sin(roll);
c_theta = cos(pitch); s_theta = sin(pitch);
c_psi = cos(yaw); s_psi = sin(yaw);

Rx = [1 0 0; 0 c_phi -s_phi; 0 s_phi c_phi];
Ry = [c_theta 0 s_theta; 0 1 0; -s_theta 0 c_theta];
Rz = [c_psi -s_psi 0; s_psi c_psi 0; 0 0 1];

R = Rz * Ry * Rx;

P_rot = P * R;
end

