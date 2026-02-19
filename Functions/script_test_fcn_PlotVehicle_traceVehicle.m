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

vehicleNameString = '2017_Ford_Transit_ConnectXLTWagon';
vehicleParameters = fcn_PlotVehicle_fillParametersFromName(vehicleNameString, (figNum));

vehicleImageFilePathString = fullfile(pwd,'Data','2017_Ford_Transit_ConnectXLTWagon');
allViewsFigurePathString = fullfile(pwd,'Data','vehicleViews.fig');
alignedViewsFigurePathString = fullfile(pwd,'Data','vehicleViewsAligned.fig');

viewNames = {
	'TopView',...
	'',...
	'',...	
	'PassengerSideView',...
	'FrontView', ...
	'DriversSideView',...
	'',...
	'RearView',...
	''};

viewDimensionDirections = [
	1 1 0; % subplot(3,3,1) - XY
	0 0 0; % subplot(3,3,2) - empty
	0 0 0; % subplot(3,3,3) - empty
	1 0 1; % subplot(3,3,4) - XZ
	0 1 1; % subplot(3,3,5) - YZ 
	-1 0 1;% subplot(3,3,6) - (-X)Z
	0 0 0; % subplot(3,3,7) - empty
	0 -1 1;% subplot(3,3,8) - (-Y)Z
	0 0 0];% subplot(3,3,9) - empty

imageMinsMaxs = [
	1 1 0; % subplot(3,3,1) - XY
	0 0 0; % subplot(3,3,2) - empty
	0 0 0; % subplot(3,3,3) - empty
	1 0 1; % subplot(3,3,4) - XZ
	0 1 1; % subplot(3,3,5) - YZ 
	-1 0 1;% subplot(3,3,6) - (-X)Z
	0 0 0; % subplot(3,3,7) - empty
	0 -1 1;% subplot(3,3,8) - (-Y)Z
	0 0 0];% subplot(3,3,9) - empty

% Have all the views been saved/grabbed?
Nviews = 9;
subImagePathStrings = cell(Nviews,1);
flagAllExist = 1;
for ith_view = 1:length(viewNames)
	if ~isempty(viewNames{ith_view})
		thisViewName = viewNames{ith_view}; % Get the current view name
		subImageFilePathString = cat(2,vehicleImageFilePathString,'_',thisViewName,'.png');
		subImagePathStrings{ith_view} = subImageFilePathString; % Store the path for the current view	
		if ~exist(subImageFilePathString,'file')
			flagAllExist = 0;
		end
	end
end

%% If images don't already exist as separate, saved views, query user and
% save them
if 0==flagAllExist
	imgAllViews = imread(cat(2,vehicleImageFilePathString,'.png'));   % load image into workspace
	figure(figNum);                      % open new figure
	imshow(imgAllViews);                   % display image
	axis image off;              % keep aspect ratio, hide axes if desired
	images = cell(9,1);

	for ith_view = 1:length(viewNames)
		if ~isempty(viewNames{ith_view})
			thisViewName = viewNames{ith_view}; % Get the current view name

			figure(figNum);
			fprintf(1,'Select the %s\n', thisViewName);
			imageFromThisFigure = fcn_INTERNAL_selectImageRegion(imgAllViews);
			images{ith_view} = imageFromThisFigure;					
			imwrite(imageFromThisFigure, subImagePathStrings{ith_view}); % Save the extracted view image


			% figure(figAllViews);
			% subplot(3,3,ith_view);
			% imshow(temp, 'XData',[1 size(temp,2)], 'YData',[1 size(temp,1)]);
			% title(sprintf('%s',viewNames{ith_view}));
		end
	end
end

%% Define metersPerPixel
% Open up the side views and ask user to select points to 
figure(figNum);
clf;
imgThisView = imread(subImagePathStrings{4});
imshow(imgThisView);


