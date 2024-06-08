x = [1 1; 1 2; 1 3; 2 1; 1.5 1.25; 2 3; 3 1; 3 2; 3 3];
hist3(x);

% Set up the axes
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Frequency');
title('3D Histogram with Static Objects');

% Define positions for static objects
staticObjects = [1.5 1.5 0.5; 2.5 2.5 0.5; 1.5 2.5 0.5; 2.5 1.5 0.5]; % Add more objects as needed

% Define positions for anchors (LOS and NLOS)
LOS_anchor = [1.8, 2.2, 1.0];  % LOS anchor
NLOS_anchor = [1.5, 1, 0.5]; % NLOS anchor

% Plot static objects
hold on;
scatter3(staticObjects(:, 1), staticObjects(:, 2), staticObjects(:, 3), 100, 'filled', 'MarkerFaceColor', 'r');

% Plot anchors
scatter3(LOS_anchor(1), LOS_anchor(2), LOS_anchor(3), 200, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k'); % LOS anchor
scatter3(NLOS_anchor(1), NLOS_anchor(2), NLOS_anchor(3), 200, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'); % NLOS anchor

hold off;

% Speed of light
c = 3e8; % meters per second

% Calculate actual distances between static objects and anchors
actual_distance_LOS = sqrt(sum((staticObjects - repmat(LOS_anchor, size(staticObjects,1), 1)).^2, 2));
actual_distance_NLOS = sqrt(sum((staticObjects - repmat(NLOS_anchor, size(staticObjects,1), 1)).^2, 2));

% Calculate TOF for LOS
TOF_LOS = actual_distance_LOS / c;

% Calculate TDOA for NLOS (assuming tag transmits to both anchors)
TDOA_NLOS = actual_distance_LOS - sqrt(sum((staticObjects - repmat(NLOS_anchor, size(staticObjects,1), 1)).^2, 2)) / c;

% Display results
disp('TOF for LOS (seconds):');
disp(TOF_LOS');

disp('TDOA for NLOS (seconds):');
disp(TDOA_NLOS');

% Estimated position for LOS (assuming perfect TOF measurement)
estimated_LOS = repmat(LOS_anchor, size(staticObjects, 1), 1) + TOF_LOS .* [1, 1, 1];

% Estimated position for NLOS using centroid (not very accurate)
estimated_NLOS = mean([LOS_anchor; NLOS_anchor], 1);

% Calculate errors between each tag and each anchor
error_LOS = zeros(size(staticObjects, 1), 1);
error_NLOS = zeros(size(staticObjects, 1), 1);

for i = 1:size(staticObjects, 1)
    % Error for LOS anchor
    error_LOS(i) = sqrt(sum((staticObjects(i, :) - LOS_anchor).^2, 2));
    fprintf('Error for Tag %d (LOS) in meters: %.4f\n', i, error_LOS(i));
    
    % Error for NLOS anchor
    error_NLOS(i) = sqrt(sum((staticObjects(i, :) - NLOS_anchor).^2, 2));
    fprintf('Error for Tag %d (NLOS) in meters: %.4f\n', i, error_NLOS(i));
end

% Display results
disp('Error between estimated and original positions (LOS) in meters:');
disp(error_LOS');

disp('Error between estimated and original positions (NLOS) in meters:');
disp(error_NLOS');
