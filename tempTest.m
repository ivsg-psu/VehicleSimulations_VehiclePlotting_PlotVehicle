figure;

% Load image
I = imread('peppers.png');        % m×n×3
[m,n,~] = size(I);

% Desired data ranges for the image in X and Z
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
    'CData', flipud(I), ...             % CData: color image (flip if needed)
    'FaceColor', 'texturemap', ...
    'EdgeColor', 'none', 'FaceAlpha',0.5);

hold(ax, 'on');

% Example 3-D data on top of the image
t = linspace(0, 2*pi, 200);
xPlot = linspace(xMin, xMax, 200);
yPlot = 0.5*sin(3*t) + 1;                 % varying y (above the image)
zPlot = linspace(zMin, zMax, 200);
plot3(ax, xPlot, yPlot, zPlot, 'r-', 'LineWidth', 2);

axis(ax, 'equal');                        % keep aspect
xlabel('X'); ylabel('Y'); zlabel('Z');
view(3);
grid on;
uistack(hImSurf, 'bottom');               % ensure image is underneath

startingXY = [];
pathXY = fcn_GetUserInputPath_getUserInputPath((startingXY),(gcf));