%% Create one figure (XYZ) that has all images inside it
figure(figNum);
for ith_view = 1:length(viewNames)
	if ~isempty(viewNames{ith_view})
		thisViewName = viewNames{ith_view}; % Get the current view name

		% Load image
		imgThisView = imread(subImagePathStrings{ith_view});   % load image into workspace
		[m,n,~] = size(imgThisView);

		thisDirections = viewDimensionDirections(ith_view,:);
					

		% Desired data ranges for the image in non-trivial axes
		xMin = -2; xMax = 3;              % image maps to these X coordinates
		zMin = -1; zMax = 4;              % image maps to these Z coordinates
		y0 = 0;                           % place image in plane y = y0

		% Create mesh for surface vertices (note meshgrid order: columns->X, rows->Z)
		x = linspace(xMin, xMax, n);      % one value per image column
		z = linspace(zMin, zMax, m);      % one value per image row
		[Xg, Zg] = meshgrid(x, z);
		Yg = y0 * ones(size(Xg));

		% Create textured surface with image as texture
		figure;
		ax = axes;
		hImSurf = surface(ax, Xg, Yg, Zg, ...    % geometry
			'CData', flipud(imgThisView), ...             % CData: color image (flip if needed)
			'FaceColor', 'texturemap', ...
			'EdgeColor', 'none', 'FaceAlpha',0.5);

		hold(ax, 'on');


		% figure(figAllViews);
		% subplot(3,3,ith_view);
		% imshow(temp, 'XData',[1 size(temp,2)], 'YData',[1 size(temp,1)]);
		% title(sprintf('%s',viewNames{ith_view}));
	end
end

% % Have all the images been pushed into subplots of one figure?
% if ~exist(allViewsFigurePathString,'file')
% 
% 	% Align all the pixels
% 	figure(figAllViews);
% 	clf;
% 	% grid_equal_pixel_axes(images, 3, 3)
% 	rescalingFactor = 1.6;
% 	minRatioDistanceperPixel = demo_tiled_equal_size(images, viewDimensionDirections, rescalingFactor, viewNames);
% 
% 	scaleImagesInFigure(figAllViews, []);
% 	equalizeImagePixelScale(figAllViews, []);
% 	savefig(figAllViews, allViewsFigurePathString);
% end

%%%% Make sure all the subplots are aligned

% Align first column
workingFig = openfig(alignedViewsFigurePathString);
viewNumbers = [1; 4; 7]; % Define view numbers for alignment
imageDimensionToAlign = 1;
fcn_INTERNAL_alignSubplots(workingFig, viewNames, viewNumbers, minRatioDistanceperPixel, imageDimensionToAlign)

% Save results
savefig(workingFig, alignedViewsFigurePathString)

% Align second column
workingFig = openfig(alignedViewsFigurePathString);
viewNumbers = [2; 5; 8]; % Define view numbers for alignment
imageDimensionToAlign = 1; 
fcn_INTERNAL_alignSubplots(workingFig, viewNames, viewNumbers, minRatioDistanceperPixel, imageDimensionToAlign)

% Save results
savefig(workingFig, alignedViewsFigurePathString)



% Align second row
workingFig = openfig(alignedViewsFigurePathString);
viewNumbers = [4; 5; 6]; % Define view numbers for alignment
imageDimensionToAlign = 2; 
fcn_INTERNAL_alignSubplots(workingFig, viewNames, viewNumbers, minRatioDistanceperPixel, imageDimensionToAlign)

% Save results
savefig(workingFig, alignedViewsFigurePathString)


%% Set up synchronized zoom

%%%% 
% Find all the zoom points

imageFromThisFigure = get(workingFig,'Children');
existingTitles = cell(length(imageFromThisFigure),1);
for ith_subplot = 1:length(imageFromThisFigure)
	existingTitles{ith_subplot,1} = imageFromThisFigure(ith_subplot).Title.String;
end

allClickedPoints = nan(9,2);

%%%%
% Have the user select features to match
for ith_view = 1:length(viewNames)
	if ~isempty(viewNames{ith_view}) && any(ith_view==viewNumbers)

		% titleToMatch = axesInThisFigure(ith_view).Title.String;
		% thisIndex = find(strcmp(titleToMatch,viewNames),1);

		viewToMatch = viewNames{ith_view};
		axisIndex = find(strcmp(existingTitles,viewToMatch),1);
		axisHandle = imageFromThisFigure(axisIndex);



		% Find image object in axes (assume one image shown)
		imObj = findobj(axisHandle,'Type','image');
		if isempty(imObj)
			error('No image found in the specified axes.');
		end
		img = imObj.CData;
		nx = size(img,2);
		ny = size(img,1);

		figPt = dataToFig(workingFig, axisHandle, [nx ny], 'pixels');

	end
