function pick3D_on_plane_example
    % Sample 3D scene
    figure('Name','Click to pick a 3D point (project to z=0)');
    ax = axes;
    [X,Y,Z] = peaks(40);
    surf(X,Y,Z), hold on
    xlabel('X'), ylabel('Y'), zlabel('Z')
    view(3), cameratoolbar('show')
    % Set callback
    hFig = gcf;
    hFig.WindowButtonDownFcn = @(~,~) onClick(ax);
end

function onClick(ax)
    % Ray defined by two points in axes coordinates
    cp = ax.CurrentPoint;        % 2x3 matrix: near and far points
    p1 = cp(1,:); p2 = cp(2,:);
    v = p2 - p1;                 % ray direction

    % Define plane: example z = 0 -> normal = [0 0 1], point P0 = [0 0 0]
    n = [0 0 1];
    P0 = [0 0 0];

    denom = dot(n, v);
    if abs(denom) < eps
        disp('Ray is parallel to plane — no intersection or infinite.');
        return
    end

    t = dot(n, (P0 - p1)) / denom;   % ray parameter
    intersection = p1 + t * v;

    % Visual feedback
    holdState = ishold(ax);
    hold(ax,'on')
    plot3(ax, intersection(1), intersection(2), intersection(3), 'ro', ...
          'MarkerSize',10, 'LineWidth',1.5);
    text(ax, intersection(1), intersection(2), intersection(3), ...
         sprintf('  (%.3g, %.3g, %.3g)', intersection), 'Color','r');
    if ~holdState, hold(ax,'off'); end

    fprintf('Picked 3D point: [%.6g %.6g %.6g]\n', intersection);
end
