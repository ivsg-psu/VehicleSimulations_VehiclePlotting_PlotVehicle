% script_test_fcn_PlotVehicle_fillParametersFromName.m
% tests fcn_PlotVehicle_fillParametersFromName.m

% REVISION HISTORY:
%
% 2022_07_23 by Sean Brennan, sbrennan@psu.edu
% - In
%   % * Wrote the code originally, using script_test_fcn_Laps_break+DataIntoLapIndices
% 
% 2025_07_03 by Sean Brennan, sbrennan@psu.edu
% - standardized headers on all test scripts

% TO-DO:
%
% 2025_11_21 by Sean Brennan, sbrennan@psu.edu
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

vehicleNameString = '2017_Ford_Transit_ConnectXLTWagon';
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
vehicleParameters = fcn_PlotVehicle_fillParametersFromName(vehicleNameString, (figNum));

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
% vehicleParameters = fcn_PlotVehicle_fillParametersFromName(tireCodeCharacters, ([]));
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
% vehicleParameters = fcn_PlotVehicle_fillParametersFromName(tireCodeCharacters, (-1));
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
% 	vehicleParameters = fcn_PlotVehicle_fillParametersFromName(tireCodeCharacters, ([]));
% 
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
% 
% 	% Call the function
% 	vehicleParameters = fcn_PlotVehicle_fillParametersFromName(tireCodeCharacters, (-1));
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

