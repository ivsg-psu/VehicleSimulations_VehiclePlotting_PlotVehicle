% script_test_fcn_PlotVehicle_traceVehicle.m
% tests fcn_PlotVehicle_traceVehicle.m

% REVISION HISTORY:
%
% 2025_02_16 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotVehicle_traceVehicle
%   % * Wrote the code originally, using script_test_fcn_Laps_break+DataIntoLapIndices

% TO-DO:
%
% 2025_02_16 by Sean Brennan, sbrennan@psu.edu
% - (fill in items here)


%% Set up the workspace
close all

%% Code demos start here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              ____   __    _____          _
%  |  __ \                            / __ \ / _|  / ____|        | |
%  | |  | | ___ _ __ ___   ___  ___  | |  | | |_  | |     ___   __| | ___
%  | |  | |/ _ \ '_ ` _ \ / _ \/ __| | |  | |  _| | |    / _ \ / _` |/ _ \
%  | |__| |  __/ | | | | | (_) \__ \ | |__| | |   | |___| (_) | (_| |  __/
%  |_____/ \___|_| |_| |_|\___/|___/  \____/|_|    \_____\___/ \__,_|\___|
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Demos%20Of%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 1

close all;
fprintf(1,'Figure: 1XXXXXX: DEMO cases\n');

%% DEMO case: basic example call
figNum = 10001;
titleString = sprintf('DEMO case: basic example call');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

figAllViews = 9999;

vehicleImageFilePathString = fullfile(pwd,'Data','2017_Ford_Transit_ConnectXLTWagon.png');
allViewsFigurePathString = fullfile(pwd,'Data','vehicleViews.fig');

viewNames = {'Top View', 'Passenger Side View','Drivers Side View','Front View', 'Rear View'};
viewNumbers = [1; 4; 6; 5; 8];

if 1==1 %~exist(allViewsFigure,'file')
	imgAllViews = imread(vehicleImageFilePathString);   % load image into workspace
	figure(figNum);                      % open new figure
	imshow(imgAllViews);                   % display image
	axis image off;              % keep aspect ratio, hide axes if desired

	for ith_view = 1:length(viewNames)
		figure(figNum);
		fprintf(1,'Select the %s\n', viewNames{ith_view});
		temp = fcn_INTERNAL_selectImageRegion(imgAllViews);
		figure(figAllViews); subplot(3,3,viewNumbers(ith_view));
		imshow(temp);
		title(sprintf('%s',viewNames{ith_view}));
	end

	savefig(figAllViews, allViewsFigurePathString);
end

workingFig = openfig(allViewsFigurePathString);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Align the images with each other

temp = get(workingFig,'Children');

for ith_view = 1:length(viewNames)
	
	titleToMatch = temp(ith_view).Title.String;

	thisIndex = find(strcmp(titleToMatch,viewNames),1);

	if isempty(thisIndex)
		error('Unable to match titles to plots!?');
	end	

	viewName = viewNames{thisIndex};	
	viewNumber = viewNumbers(thisIndex,1);

    fprintf(1,'Aligning %s...\n', viewName);
	fprintf(1,'Select a feature to align image in %s:\n',viewName);
	pts = fcn_INTERNAL_pickPixelsInSubplot(temp(ith_view));
end



% tireCodeCharacters = '205/55R16 91V';


% Wheelbase: 3.06324 meters
% Track: 1.567 meters
% Bumper-to-bumper length: 4.81838 meters
% Rear axle to rear bumper: 0.9144 meters
% Rear axe to front bumper: 3.90398 meters
% Width: 2.13614 meters
% Length: 4.81838 meters
% Turn radius: 6.096 meters
% Mass: 1805 kg