end


imageFromThisFigure = get(workingFig,'Children');
syncZoomByFigurePoints(workingFig, imageFromThisFigure, figPoints, units)

%%




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
function [pts, figCoordinates] = fcn_INTERNAL_pickPixelsInSubplot(ax)
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

allPoints = zeros(0,2);
figCoordinates = zeros(0,2);
hold(ax,'on');

hMark = plot(ax, nx/2, ny/2, 'ro', 'MarkerFaceColor','r');

% ensure clicks hit the image
set(imObj,'HitTest','on');

% store states
setappdata(fig,'pickPts',allPoints);
setappdata(fig,'cPts',figCoordinates);

set(fig, 'WindowButtonDownFcn', @(~,~) localClick(), ...
         'KeyPressFcn',       @(~,ev) localKey(ev));

uiwait(fig);                       % block until Enter pressed or figure closed
if ishandle(fig)
    allPoints = getappdata(fig,'pickPts');
	figCoordinates = getappdata(fig,'cPts');

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
		F = get(gcf, 'CurrentPoint');
        C = get(ax,'CurrentPoint');
		figCoordinates = getappdata(fig,'cPts');
		figCoordinates(end+1,:) = F;

        x = C(1,1); y = C(1,2);   % x = column (horizontal), y = row (vertical)
        % Map axes coordinates to pixel indices using image XData/YData
        xd = get(imObj,'XData'); 
		yd = get(imObj,'YData');

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
        allPoints = getappdata(fig,'pickPts');
        allPoints(end+1,:) = [col row];

		setappdata(fig,'pickPts',allPoints);
		setappdata(fig,'cPts',figCoordinates)
        
		set(hMark,'XData',allPoints(:,1),'YData',allPoints(:,2));
        drawnow;
    end

    function localKey(ev)
        if strcmp(ev.Key,'return')
            uiresume(fig);
        elseif strcmp(ev.Key,'escape')
            setappdata(fig,'pickPts',zeros(0,2));
			setappdata(fig,'cPts',zeros(0,2))
            uiresume(fig);
        end
    end

pts = allPoints(end,:);
end

function scaleImagesInFigure(fig, scale)
% scaleImagesInFigure  Set same pixel scaling for all images in a figure.
%   scaleImagesInFigure(fig, scale) sets each image's XData and YData so
%   one image pixel equals 'scale' axis units. 'fig' is a figure handle.
%   If scale is omitted or empty, scale = 1 (one axis unit per pixel).
%
%   Example:
%     fig = figure;
%     ax1 = subplot(1,2,1); imshow(im1, 'Parent', ax1);
%     ax2 = subplot(1,2,2); imshow(im2, 'Parent', ax2);
%     scaleImagesInFigure(fig, 2);  % double the pixel size in axis units

if nargin<1 || isempty(fig), fig = gcf; end
if ~ishandle(fig) || ~strcmp(get(fig,'Type'),'figure')
    error('First argument must be a figure handle.');
end
if nargin<2 || isempty(scale), scale = 1; end
validateattributes(scale, {'numeric'},{'scalar','positive'});

% Find all axes in the figure
axesList = findall(fig, 'Type', 'axes');

for k = 1:numel(axesList)
    ax = axesList(k);
    % skip polar/geographic/UI axes that don't host image objects the same way
    if ~isgraphics(ax, 'axes'), continue; end

    % find image objects in this axes
    imgs = findall(ax, 'Type', 'image');
    if isempty(imgs), continue; end

    for j = 1:numel(imgs)
        imObj = imgs(j);
        % get image size from CData
        C = imObj.CData;
        if isempty(C), continue; end
        [nrows, ncols, ~] = size(C);

        % Set XData and YData so each pixel occupies 'scale' axis units.
        % We place pixel centers at:
        %   x centers = scale*(0.5 : ncols-0.5)
        %   y centers = scale*(0.5 : nrows-0.5)
        % image interprets XData/YData as locations for first and last pixel centers when given two-element vectors.
        xStart = scale*0.5;
        xEnd   = scale*(ncols - 0.5);
        yStart = scale*0.5;
        yEnd   = scale*(nrows - 0.5);

        % Assign XData/YData (two-element vectors)
        set(imObj, 'XData', [xStart xEnd], 'YData', [yStart yEnd]);

        % Ensure axes limits preserve the image aspect ratio and show full image
        % (optional) expand axes limits to exactly contain image extents
        ax.XLim = [xStart - scale*0.5, xEnd + scale*0.5];
        ax.YLim = [yStart - scale*0.5, yEnd + scale*0.5];

        % Keep correct aspect ratio
        daspect(ax, [1 1 1]);
    end
