function fcn_PlotTire_plotTireOverhead(sectionWidth_m, radius_m, varargin)
% plotTireOverhead  Plot overhead (plan) view of a tire as an annulus.
%   plotTireOverhead(sectionWidth_m, radius_m) plots annulus with outer
%   radius = radius_m and inner radius = max(0, radius_m - sectionWidth_m).
%
%   Name-Value pairs:
%     'RimRadius'           - inner (rim) radius in meters (overrides mapping)
%     'UseSectionAsRadial'  - logical. If true, inner = radius - sectionWidth (default false)
%     'WidthToRadialScale'  - scale factor to convert lateral width -> radial thickness (default 0.6)
%     'FaceColor'           - color of tire band (default [0.15 0.15 0.15])
%     'EdgeColor'           - edge color (default 'none')
%
%   Example:
%     plotTireOverhead(0.205, 0.315)                     % maps section width to radial band
%     plotTireOverhead(0.205, 0.315, 'RimRadius', 0.1)   % use known rim radius

% Parse inputs
p = inputParser;
addRequired(p, 'sectionWidth_m', @(x) isnumeric(x) && isscalar(x) && x>0);
addRequired(p, 'radius_m', @(x) isnumeric(x) && isscalar(x) && x>0);
addParameter(p, 'RimRadius', [], @(x) isempty(x) || (isnumeric(x) && isscalar(x) && x>=0));
addParameter(p, 'UseSectionAsRadial', false, @(x) islogical(x) && isscalar(x));
addParameter(p, 'WidthToRadialScale', 0.6, @(x) isnumeric(x) && isscalar(x) && x>0);
addParameter(p, 'FaceColor', [0.15 0.15 0.15], @(x) (isnumeric(x) && numel(x)==3) || ischar(x) || isstring(x));
addParameter(p, 'EdgeColor', 'none', @(x) ischar(x) || isstring(x) || isempty(x) || (isnumeric(x) && numel(x)==3));
parse(p, sectionWidth_m, radius_m, varargin{:});
sW = p.Results.sectionWidth_m;
R = p.Results.radius_m;
rimR = p.Results.RimRadius;
useRadial = p.Results.UseSectionAsRadial;
scale = p.Results.WidthToRadialScale;
fc = p.Results.FaceColor;
ec = p.Results.EdgeColor;

% Determine inner radius
if ~isempty(rimR)
    innerR = max(0, rimR);
else
    if useRadial
        innerR = max(0, R - sW);
    else
        radialThickness = sW * scale;
        innerR = max(0, R - radialThickness);
    end
end
outerR = R;

% Safety check
if innerR >= outerR
    error('Computed inner radius >= outer radius. Check inputs or parameters.');
end

% Build annulus patch
n = 360;
theta = linspace(0,2*pi,n);
xOuter = outerR * cos(theta);
yOuter = outerR * sin(theta);
xInner = innerR * cos(fliplr(theta));
yInner = innerR * sin(fliplr(theta));
x = [xOuter, xInner];
y = [yOuter, yInner];

% Plot
figure('Color','w');
patch(x, y, fc, 'EdgeColor', ec);
axis equal; hold on;
xlabel('meters'); ylabel('meters');
title(sprintf('Tire Overhead: section width = %.3f m, outer radius = %.3f m', sW, R));

% Draw rim circle if rimR provided or draw thin inner ring outline for clarity
plot(innerR*cos(theta), innerR*sin(theta), 'Color', [0.6 0.6 0.6], 'LineWidth', 1);

% Draw center marker and annotate dimensions
plot(0,0,'k+','MarkerSize',8,'LineWidth',1.2);
text(outerR*0.6, 0, sprintf('Outer R = %.3f m', outerR), 'HorizontalAlignment','center');
text(innerR*0.6, 0.08*outerR, sprintf('Inner R = %.3f m', innerR), 'HorizontalAlignment','center');

% Add scale bar
sb_len = outerR*0.2;
xb = [-outerR+0.05*outerR, -outerR+0.05*outerR+sb_len];
yb = [-outerR+0.05*outerR, -outerR+0.05*outerR];
plot(xb, yb, 'k-', 'LineWidth', 2);
text(mean(xb), yb(1)-0.03*outerR, sprintf('%.2f m', sb_len), 'HorizontalAlignment','center');

xlim([-outerR-0.1*outerR, outerR+0.1*outerR]);
ylim([-outerR-0.1*outerR, outerR+0.1*outerR]);
set(gca,'FontSize',11);
hold off;
end
