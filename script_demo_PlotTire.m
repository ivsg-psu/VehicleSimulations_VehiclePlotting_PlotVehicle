
%% Introduction to and Purpose of the Code
% This is the explanation of the code that can be found by running
%
%       script_demo_PlotTire.m
% 
% This is a script to demonstrate the functions within the PlotTire code
% library. This code repo is typically located at:
%
% https://github.com/ivsg-psu/VehicleSimulations_VehiclePlotting_PlotTire
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu
%
% The purpose of the code is to plot tires for animating vehicle dynamics.
% The core functions of the code are to:
%
% * Convert tire sidewall numberings into tire dimensions
% * Store key tire dimensions within tireParameters structure
% * Generate XY or XYZ data for tires aligned with a local axis
% * Plot a tire's position at a given position/orientation by performing
%   rotations on XY / XYZ data as needed.

% REVISION HISTORY:
% 
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - First creation of the repo
% 
% 2026_02_10 by Sean Brennan, sbrennan@psu.edu
% - In script_demo_VD
%   % * Added check if repo is ready for release
% - Added roundedRectangle function
% - Added test cases for all functions
% - Deprecated unused functions
% - Fixed fcn_PlotTire_roundedRectangle to have correct standard
%   % format
% (new release)

% TO-DO:
% - 2026_02_08 by Sean Brennan, sbrennan@psu.edu
%   % - Add motion blur model, maybe?

%% Make sure we are running out of root directory
st = dbstack; 
thisFile = which(st(1).file);
[filepath,name,ext] = fileparts(thisFile);
cd(filepath);

%%% START OF STANDARD INSTALLER CODE %%%%%%%%%

%% Clear paths and folders, if needed
if 1==1
    clear flag_PlotTire_Folders_Initialized
end

if 1==0
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;
end

if 1==0
    % Resets all paths to factory default
    restoredefaultpath;
end

%% Install dependencies
% Define a universal resource locator (URL) pointing to the repos of
% dependencies to install. Note that DebugTools is always installed
% automatically, first, even if not listed:
clear dependencyURLs dependencySubfolders
ith_repo = 0;

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

ith_repo = ith_repo+1;
dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_PathTools_GetUserInputPath';
dependencySubfolders{ith_repo} = {''};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_GeomClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','Data'};

% ith_repo = ith_repo+1;
% dependencyURLs{ith_repo} = 'https://github.com/ivsg-psu/PathPlanning_MapTools_MapGenClassLibrary';
% dependencySubfolders{ith_repo} = {'Functions','testFixtures','GridMapGen'};



%% Do we need to set up the work space?
if ~exist('flag_PlotTire_Folders_Initialized','var')
    
    % Clear prior global variable flags
    clear global FLAG_*

    % Navigate to the Installer directory
    currentFolder = pwd;
    cd('Installer');
    % Create a function handle
    func_handle = @fcn_DebugTools_autoInstallRepos;

    % Return to the original directory
    cd(currentFolder);

    % Call the function to do the install
    func_handle(dependencyURLs, dependencySubfolders, (0), (-1));

    % Add this function's folders to the path
    this_project_folders = {...
        'Functions','Data'};
    fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders)

    flag_PlotTire_Folders_Initialized = 1;
end

%%% END OF STANDARD INSTALLER CODE %%%%%%%%%

%% Set environment flags for input checking in PlotTire library
% These are values to set if we want to check inputs or do debugging
setenv('MATLABFLAG_PLOTTIRE_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_PLOTTIRE_FLAG_DO_DEBUG','0');

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions
% Location for Test Track base station
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');

%% Check if repo is ready for release
if 1==0
	figNum = 999999;
	repoShortName = '_PlotTire_';
	fcn_DebugTools_testRepoForRelease(repoShortName, (figNum));
end

%% Start of Demo Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____ _             _            __   _____                          _____          _
%  / ____| |           | |          / _| |  __ \                        / ____|        | |
% | (___ | |_ __ _ _ __| |_    ___ | |_  | |  | | ___ _ __ ___   ___   | |     ___   __| | ___
%  \___ \| __/ _` | '__| __|  / _ \|  _| | |  | |/ _ \ '_ ` _ \ / _ \  | |    / _ \ / _` |/ _ \
%  ____) | || (_| | |  | |_  | (_) | |   | |__| |  __/ | | | | | (_) | | |___| (_) | (_| |  __/
% |_____/ \__\__,_|_|   \__|  \___/|_|   |_____/ \___|_| |_| |_|\___/   \_____\___/ \__,_|\___|
%
%
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Start%20of%20Demo%20Code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Welcome to the demo code for the PlotTire library!')

%% fcn_PlotTire_parseTireSidewallCode and fcn_PlotTire_plotTireDimensions
figNum = 10001;
titleString = sprintf('DEMO: fcn_PlotTire_parseTireSidewallCode and fcn_PlotTire_plotTireDimensions');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

tireCodeCharacters = '205/55R16 91V';

% Call the function
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (figNum));

fcn_PlotTire_plotTireDimensions(tireParameters,(figNum));

%% fcn_PlotTire_roundedRectangle
figNum = 10002;
titleString = sprintf('DEMO: fcn_PlotTire_roundedRectangle');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = 'ellipse';
cornerParams = [L/4 W/20];
NcornerPoints = 24;

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), (figNum));

%% fcn_PlotTire_fillTireLocalXY and fcn_PlotTire_plotTireXY
figNum = 10003;
titleString = sprintf('DEMO: fcn_PlotTire_fillTireLocalXY');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
tireCodeCharacters = '205/55R16 91V';
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));


for displayModel = 1:3
	subplot(1,3,displayModel);
	% Call the function
	cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (figNum));
	title(sprintf('Model %.0f, %.0f points',displayModel, size(cellArrayOfPoints{displayModel,1},1)));
end


%% fcn_PlotTire_poseTireLocalToGlobal
figNum = 10004;
titleString = sprintf('DEMO: fcn_PlotTire_poseTireLocalToGlobal');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
tireCodeCharacters = '205/55R16 91V';
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
displayModel = 3;
cellArrayOfLocalXYPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (-1));

% Define the transformation parameters
XYZ = [0.75 0 0]; % Example translation
rollPitchYaw = [0 0 0*pi/180]; % Example rotation

% Call the function
cellArrayOfGlobalPoints1 = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw,  (figNum));

% Define the transformation parameters
XYZ = [-0.75 0 0]; % Example translation
rollPitchYaw = [0 0 0*pi/180]; % Example rotation

% Call the function
cellArrayOfGlobalPoints2 = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw,  (figNum));

% Define the transformation parameters
XYZ = [0.75 2.5 0]; % Example translation
rollPitchYaw = [0 0 30*pi/180]; % Example rotation

% Call the function
cellArrayOfGlobalPoints3 = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw,  (figNum));

% Define the transformation parameters
XYZ = [-0.75 2.5 0]; % Example translation
rollPitchYaw = [0 0 30*pi/180]; % Example rotation

% Call the function
cellArrayOfGlobalPoints4 = fcn_PlotTire_poseTireLocalToGlobal(cellArrayOfLocalXYPoints, XYZ, rollPitchYaw,  (figNum));

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

%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

