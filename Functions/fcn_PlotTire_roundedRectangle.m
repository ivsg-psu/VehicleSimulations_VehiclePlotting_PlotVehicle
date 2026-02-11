function XYpoints = fcn_PlotTire_roundedRectangle(L, W, varargin)
%fcn_PlotTire_fillTireLocalXY - fills in the tire's XY coordinate view points
% FORMAT:
%
%      XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
%      (cornerShape), (cornerParams), (NcornerPoints), (figNum))
%
% INPUTS:
%
%      L - length of the rectangle in X-direction [m]
%
%      W - width of the rectangle in Y-direction [m]
%
%      (OPTIONAL INPUTS)
%
%      cornerShape    - 'ellipse' (default) | 'circle' | function handle
%   
%      cornerParams   - for 'ellipse': [a b] (semi-axes)
%                       for 'circle' : r (radius)
%                       for function handle: passed through as second arg
%   
%      NcornerPoints  - integer >=2, points per corner (default 20)
%
%      figNum - a figure number to plot results. If set to -1,
%      skips any input checking or debugging, no figures will be generated,
%      and sets up code to maximize speed.
%
% OUTPUTS:
%
%       XYpoints  - M-by-2 array of [x y] points in counter-clockwise order
%       (no duplicate final point)
%
% DEPENDENCIES:
%
%      fcn_DebugTools_checkInputsToFunctions
%
% EXAMPLES:
%     XYpoints = roundedRectangle(L, W, 'ellipse', [a b], NcornerPoints)
%     XYpoints = roundedRectangle(L, W, 'circle', r, NcornerPoints)
%     XYpoints = roundedRectangle(L, W, cornerFunc, params, NcornerPoints)
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

% TO-DO:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the figNum variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
MAX_NARGIN = 6; % The largest Number of argument inputs to the function
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
		narginchk(2,MAX_NARGIN);

		validateattributes(L,{'numeric'},{'scalar','positive'});
		validateattributes(W,{'numeric'},{'scalar','positive'});


	end
end

% Does the user want to specify the cornerShape?
cornerShape = 'ellipse'; % Default case
if 3 <= nargin
    temp = varargin{1};
    if ~isempty(temp)
		cornerShape = temp;        
    end
end

% Does the user want to specify the cornerShape?
cornerParams = [L/5 W/10]; % Default case
if 4 <= nargin
    temp = varargin{2};
    if ~isempty(temp)
		cornerParams = temp;        
    end
end

% Does the user want to specify the NcornerPoints?
NcornerPoints = 20; % Default case
if 5 <= nargin
    temp = varargin{3};
    if ~isempty(temp)
		NcornerPoints = temp;     
		validateattributes(NcornerPoints,{'numeric'},{'scalar','integer','>=',2});
    end
end

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
% half-sizes
hx = L/2; hy = W/2;

% Create a function that, given corner center (cx,cy) and an angle range tVec,
% returns Nx2 points along the corner shape sampled at equal parametric angle tVec.
if isa(cornerShape,'function_handle')
    cornerFunc = @(cx,cy,tVec) cornerShape(cx,cy,tVec,cornerParams);
else
    switch lower(cornerShape)
        case 'ellipse'
            a = cornerParams(1); b = cornerParams(2);
            if a > hx || b > hy
                error('Ellipse semi-axes must satisfy a <= L/2 and b <= W/2.');
            end
            cornerFunc = @(cx,cy,tVec) [cx + a*cos(tVec(:)), cy + b*sin(tVec(:))];
        case 'circle'
            r = cornerParams;
            if r > hx || r > hy
                error('Circle radius too large for rectangle half-dimensions.');
            end
            cornerFunc = @(cx,cy,tVec) [cx + r*cos(tVec(:)), cy + r*sin(tVec(:))];
        otherwise
            error('Unsupported cornerShape. Use ''ellipse'', ''circle'', or a function handle.');
    end
end

% Determine corner centers (inward offset to place arc tangent to edges)
% For ellipse we used centers at (±(hx-a), ±(hy-b)). For circle the center offset is (hx-r, hy-r).
% To handle both generically we compute offsets by sampling t=0,pi/2 on unit param of cornerFunc
% but simpler: infer offsets from provided params:
if strcmpi(cornerShape,'ellipse')
    a = cornerParams(1); b = cornerParams(2);
    offX = a; offY = b;