end
end

function equalizeImagePixelScale(fig, scale)
% equalizeImagePixelScale(fig, scale)
%   Set all images in figure 'fig' so one image pixel = 'scale' axis units.
%   If scale omitted, scale = 1 (one axis unit per pixel).
%   You should arrange subplots so axes have the same on-screen size
%   (e.g. using tight_subplot, subplot with identical Position, or tiledlayout).

if nargin<1 || isempty(fig), fig = gcf; end
if nargin<2 || isempty(scale), scale = 1; end

% find all axes and image objects
axs = findall(fig,'Type','axes');
for ax = axs(:).'
    imgs = findall(ax,'Type','image');
    if isempty(imgs), continue; end
    for imObj = imgs.'
        C = imObj.CData;
        if isempty(C), continue; end
        [nrows, ncols, ~] = size(C);
        % set XData/YData so pixel centers are at:
        %   x centers = scale*(0.5 : ncols-0.5)
        %   y centers = scale*(0.5 : nrows-0.5)
        xStart = scale*0.5;
        xEnd   = scale*(ncols - 0.5);
        yStart = scale*0.5;
        yEnd   = scale*(nrows - 0.5);
        set(imObj, 'XData', [xStart xEnd], 'YData', [yStart yEnd]);
        % ensure 1:1 data aspect ratio
        daspect(ax, [1 1 1]);
        % expand axes limits to include full image
        ax.XLim = [xStart - scale*0.5, xEnd + scale*0.5];
        ax.YLim = [yStart - scale*0.5, yEnd + scale*0.5];
    end
end
end


%% minRatioDistanceperPixel
function minRatioDistanceperPixel = demo_tiled_equal_size(images, viewDimensionDirections, rescalingFactor, viewNames)
% images is a cell array of image arrays
Nimages = numel(images);
% cols = ceil(sqrt(Nimages));
% rows = ceil(Nimages/cols);
% t = tiledlayout(rows, cols, 'TileSpacing','compact', 'Padding','compact');

% Show the result
for kth_image = 1:Nimages
	if ~isempty(images{kth_image})
		thisImage = images{kth_image};
		ax = subplot(3,3,kth_image);
		xStart = 1;
		xEnd = size(thisImage,2);
		yStart = 1;
		yEnd = size(thisImage,1);
		imshow(thisImage, 'Parent', ax, 'XData', [xStart xEnd], 'YData', [yStart yEnd])
		set(gca,'Units','pixels');
		% daspect(ax,[1 1 1]);      % one data unit = same length x and y
		% axis(ax, 'off');
	end
end

% Find the min ratios of pixels per distance
minXYZratioDistancePerPixel = [inf inf inf];
for kth_image = 1:Nimages
	if ~isempty(images{kth_image})
		ax = subplot(3,3,kth_image);

		thisImage = images{kth_image};
		pixelsInX = size(thisImage,2)-1; % X in image
		pixelsInY = size(thisImage,1)-1; % Y in image


		% Find the distances spanned by these pixels.
		% Format: [left bottom width height]
		p = get(ax,'Position');

		ratioDistancePerPixelX =  p(3)/pixelsInX;
		ratioDistanceperPixelY =  p(4)/pixelsInY;	

		dimensionsToCheck = find(viewDimensionDirections(kth_image,:)~=0);
		firstDimension = dimensionsToCheck(1);
		secondDimension = dimensionsToCheck(2);

		% Keep the smallest distance per pixel - this will be the most
		% compact view
		if minXYZratioDistancePerPixel(firstDimension)>ratioDistancePerPixelX
			minXYZratioDistancePerPixel(firstDimension)=ratioDistancePerPixelX;
		end
		if minXYZratioDistancePerPixel(secondDimension)>ratioDistanceperPixelY
			minXYZratioDistancePerPixel(secondDimension)=ratioDistanceperPixelY;
		end

	end
