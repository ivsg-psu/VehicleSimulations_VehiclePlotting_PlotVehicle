function fcn_PlotTire_plotTireOverheadWithTread(sectionWidth_m, radius_m, varargin)
% plotTireOverheadWithTread  Overhead tire with simple tread patterns
%   plotTireOverheadWithTread(sectionWidth_m, radius_m, Name,Value)
%   Name-Value pairs:
%     'RimRadius'      - inner radius (m), default computed from sectionWidth mapping
%     'Pattern'        - 'none' (default), 'circumferential', 'block', 'chevron'
%     'NumElements'    - number of repeats around circumference (default 40)
%     'GrooveWidth'    - groove width (m) for circumferential (default 0.003)
%     'BlockDepth'     - radial depth of blocks (m) (default 0.01)
%     'OrientAngle'    - global rotation (deg) of pattern (default 0)
%     'FaceColor'/'EdgeColor' - colors for tire band
%
%   Example:
%     plotTireOverheadWithTread(0.205,0.315,'Pattern','block','NumElements',48)

% Parse inputs
p = inputParser;
addRequired(p,'sectionWidth_m',@(x)isnumeric(x)&&isscalar(x)&&x>0);
addRequired(p,'radius_m',@(x)isnumeric(x)&&isscalar(x)&&x>0);
addParameter(p,'RimRadius',[],@(x) isempty(x) || (isnumeric(x)&&isscalar(x)&&x>=0));
addParameter(p,'Pattern','none',@(x)ischar(x)||isstring(x));
addParameter(p,'NumElements',40,@(x)isnumeric(x)&&isscalar(x)&&x>=1);
addParameter(p,'GrooveWidth',0.003,@isnumeric);
addParameter(p,'BlockDepth',0.01,@isnumeric);
addParameter(p,'OrientAngle',0,@isnumeric);
addParameter(p,'FaceColor',[0.12 0.12 0.12]);
addParameter(p,'EdgeColor','none');
parse(p,sectionWidth_m,radius_m,varargin{:});

sW = p.Results.sectionWidth_m;
R = p.Results.radius_m;
rimR = p.Results.RimRadius;
pattern = char(p.Results.Pattern);
N = round(p.Results.NumElements);
gw = p.Results.GrooveWidth;
bd = p.Results.BlockDepth;
rot = deg2rad(p.Results.OrientAngle);
fc = p.Results.FaceColor;
ec = p.Results.EdgeColor;

% Map section width to annulus thickness (same mapping as before)
if isempty(rimR)
    radialThickness = sW * 0.6;  % heuristic mapping
    innerR = max(0, R - radialThickness);
else
    innerR = max(0, rimR);
end
outerR = R;
if innerR >= outerR, error('inner radius >= outer radius'); end

% Create base annulus
theta = linspace(0,2*pi,720);
xOuter = outerR * cos(theta);
yOuter = outerR * sin(theta);
xInner = innerR * cos(fliplr(theta));
yInner = innerR * sin(fliplr(theta));
figure('Color','w'); hold on; axis equal;
patch([xOuter, xInner], [yOuter, yInner], fc, 'EdgeColor', ec);

% Draw rim outline
plot(innerR*cos(theta), innerR*sin(theta), 'Color',[0.6 0.6 0.6], 'LineWidth',1);

% Compute element angular pitch and radial extents
circumf = 2*pi* (innerR + outerR)/2; % approximate midline circumference
pitch = 2*pi / N;

switch lower(pattern)
    case 'none'
        % nothing more
    case 'circumferential'
        % Draw N narrow grooves (radial direction are lines drawn across band)
        for k = 0:N-1
            th = k*pitch + rot;
            % Offset groove as a thin arc at multiple radii to show continuous groove
            rVec = linspace(innerR, outerR, 4);
            xg = rVec .* cos(th);
            yg = rVec .* sin(th);
            plot(xg, yg, 'Color',[0.1 0.1 0.1], 'LineWidth', max(0.5, gw*200)); % scale linewidth heuristically
        end
    case 'block'
        % Place rectangular blocks centered on mid-radius, oriented tangentially
        midR = (innerR + outerR)/2;
        blockAngularWidth = pitch * 0.7; % fraction of pitch used by block
        for k = 0:N-1
            thc = k*pitch + rot;
            % block corners in local polar coords relative to midR:
            r1 = midR - bd/2;
            r2 = midR + bd/2;
            th1 = thc - blockAngularWidth/2;
            th2 = thc + blockAngularWidth/2;
            % Four corners (r,th) -> (x,y)
            xr = [r1*cos(th1), r2*cos(th1), r2*cos(th2), r1*cos(th2)];
            yr = [r1*sin(th1), r2*sin(th1), r2*sin(th2), r1*sin(th2)];
            patch(xr, yr, [0.05 0.05 0.05], 'EdgeColor', 'none');
        end
    case 'chevron'
        % Create a V-shaped element pointing circumferentially; alternate directions optionally
        midR = (innerR + outerR)/2;
        chevAng = pitch*0.6;
        chevDepth = bd;
        for k = 0:N-1
            thc = k*pitch + rot;
            % chevron defined by three points in polar coords: left, tip, right
            thL = thc - chevAng/2; thR = thc + chevAng/2; thTip = thc;
            rOuter = midR + chevDepth/2;
            rInner = midR - chevDepth/2;
            % polygon approx: left outer -> tip outer -> right outer -> right inner -> tip inner -> left inner
            px = [rOuter*cos(thL), rOuter*cos(thTip), rOuter*cos(thR), ...
                  rInner*cos(thR), rInner*cos(thTip), rInner*cos(thL)];
            py = [rOuter*sin(thL), rOuter*sin(thTip), rOuter*sin(thR), ...
                  rInner*sin(thR), rInner*sin(thTip), rInner*sin(thL)];
            patch(px, py, [0.05 0.05 0.05], 'EdgeColor', 'none');
        end
    otherwise
        error('Unknown pattern: %s', pattern);
end

% Draw center and annotations
plot(0,0,'k+','MarkerSize',8,'LineWidth',1.2);
title(sprintf('Overhead Tire (Pattern: %s)  Outer R=%.3f m  Inner R=%.3f m', pattern, outerR, innerR));
xlabel('meters'); ylabel('meters');
xlim([-outerR-0.1*outerR, outerR+0.1*outerR]);
ylim([-outerR-0.1*outerR, outerR+0.1*outerR]);
set(gca,'FontSize',11);
hold off;
end