elseif strcmpi(cornerShape,'circle')
    offX = cornerParams; offY = cornerParams;
else
    % For custom function, require user-supplied offsets in params struct: params.Off = [ox oy]
    if isstruct(cornerParams) && isfield(cornerParams,'Off')
        offX = cornerParams.Off(1); offY = cornerParams.Off(2);
    else
        error(['For custom corner function provide cornerParams.Off = [offsetX offsetY] ' ...
               'where offsets are distance from rectangle corner to corner center along axes.']);
    end
end

if offX > hx || offY > hy
    error('Corner offset exceeds rectangle half-dimensions.');
end

% corner centers: TR, BR, BL, TL (starting at top-right and go CCW)
cx_TR =  hx - offX; cy_TR =  hy - offY;
cx_BR =  hx - offX; cy_BR = -hy + offY;
cx_BL = -hx + offX; cy_BL = -hy + offY;
cx_TL = -hx + offX; cy_TL =  hy - offY;

% angle vectors for quarter-arcs (sample equal parametric angles t)
% We will produce CCW ordering starting at top edge right point and go around CCW.
t_TR = linspace(pi/2, 0, NcornerPoints);        % top -> right
t_BR = linspace(0, -pi/2, NcornerPoints);       % right -> bottom
t_BL = linspace(-pi/2, -pi, NcornerPoints);     % bottom -> left
t_TL = linspace(-pi, -3*pi/2, NcornerPoints);   % left -> top

pTR = cornerFunc(cx_TR, cy_TR, t_TR); % N x 2
pBR = cornerFunc(cx_BR, cy_BR, t_BR);
pBL = cornerFunc(cx_BL, cy_BL, t_BL);
pTL = cornerFunc(cx_TL, cy_TL, t_TL);

% Straight edge connectors between arc endpoints:
% We will take the endpoints of each arc and add a single straight segment midpoint where needed
% Arc endpoints order per corner: first element is start (top/ right/ bottom/ left), last is end.
% Construct polygon by concatenation: pTR (all points), right-edge straight from end of pTR to start of pBR,
% then pBR, bottom edge, pBL, left edge, pTL, top edge back to start.
% But arcs already include the tangent points; to avoid duplicate corners remove the last point of each arc
pTR = pTR(1:end-1,:); pBR = pBR(1:end-1,:); pBL = pBL(1:end-1,:); pTL = pTL(1:end-1,:);

XYpoints = [ pTR;
       pBR;
       pBL;
       pTL ];

% Ensure CCW: compute signed area and flip if negative
area2 = polyarea(XYpoints(:,1), XYpoints(:,2));
if area2 < 0
    XYpoints = flipud(XYpoints);
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

	% Ensure closed polygon
	if ~isequal(XYpoints(1,:), XYpoints(end,:))
		XY_closed = [XYpoints; XYpoints(1,:)];
	else
		XY_closed = XYpoints;
	end

	% Create figure
	h_fig = figure(figNum);
	set(h_fig,'Name','Tire Top View','Color','w');
	axis equal; hold on; box on;
	xlabel('meters'); ylabel('meters');

	% Filled shape with edge
	hPatch = patch('XData', XY_closed(:,1), 'YData', XY_closed(:,2), ...
		'FaceColor', [0.8 0.8 0.95], 'EdgeColor', [0.1 0.1 0.6], ...
		'LineWidth', 1.5, 'FaceAlpha', 1.0); %#ok<NASGU>

	% Optional: draw outline on top for crisper edge
	plot(XY_closed(:,1), XY_closed(:,2), 'Color', [0 0 0], 'LineWidth', 0.5);

	% Optional: show corner sample points
	plot(XYpoints(:,1), XYpoints(:,2), '.', 'MarkerSize', 3, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'none');

	% Niceties: axes, grid, labels
	xlabel('X'); ylabel('Y');
	grid on;
	axis equal; % keep after plotting if needed

	% Add small padding around extents
	pad = 0.05;  % 5%
	xl = xlim; yl = ylim;
	cx = mean(xl); cy = mean(yl);
	r = max((xl(2)-xl(1))/2,(yl(2)-yl(1))/2) * (1+pad);
	xlim([cx-r cx+r]); ylim([cy-r cy+r]);

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