end

minRatioDistanceperPixel = min(minXYZratioDistancePerPixel);
resizedDistancePerPixel = rescalingFactor*minRatioDistanceperPixel;

for kth_image = 1:Nimages
	if ~isempty(images{kth_image})
		ax = subplot(3,3,kth_image);

		thisImage = images{kth_image};
		pixelsInX = size(thisImage,2)-1; % X in image
		pixelsInY = size(thisImage,1)-1; % Y in image

		newRangeX = floor(pixelsInX*resizedDistancePerPixel);
		newRangeY = floor(pixelsInY*resizedDistancePerPixel);

		% Resize the axes
		p = get(ax,'Position');
		centerP = [p(1)+p(3)/2 p(2)+p(4)/2];
		newBottomCorner = centerP -[newRangeX newRangeY]/2;
		newP = [newBottomCorner newRangeX newRangeY];
		
		set(ax,'Position',newP);
		title(sprintf('%s',viewNames{kth_image}))

	end
end
end % Ends minRatioDistanceperPixel

%% fcn_INTERNAL_alignSubplots
function fcn_INTERNAL_alignSubplots(workingFig, viewNames, viewNumbers, minRatioDistanceperPixel, imageDimensionToAlign)

axesInThisFigure = get(workingFig,'Children');
existingTitles = cell(length(axesInThisFigure),1);
for ith_subplot = 1:length(axesInThisFigure)
	existingTitles{ith_subplot,1} = axesInThisFigure(ith_subplot).Title.String;
end

allClickedPoints = nan(9,2);

%%%%
% Have the user select features to match
for ith_view = 1:length(viewNames)
	if ~isempty(viewNames{ith_view}) && any(ith_view==viewNumbers)

		% titleToMatch = axesInThisFigure(ith_view).Title.String;
		% thisIndex = find(strcmp(titleToMatch,viewNames),1);

		viewToMatch = viewNames{ith_view};
		axisIndex = find(strcmp(existingTitles,viewToMatch),1);
		axisHandle = axesInThisFigure(axisIndex);

		if imageDimensionToAlign==1
			directionString = 'ImageX';
		elseif imageDimensionToAlign==2
			directionString = 'ImageY';

			% Flip axis and image to correct orientation?
			orientationString = get(axisHandle,'YDir');
			if strcmpi(orientationString,'reverse')
				set(axisHandle,'YDir', 'normal');
				tempImage = get(axisHandle,'Children');
				tempArray = tempImage.CData;
				fixedArray = flipud(tempArray);
				tempImage.CData = fixedArray;
				set(axisHandle,'Children',tempImage);
			end
		else
			error('unrecognized dimension: %.0f',imageDimensionToAlign);
		end
		
		queryTitle = sprintf('Select a feature in this view to align this column in the %s direction',directionString);
		thisTitle = get(axisHandle,'Title');
		set(thisTitle,'String',queryTitle);

		[~, figCoordinates] = fcn_INTERNAL_pickPixelsInSubplot(axisHandle);

		% Set the title back to prior value
		set(thisTitle,'String',viewToMatch);

		allClickedPoints(ith_view,:) = figCoordinates(end,:);

		% figure(figAllViews);
		% subplot(3,3,ith_view);
		% imshow(temp, 'XData',[1 size(temp,2)], 'YData',[1 size(temp,1)]);
		% title(sprintf('%s',viewNames{ith_view}));
	end
end

%%%%
% Find average point and sign of corrections
goodClickedPoints = allClickedPoints(~all(isnan(allClickedPoints),2),:);
averagePoint = round(mean(goodClickedPoints(:,imageDimensionToAlign),1));

%%%%%
% Apply correction
for ith_view = 1:length(viewNames)
	if ~isempty(viewNames{ith_view}) && any(ith_view==viewNumbers)

		% titleToMatch = axesInThisFigure(ith_view).Title.String;
		% thisIndex = find(strcmp(titleToMatch,viewNames),1);

		viewToMatch = viewNames{ith_view};
		axisIndex = find(strcmp(existingTitles,viewToMatch),1);
		axisHandle = axesInThisFigure(axisIndex);

		oldPosition = get(axisHandle,'Position');
		newPosition = oldPosition;

		pixelOffset = allClickedPoints(ith_view, imageDimensionToAlign) - averagePoint;
		newPosition(imageDimensionToAlign) = oldPosition(imageDimensionToAlign) - pixelOffset*minRatioDistanceperPixel;

		set(axisHandle,'Position',newPosition);
	end
