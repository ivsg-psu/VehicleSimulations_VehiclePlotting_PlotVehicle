function fcn_PlotTire_plotTireWithProfile(t, profile)
% plotTireWithProfile Plot tire cross-section using different profile shapes
%  t       - struct from parseTireSidewall (expects sectionWidth_m, sidewallHeight_m, rimDiameter_m, overallDiameter_m)
%  profile - 'circle' (default), 'arched', or Nx2 custom points [x y] in meters (x across width, y radial)
arguments
	t struct
	profile = "arched"
end

% Basic dims
w = t.sectionWidth_m;
h = t.sidewallHeight_m;
rim_d = t.rimDiameter_m;
rim_r = rim_d/2;
outer_r = t.overallDiameter_m/2;

figure('Color','w'); hold on; axis equal; box on;
xlabel('meters'); ylabel('meters');

% Build symmetric half-profile from centerline to outer edge (x >= 0)
switch class(profile)
	case 'string'
		mode = char(profile);
		if strcmpi(mode,'circle')
			% Outer is circle of radius outer_r
			theta = linspace(0,2*pi,360);
			x = outer_r * cos(theta);
			y = outer_r * sin(theta);
			patch(x,y,[0.9 0.9 0.9],'EdgeColor',[0.2 0.2 0.2]);
		elseif strcmpi(mode,'arched')
			% Generate half cross-section from center to shoulder:
			% Use points: center->tread edge(flat) -> shoulder -> rim edge -> inner radius
			% x axis: -w/2 .. w/2, y measured from wheel center
			half_x = linspace(0,w/2,60);
			% define a smooth curve: start at centerline y = outer_r, end at rim edge y = rim_r
			% simple cosine-based transition for shoulder:
			shoulder = 0.35; % fraction of half-width taken by shoulder
			idx_sh = floor(shoulder*numel(half_x));
			% y_profile decreases from outer_r at center to rim_r at bead position
			y_profile = outer_r - (outer_r - rim_r) * (1 - cos(pi*(half_x/(w/2))).^2);
			% Mirror to full width
			x_full = [-fliplr(half_x), half_x];
			y_full = [fliplr(y_profile), y_profile];
			% Close inner rim circle (approx)
			theta = linspace(pi/2, -pi/2, 50); % inner arc under bead
			x_rim_arc = rim_r * cos(theta);
			y_rim_arc = rim_r * sin(theta);
			% build patch coordinates (outer contour followed by rim arc)
			xp = [x_full, x_rim_arc];
			yp = [y_full, y_rim_arc];
			patch(xp, yp, [0.92 0.92 0.92], 'EdgeColor', [0.2 0.2 0.2]);
		else
			error('Unknown profile string: %s', mode);
		end

	otherwise
		% custom numeric Nx2 array of [x y] where x is across half-width (center 0) or full width
		P = profile;
		if size(P,2) ~= 2
			error('Custom profile must be Nx2 [x y] in meters.');
		end
		% If points represent half (x >= 0), mirror them to full width.
		xs = P(:,1); ys = P(:,2);
		if any(xs < 0)
			% assume full-width given; reorder so center to right then mirror
			% sort by x
			[xs, idx] = sort(xs);
			ys = ys(idx);
			% separate left/right around 0
			% mirror left half into right if necessary
			% We'll just plot polygon from left to right and close through rim
			xp = xs'; yp = ys';
			patch(xp, yp, [0.93 0.93 0.93], 'EdgeColor', [0.2 0.2 0.2]);
		else
			% half given: mirror to full
			x_full = [-flip(xs); xs];
			y_full = [flip(ys); ys];
			patch(x_full, y_full, [0.93 0.93 0.93], 'EdgeColor', [0.2 0.2 0.2]);
		end
end

% Draw rim circle (solid ring)
theta = linspace(0,2*pi,180);
xr = rim_r * cos(theta);
yr = rim_r * sin(theta);
plot(xr, yr, 'k-', 'LineWidth', 2);

% Draw centerline and tread flat
plot([0 0], [-outer_r*1.1, outer_r*1.1], ':', 'Color', [0.6 0.6 0.6]);
tread_half = min(w/2, outer_r*0.98);
plot([-tread_half,tread_half],[outer_r,outer_r],'k-','LineWidth',3);

% Bead marker
bead_y = rim_r * 0.98;
plot([-w/2, w/2], [bead_y, bead_y], 'Color', [0.55 0.2 0.2], 'LineWidth', 2, 'LineStyle','--');

% Annotations
title(sprintf('Tire: %s  Profile: %s', string(t.rawInput), mat2str(profile)));
text(-outer_r*0.95, outer_r*0.2, sprintf('Outer Ø = %.3f m', 2*outer_r));
text(-outer_r*0.95, outer_r*0.12, sprintf('Rim Ø = %.3f m', rim_d));
text(0.02, -outer_r*1.02, sprintf('Section width = %.3f m', w));
set(gca,'FontSize',11);

% Adjust limits
pad = outer_r*0.18;
xlim([-w/2-pad, w/2+pad]);
ylim([-outer_r-pad, outer_r+pad]);
hold off;
end
