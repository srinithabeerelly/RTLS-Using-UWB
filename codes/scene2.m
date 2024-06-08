x = [1 1; 1 2; 1 3; 1.5 1.25; 2 1; 2 3; 3 1; 3 2; 3 3];
hist3(x);

% Set up the axes
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Frequency');
title('Parking lot with Static Objects(NLOS)');

% Define positions for static objects
staticObjects = [1.5 1.5 0.5; 2.5 2.5 0.5; 1.5 2.5 0.5; 2.5 1.5 0.5]; % Add more objects as needed

% Define positions for the anchor (LOS)
LOS_anchor = [1.5, 1, 0.5];  % LOS anchor

% Plot static objects
hold on;
scatter3(staticObjects(:, 1), staticObjects(:, 2), staticObjects(:, 3), 100, 'filled', 'MarkerFaceColor', 'r');

% Plot the anchor (LOS)
scatter3(LOS_anchor(1), LOS_anchor(2), LOS_anchor(3), 200, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'); % LOS anchor

hold off;

% Define position for obstacle
obstacle = [1.5 1.25 0.5];

% Define positions for anchor (NLOS)
NLOS_anchor = [1.5, 1, 0.5]; % NLOS anchor

% Calculate distances between static objects and anchor (including obstacle)
distances_NLOS = zeros(size(staticObjects, 1), 1);
for i = 1:size(staticObjects, 1)
    % Calculate distance between the tag and anchor (including obstacle)
    distance_with_obstacle = sqrt(sum((staticObjects(i, :) - NLOS_anchor).^2, 2));
    % For the tag experiencing NLOS, adjust the distance for the obstacle
    if isequal(staticObjects(i, :), [1.5 1.5 0.5])
        distance_with_obstacle = distance_with_obstacle + norm(staticObjects(i, :) - obstacle) + norm(obstacle - NLOS_anchor);
    end
    distances_NLOS(i) = distance_with_obstacle;
end

% Calculate TDOA for NLOS (assuming tag transmits to both anchors)
TDOA_NLOS = distances_NLOS / c;

% Display results
disp('TOF for NLOS (seconds):');
disp(TDOA_NLOS');

% Error calculation

% Estimated position for NLOS using centroid (not very accurate)
estimated_NLOS = mean([LOS_anchor; NLOS_anchor], 1);

% Calculate errors between each tag and anchor
for i = 1:size(staticObjects, 1)
    % Error for NLOS anchor
    if isequal(staticObjects(i, :), [1.5 1.5 0.5])
        % Calculate error considering the presence of the obstacle
        error_NLOS = sqrt(sum((staticObjects(i, :) - NLOS_anchor).^2, 2) + norm(staticObjects(i, :) - obstacle)^2 + norm(obstacle - NLOS_anchor)^2) / 100;
        fprintf('Error for Tag %d (NLOS) in meters: %.4f\n', i, error_NLOS);
    else
        % For other tags, calculate error without considering the obstacle
        error_LOS = sqrt(sum((staticObjects(i, :) - NLOS_anchor).^2, 2)) / 100;
        fprintf('Error for Tag %d (LOS) in meters: %.4f\n', i, error_LOS);
    end
end