end
end % Ends fcn_INTERNAL_alignSubplots


%% syncZoomByFigurePoints
function syncZoomByFigurePoints(fig, axesList, figPoints, units)
% syncZoomByFigurePoints Synchronize zoom across axes using figure coords.
%   syncZoomByFigurePoints(fig, axesList, figPoints, units)
%   - fig: figure handle
%   - axesList: vector of axes handles (one per subplot)
%   - figPoints: Nx2 array of [x y] points in figure coordinates (matching axesList order)
%   - units: 'pixels' (default) or 'normalized' - units for figPoints
%
% Example:
%   f = figure; t = tiledlayout(2,3);
%   axs = gobjects(6,1);
%   for k=1:6, axs(k)=nexttile(k); imshow(rand(200)); end
%   % define focal points in figure pixels (e.g. center of each axes)
%   f.Units = 'pixels'; fp = zeros(6,2);
%   for k=1:6, p = axs(k).Position; fp(k,:) = [p(1)+p(3)/2, p(2)+p(4)/2]; end
%   syncZoomByFigurePoints(f, axs, fp, 'normalized');  % use normalized if points are normalized

if nargin<4 || isempty(units), units = 'normalized'; end
validateattributes(fig, {'matlab.ui.Figure'},{'scalar'});
n = numel(axesList);
if size(figPoints,1) ~= n, error('figPoints must match number of axes'); end

% Convert figPoints into the figure Units requested
oldFigUnits = fig.Units;
cleanupFigUnits = onCleanup(@() set(fig,'Units',oldFigUnits));
fig.Units = units;

% Precompute per-axes mapping function from figure point -> axes data coordinate
mapFigToData = cell(n,1);
for k = 1:n
    ax = axesList(k);
    % We'll compute mapping using pixels within figure units chosen above:
    % 1) Get axes position in the same fig units
    figPos = fig.Position; %#ok<NASGU>
    axUnitsOld = ax.Units;
    ax.Units = units;
    axPos = ax.Position; % [left bottom width height] in fig units
    ax.Units = axUnitsOld;

    % Gather image XData/YData if image present (use first image), otherwise assume default axes data coords
    im = findobj(ax,'Type','image','-and','Visible','on');
    if ~isempty(im)
        im = im(1);
        xd = get(im,'XData'); yd = get(im,'YData');
        % Normalize to two-element vectors for mapping first/last pixel centers
        if numel(xd)==2, xDataVec = xd; else xDataVec = [1 size(im.CData,2)]; end
        if numel(yd)==2, yDataVec = yd; else yDataVec = [1 size(im.CData,1)]; end
    else
        % use axes current limits as data extents
        xDataVec = xlim(ax);
        yDataVec = ylim(ax);
    end

    % Create mapping closure: figPoint -> data coordinate in this axes
    axLeft = axPos(1); axBottom = axPos(2); axW = axPos(3); axH = axPos(4);
    mapFigToData{k} = @(figPt) localFigToData(figPt, axLeft, axBottom, axW, axH, xDataVec, yDataVec);
end

% Store original limits for computing relative scale
origLimits = cell(n,1);
for k=1:n
    origLimits{k} = [xlim(axesList(k)), ylim(axesList(k))];
end

% Guard to prevent recursive updates
isUpdating = false;

% Create zoom object and set callback
z = zoom(fig);
set(z, 'ActionPostCallback', @(obj,ev) zoomPostCallback(obj, ev));
set(z, 'Enable', 'on');