% Call the function
vehicleParameters = fcn_PlotVehicle_traceVehicle(vehicleNameString, (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isstruct(vehicleParameters));
assert(all(isfield(vehicleParameters,{ ...
	'vehicleNameString', ...
	'wheelbase_m', ...
	'track_m', ...
	'frontBumperXoffset_m',...
	'rearBumperXoffset_m',...
	'frontSteeringRoadwheelAngleLimit_rad', ...
	'width', ...
	'length', ...
	'turnRadius_m', ...
	'mass_kg', ...
	'Iz_kgm_per_s2', ...
	'Caf_N_per_rad', ...
	'Car_N_per_rad'})));

% Check variable sizes
assert(size(vehicleParameters,1)==1); 
assert(size(vehicleParameters,2)==1); 

% Check variable values
% Too many

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% Test cases start here. These are very simple, usually trivial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  _______ ______  _____ _______ _____
% |__   __|  ____|/ ____|__   __/ ____|
%    | |  | |__  | (___    | | | (___
%    | |  |  __|  \___ \   | |  \___ \
%    | |  | |____ ____) |  | |  ____) |
%    |_|  |______|_____/   |_| |_____/
%
%
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 2

% close all;
% fprintf(1,'Figure: 2XXXXXX: TEST mode cases\n');
% 
% %% TEST case: This one returns nothing since there is no portion of the path in criteria
% figNum = 20001;
% titleString = sprintf('TEST case: This one returns nothing since there is no portion of the path in criteria');
% fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
% figure(figNum); clf;


%% Fast Mode Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ______        _     __  __           _        _______        _
% |  ____|      | |   |  \/  |         | |      |__   __|      | |
% | |__ __ _ ___| |_  | \  / | ___   __| | ___     | | ___  ___| |_ ___
% |  __/ _` / __| __| | |\/| |/ _ \ / _` |/ _ \    | |/ _ \/ __| __/ __|
% | | | (_| \__ \ |_  | |  | | (_) | (_| |  __/    | |  __/\__ \ |_\__ \
% |_|  \__,_|___/\__| |_|  |_|\___/ \__,_|\___|    |_|\___||___/\__|___/
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Fast%20Mode%20Tests
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figures start with 8

close all;
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
% 
% tireCodeCharacters = '205/55R16 91V';
% 
% % Call the function
% vehicleParameters = fcn_PlotVehicle_traceVehicle(tireCodeCharacters, ([]));
% 
% % Check variable types
% assert(isstruct(vehicleParameters));
% assert(isfield(vehicleParameters,'sectionWidth_m'));
% assert(isfield(vehicleParameters,'sidewallHeight_m'));
% assert(isfield(vehicleParameters,'rimDiameter_m'));
% assert(isfield(vehicleParameters,'overallDiameter_m'));
% assert(isfield(vehicleParameters,'circumference_m'));
% assert(isfield(vehicleParameters,'loadIndex'));
% assert(isfield(vehicleParameters,'speedRating'));
% 
% % Check variable sizes
% assert(size(vehicleParameters,1)==1); 
% assert(size(vehicleParameters,2)==1); 
% 
% % Check variable values
% % Are the laps starting at expected points?
% assert(vehicleParameters.sectionWidth_m==0.205);
% assert(vehicleParameters.sidewallHeight_m==0.11275);
% assert(vehicleParameters.rimDiameter_m==0.4064);
% assert(vehicleParameters.overallDiameter_m==0.6319);
% assert(vehicleParameters.circumference_m==0.6319*pi);
% assert(strcmp(vehicleParameters.construction,'R'));
% assert(strcmp(vehicleParameters.loadIndex,''));
% assert(strcmp(vehicleParameters.speedRating,''));
% assert(strcmp(vehicleParameters.prefix,''));
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Basic fast mode - NO FIGURE, FAST MODE
% figNum = 80002;
% fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
% figure(figNum); close(figNum);
% 
% tireCodeCharacters = '205/55R16 91V';
% 
% % Call the function
% vehicleParameters = fcn_PlotVehicle_traceVehicle(tireCodeCharacters, (-1));
% 
% % Check variable types
% assert(isstruct(vehicleParameters));
% assert(isfield(vehicleParameters,'sectionWidth_m'));
% assert(isfield(vehicleParameters,'sidewallHeight_m'));
% assert(isfield(vehicleParameters,'rimDiameter_m'));
% assert(isfield(vehicleParameters,'overallDiameter_m'));
% assert(isfield(vehicleParameters,'circumference_m'));
% assert(isfield(vehicleParameters,'loadIndex'));
% assert(isfield(vehicleParameters,'speedRating'));
% 
% % Check variable sizes
% assert(size(vehicleParameters,1)==1); 
% assert(size(vehicleParameters,2)==1); 
% 
% % Check variable values
% % Are the laps starting at expected points?
% assert(vehicleParameters.sectionWidth_m==0.205);
% assert(vehicleParameters.sidewallHeight_m==0.11275);
% assert(vehicleParameters.rimDiameter_m==0.4064);
% assert(vehicleParameters.overallDiameter_m==0.6319);
% assert(vehicleParameters.circumference_m==0.6319*pi);
% assert(strcmp(vehicleParameters.construction,'R'));
% assert(strcmp(vehicleParameters.loadIndex,''));
% assert(strcmp(vehicleParameters.speedRating,''));
% assert(strcmp(vehicleParameters.prefix,''));
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% 
% %% Compare speeds of pre-calculation versus post-calculation versus a fast variant
% figNum = 80003;
% fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
% figure(figNum);
% close(figNum);
% 
% tireCodeCharacters = '205/55R16 91V';
% 
% Niterations = 50;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
% 
% 	% Call the function
% 	vehicleParameters = fcn_PlotVehicle_traceVehicle(tireCodeCharacters, ([]));
% 
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
% 
% 	% Call the function
% 	vehicleParameters = fcn_PlotVehicle_traceVehicle(tireCodeCharacters, (-1));
% 
% end
% fast_method = toc;
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));
% 
% % Plot results as bar chart
% figure(373737);
% clf;
% hold on;
% 
% X = categorical({'Normal mode','Fast mode'});
% X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
% Y = [slow_method fast_method ]*1000/Niterations;
% bar(X,Y)
% ylabel('Execution time (Milliseconds)')
% 
% 
% % Make sure plot did NOT open up
% figHandles = get(groot, 'Children');
% assert(~any(figHandles==figNum));


%% BUG cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ____  _    _  _____
% |  _ \| |  | |/ ____|
% | |_) | |  | | |  __    ___ __ _ ___  ___  ___
% |  _ <| |  | | | |_ |  / __/ _` / __|/ _ \/ __|
% | |_) | |__| | |__| | | (_| (_| \__ \  __/\__ \
% |____/ \____/ \_____|  \___\__,_|___/\___||___/
%
% See: http://patorjk.com/software/taag/#p=display&v=0&f=Big&t=BUG%20cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All bug case figures start with the number 9

% close all;

%% BUG 

%% Fail conditions
if 1==0
    %
        
end


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

function cropped = fcn_INTERNAL_selectImageRegion(img)
% selectImageRegion  Show image and let user select a rectangular region.
%   cropped = selectImageRegion(img) displays img and lets the user draw
%   and adjust a rectangle. Double-click the rectangle (or press Enter)
%   to accept. The function returns the cropped image. If the selection is
%   cancelled or figure closed, returns empty [].
%
%   img can be grayscale, RGB, or indexed.

if nargin<1, error('Image input required.'); end

% Create figure and show image
fig = figure('Name','Select region: double-click to accept, Esc to cancel',...
             'NumberTitle','off','Interruptible','off','BusyAction','cancel');
ax = axes('Parent',fig);
imshow(img, 'Parent', ax);
hold(ax,'on');

% Create interactive rectangle ROI
% Prefer drawrectangle (R2018b+) but fall back to imrect if unavailable
useNew = exist('drawrectangle','file')==2;
try
    if useNew
        roi = drawrectangle(ax, 'Color','r');
        % wait until ROI is double-clicked or deleted
        
		% roiCompleted = wait(roi); % returns when committed or deleted
        if isempty(roi) || ~isvalid(roi) 
            cropped = [];
			return;
        end
        pos = roi.Position; % [x y w h] in axes data (image pixels)
    else
        roi = imrect(ax);
        pos = wait(roi); % blocks until double-click or Enter
        if isempty(pos)
            cropped = [];
			return;
        end
    end
catch
    % user closed figure or cancelled
    cropped = [];
    return;
end

% Convert position to integer pixel indices
x = round(pos(1));
y = round(pos(2));
w = round(pos(3));
h = round(pos(4));

% Get image size and clamp coordinates (imshow may set XData/YData)
% Determine image XData/YData to map axes coords to pixel indices
imObj = findobj(ax,'Type','image');
if ~isempty(imObj)
    xd = get(imObj,'XData');
    yd = get(imObj,'YData');
else
    xd = [1 size(img,2)];
    yd = [1 size(img,1)];
end

% Map axes coordinates to pixel indices if XData/YData not default
if numel(xd)==2 && numel(yd)==2 && ~(xd(1)==1 && xd(2)==size(img,2) && yd(1)==1 && yd(2)==size(img,1))
    % linear mapping from axis coords to pixel columns/rows
    col1 = round( 1 + (x - xd(1))*(size(img,2)-1)/(xd(2)-xd(1)) );
    row1 = round( 1 + (y - yd(1))*(size(img,1)-1)/(yd(2)-yd(1)) );
    col2 = round( 1 + (x+w - xd(1))*(size(img,2)-1)/(xd(2)-xd(1)) );
    row2 = round( 1 + (y+h - yd(1))*(size(img,1)-1)/(yd(2)-yd(1)) );
else
    col1 = x;
    row1 = y;
    col2 = x + w - 1;
    row2 = y + h - 1;
end

% Clamp to image bounds
col1 = max(1, min(size(img,2), col1));
col2 = max(1, min(size(img,2), col2));
row1 = max(1, min(size(img,1), row1));
row2 = max(1, min(size(img,1), row2));

if col2 < col1 || row2 < row1
    cropped = [];
else
    cropped = img(row1:row2, col1:col2, :);
end

% Clean up?
% if ishandle(fig), close(fig); end
end

%%
function pts = fcn_INTERNAL_pickPixelsInSubplot(ax)
% pts = pickPixelsInSubplot(ax)
% Click inside axes ax to collect pixel coordinates. Press Enter to finish.
% Returns pts as [col row] (1-based pixel indices). Empty on cancel.

if nargin==0 || isempty(ax), ax = gca; end
fig = ancestor(ax,'figure');

% Find image object in axes (assume one image shown)
imObj = findobj(ax,'Type','image');
if isempty(imObj)
    error('No image found in the specified axes.');
end
img = imObj.CData;
nx = size(img,2); ny = size(img,1);

pts = zeros(0,2);
hold on;

hMark = plot(ax, NaN, NaN, 'ro', 'MarkerFaceColor','r');

% ensure clicks hit the image
set(imObj,'HitTest','on');
% store state
setappdata(fig,'pickPts',pts);
set(fig, 'WindowButtonDownFcn', @(~,~) localClick(), ...
         'KeyPressFcn',       @(~,ev) localKey(ev));

uiwait(fig);                       % block until Enter pressed or figure closed
if ishandle(fig)
    pts = getappdata(fig,'pickPts');
    % cleanup callbacks
    set(fig,'WindowButtonDownFcn',[],'KeyPressFcn',[]);
    if ishandle(hMark), delete(hMark); end
end

    function localClick()
        % Only proceed if click occurred in target axes
        clickedAx = get(fig,'CurrentAxes');
        if ~isequal(clickedAx, ax)
            return;
        end
        % get data-space point
        C = get(ax,'CurrentPoint');
        x = C(1,1); y = C(1,2);   % x = column (horizontal), y = row (vertical)
        % Map axes coordinates to pixel indices using image XData/YData
        xd = get(imObj,'XData'); yd = get(imObj,'YData');
        if numel(xd)==2 && numel(yd)==2
            col = round( 1 + (x - xd(1)) * (nx-1) / (xd(2)-xd(1)) );
            row = round( 1 + (y - yd(1)) * (ny-1) / (yd(2)-yd(1)) );
        else
            col = round(x);
            row = round(y);
        end
        % clamp
        col = max(1,min(nx,col));
        row = max(1,min(ny,row));
        pts = getappdata(fig,'pickPts');
        pts(end+1,:) = [col row];
        setappdata(fig,'pickPts',pts);
        set(hMark,'XData',pts(:,1),'YData',pts(:,2));
        drawnow;
    end

    function localKey(ev)
        if strcmp(ev.Key,'return')
            uiresume(fig);
        elseif strcmp(ev.Key,'escape')
            setappdata(fig,'pickPts',zeros(0,2));
            uiresume(fig);
        end
    end

pts = pts(end,:);
end
