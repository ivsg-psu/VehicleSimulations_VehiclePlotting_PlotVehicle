% script_test_fcn_PlotTire_roundedRectangle.m
% tests fcn_PlotTire_roundedRectangle.m

% REVISION HISTORY:
%
% 2026_02_08 by Sean Brennan, sbrennan@psu.edu
% - In script_test_fcn_PlotTire_roundedRectangle
%   % * Wrote the code originally, using fcn_PlotTire_fillTireLocalXY


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

%% DEMO case: basic example of elliptical corners
figNum = 10001;
titleString = sprintf('DEMO case: basic example of elliptical corners');
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

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

% Check variable values
% Too many to check

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: basic example of Circular corners radius 0.08
figNum = 10002;
titleString = sprintf('DEMO case: basic example of Circular corners radius 0.08');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = 'circle';
cornerParams = 0.08;
NcornerPoints = 24;

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

% Check variable values
% Too many to check

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));


%% DEMO case: basic example of Custom corner shape (function handle)
figNum = 10003;
titleString = sprintf('DEMO case: basic example of Custom corner shape (function handle)');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Custom corner shape (function handle): Define a function with signature
% pts = myCorner(cx,cy,tVec,params) that returns Nx2 points; pass handle
% and params struct with params.Off = [ox oy]: XY =
% roundedRectangle(1,0.6,@myCorner, params, 20);

% Fill parameters
L = 0.4;
W = 1.0;
clear cornerParams
cornerParams.Off = [0.1 0.05];
cornerParams.a = 0.1;
cornerParams.b = 0.05;
cornerFunc = @(cx,cy,tVec, cornerParams) [cx + cornerParams.a*cos(tVec(:)), cy + cornerParams.b*sin(tVec(:))];
cornerShape = cornerFunc;
NcornerPoints = 24;

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

% Check variable values
% Too many to check

% Make sure plot opened up
assert(isequal(get(gcf,'Number'),figNum));

%% DEMO case: basic example using defaults
figNum = 10004;
titleString = sprintf('DEMO case: basic example using defaults');
fprintf(1,'Figure %.0f: %s\n',figNum, titleString);
figure(figNum); clf;

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = [];
cornerParams = [];
NcornerPoints = [];

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), (figNum));

sgtitle(titleString, 'Interpreter','none');

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

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
fprintf(1,'Figure: 8XXXXXX: FAST mode cases\n');

%% Basic example - NO FIGURE
figNum = 80001;
fprintf(1,'Figure: %.0f: FAST mode, empty figNum\n',figNum);
figure(figNum); close(figNum);

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = 'ellipse';
cornerParams = [0.1 0.05];
NcornerPoints = 24;

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), ([]));

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

% Check variable values
% Too many to check

% Check variable values
% Too many to check
% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Basic fast mode - NO FIGURE, FAST MODE
figNum = 80002;
fprintf(1,'Figure: %.0f: FAST mode, figNum=-1\n',figNum);
figure(figNum); close(figNum);

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = 'ellipse';
cornerParams = [0.1 0.05];
NcornerPoints = 24;

% Call the function
XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
	(cornerShape), (cornerParams), (NcornerPoints), (-1));

% Check variable types
assert(isnumeric(XYpoints));

% Check variable sizes
assert(size(XYpoints,1)>=2); 
assert(size(XYpoints,2)==2); 

% Check variable values
% Too many to check

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


%% Compare speeds of pre-calculation versus post-calculation versus a fast variant
figNum = 80003;
fprintf(1,'Figure: %.0f: FAST mode comparisons\n',figNum);
figure(figNum);
close(figNum);

% Fill parameters
L = 0.4;
W = 1.0;
cornerShape = 'ellipse';
cornerParams = [0.1 0.05];
NcornerPoints = 24;

Niterations = 5;

% Do calculation without pre-calculation
tic;
for ith_test = 1:Niterations

	% Call the function
	XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
		(cornerShape), (cornerParams), (NcornerPoints), ([]));

end
slow_method = toc;

% Do calculation with pre-calculation, FAST_MODE on
tic;
for ith_test = 1:Niterations

	% Call the function
	XYpoints = fcn_PlotTire_roundedRectangle(L, W, ...
		(cornerShape), (cornerParams), (NcornerPoints), (-1));

end
fast_method = toc;

% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));

% Plot results as bar chart
figure(373737);
clf;
hold on;

X = categorical({'Normal mode','Fast mode'});
X = reordercats(X,{'Normal mode','Fast mode'}); % Forces bars to appear in this exact order, not alphabetized
Y = [slow_method fast_method ]*1000/Niterations;
bar(X,Y)
ylabel('Execution time (Milliseconds)')


% Make sure plot did NOT open up
figHandles = get(groot, 'Children');
assert(~any(figHandles==figNum));


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