% Return a cleanup function in case caller wants to stop synchronization:
cleanupHandle = onCleanup(@() cleanupFunc(z));

    function cleanupFunc(zobj)
        try
            set(zobj, 'ActionPostCallback', []);
            set(zobj, 'Enable', 'off');
        catch
        end
    end

    function zoomPostCallback(~, ev)
        if isUpdating, return; end
        isUpdating = true;
        try
            srcAx = ev.Axes; % axes that was zoomed
            % find index of srcAx in axesList
            idx = find(axesList==srcAx,1);
            if isempty(idx)
                % if zoom happened on an axes we didn't list, ignore
                isUpdating = false; return;
            end

            % compute scale factors relative to original limits (use current limits / previous limits)
            newXLim = xlim(srcAx); newYLim = ylim(srcAx);
            oldXLim = origLimits{idx}(1:2); oldYLim = origLimits{idx}(3:4);

            % Avoid division by zero
            if diff(oldXLim)==0 || diff(oldYLim)==0
                isUpdating = false; return;
            end
            sx = diff(newXLim)/diff(oldXLim);
            sy = diff(newYLim)/diff(oldYLim);

            % For each axes compute its own center in data coords from the provided figPoints
            for k2 = 1:n
                ax2 = axesList(k2);
                % Map user-specified fig point into this axes data coordinates
                center = mapFigToData{k2}(figPoints(k2,:));
                cx = center(1); cy = center(2);

                % Use original limits for computing half sizes (so zoom ratio is relative to orig)
                orig = origLimits{k2};
                hx = diff(orig(1:2))/2;
                hy = diff(orig(3:4))/2;

                % New half ranges
                newHx = hx * sx;
                newHy = hy * sy;

                % Set limits centered at the focal point
                newXL = [cx - newHx, cx + newHx];
                newYL = [cy - newHy, cy + newHy];

                % Apply limits
                xlim(ax2, newXL);
                ylim(ax2, newYL);
            end

        catch ME
            warning('syncZoomByFigurePoints:callbackError','%s',ME.message);
        end
        isUpdating = false;
    end

    function ptData = localFigToData(figPt, axLeft, axBottom, axW, axH, xDataVec, yDataVec)
        % figPt: [x y] in same units as axLeft/axW
        % map to normalized [0..1] inside axes
        fx = (figPt(1) - axLeft) / axW;
        fy = (figPt(2) - axBottom) / axH;
        % clamp
        fx = min(max(fx,0),1);
        fy = min(max(fy,0),1);
        % map to data: linear interpolation from XData/YData endpoints
        x = xDataVec(1) + fx * (xDataVec(2) - xDataVec(1));
        y = yDataVec(1) + fy * (yDataVec(2) - yDataVec(1));
        ptData = [x y];
    end
end



function figPt = dataToFig(fig, ax, dataPt, figUnits)
% dataToFig Convert a data point in axes to figure coordinates.
%   figPt = dataToFig(fig, ax, dataPt)           % default 'pixels'
%   figPt = dataToFig(fig, ax, dataPt, 'normalized')
%   dataPt: [x y] in axes data coordinates
%   figPt:  [x y] in figure units specified by figUnits
if nargin<4 || isempty(figUnits), figUnits = 'pixels'; end

% Save/restore units
oldFigUnits = fig.Units; oldAxUnits = ax.Units;
cleanup = onCleanup(@() set(fig,'Units',oldFigUnits) && set(ax,'Units',oldAxUnits));
fig.Units = figUnits;
ax.Units  = figUnits;

% Axes position in figure units
axPos = ax.Position;           % [left bottom width height]

% Determine data extents (prefer image XData/YData if present)
im = findobj(ax,'Type','image','-depth',1);
if ~isempty(im)
    im = im(1);
    xd = get(im,'XData'); yd = get(im,'YData');
    % ensure two-element ranges
    if numel(xd)~=2, xd = [min(xd(:)) max(xd(:))]; end
    if numel(yd)~=2, yd = [min(yd(:)) max(yd(:))]; end
else
    xd = xlim(ax); yd = ylim(ax);
end

% fraction inside axes (0..1)
fx = (dataPt(1) - xd(1)) / (xd(2) - xd(1));
fy = (dataPt(2) - yd(1)) / (yd(2) - yd(1));

% account for YDir
if strcmpi(ax.YDir,'reverse')
    fy = 1 - fy;
end

% clamp
fx = min(max(fx,0),1);
fy = min(max(fy,0),1);

% map to figure coordinates
figX = axPos(1) + fx * axPos(3);
figY = axPos(2) + fy * axPos(4);
figPt = [figX figY];
end