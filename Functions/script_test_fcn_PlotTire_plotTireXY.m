% script_test_fcn_PlotTire_plotTireXY.m
% tests fcn_PlotTire_plotTireXY.m

% REVISION HISTORY:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotTire_plotTireXY
%   % * Wrote the code originally, using script_test_fcn_Laps_break+DataIntoLapIndices
%
% 2026_02_10 by Sean Brennan, sbrennan@psu.edu
% - In fcn_PlotTire_plotTireXY
%   % * Added rounded-corner rectangle (model 2) form

% TO-DO:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
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

% Fill parameters
tireCodeCharacters = '205/55R16 91V';
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
displayModel = [];

% Call the function
cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPoints));

% Check variable sizes
assert(size(cellArrayOfPoints,1)==1); 
assert(size(cellArrayOfPoints,2)==1); 

% Check variable values
% Too many to check

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: model 1 to 2
figNum = 10002;
titleString = sprintf('DEMO case: model = 2');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
tireCodeCharacters = '205/55R16 91V';
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));


for displayModel = 1:2
	subplot(1,2,displayModel);
	% Call the function
	cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (figNum));
	title(sprintf('Model %.0f, %.0f points',displayModel, size(cellArrayOfPoints{displayModel,1},1)));
end

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPoints));

% Check variable sizes
assert(size(cellArrayOfPoints,1)==2); 
assert(size(cellArrayOfPoints,2)==1); 

% Check variable values
% Too many to check

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: plotting models 1 to 3
figNum = 10003;
titleString = sprintf('DEMO case: plotting models 1 to 3');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
tireCodeCharacters = '205/55R16 91V';
tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
displayModel = 3;
cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (-1));

for displayModel = 1:3
	subplot(1,3,displayModel);

	tempCellArray = cell(displayModel,1);
	for ith_cell = 1:displayModel
		tempCellArray{ith_cell,1} = cellArrayOfPoints{ith_cell,1};
	end
	
	% Call the function
	cellArrayOfPlotHandles = fcn_PlotTire_plotTireXY(tempCellArray, (figNum));
	title(sprintf('Model %.0f, %.0f points',displayModel, size(cellArrayOfPoints{displayModel,1},1)));
end

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(iscell(cellArrayOfPlotHandles));

% Check variable sizes
assert(size(cellArrayOfPlotHandles,1)==3); 
assert(size(cellArrayOfPlotHandles,2)==1); 

% Check variable values
% Too many to check

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
fprintf(1,'Figure: 8XXXXXX: NO FAST mode cases because this is a plotting function\n');

% %% Basic example - NO FIGURE
% figNum = 80001;
% fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
% figure(figNum); close(figNum);
% 
% % Fill parameters
% tireCodeCharacters = '205/55R16 91V';
% tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
% displayModel = [];
% 
% % Call the function
% cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), ([]));
% 
% % Check variable types
% assert(iscell(cellArrayOfPoints));
% 
% % Check variable sizes
% assert(size(cellArrayOfPoints,1)==1); 
% assert(size(cellArrayOfPoints,2)==1); 
% 
% % Check variable values
% % Too many to check
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
% % Fill parameters
% tireCodeCharacters = '205/55R16 91V';
% tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
% displayModel = [];
% 
% % Call the function
% cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (-1));
% 
% % Check variable types
% assert(iscell(cellArrayOfPoints));
% 
% % Check variable sizes
% assert(size(cellArrayOfPoints,1)==1); 
% assert(size(cellArrayOfPoints,2)==1); 
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
% % Fill parameters
% tireCodeCharacters = '205/55R16 91V';
% tireParameters = fcn_PlotTire_parseTireSidewallCode(tireCodeCharacters, (-1));
% displayModel = [];
% 
% Niterations = 5;
% 
% % Do calculation without pre-calculation
% tic;
% for ith_test = 1:Niterations
% 
% 	% Call the function
% 	cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), ([]));
% 
% end
% slow_method = toc;
% 
% % Do calculation with pre-calculation, FAST_MODE on
% tic;
% for ith_test = 1:Niterations
% 
% 	% Call the function
% 	cellArrayOfPoints = fcn_PlotTire_fillTireLocalXY(tireParameters, (displayModel), (-1));
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
% 

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

