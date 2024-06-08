x = [1 1; 1 2; 1 3; 2 1; 2 3; 3 1; 3 2; 3 3];
hist3(x);

% Set up the axes
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Frequency');
title('Parking lot with Static Objects (LOS)');

% Define positions for static objects
staticObjects = [1.5 1.5 0.5; 2.5 2.5 0.5; 1.5 2.5 0.5; 2.5 1.5 0.5]; % Add more objects as needed

% Define positions for the anchor (LOS)
LOS_anchor = [1.5, 1, 0.5];  % LOS anchor

% Plot static objects
hold on;
scatter3(staticObjects(:, 1), staticObjects(:, 2), staticObjects(:, 3), 100, 'filled', 'MarkerFaceColor', 'r');

% Plot the anchor (LOS)
scatter3(LOS_anchor(1), LOS_anchor(2), LOS_anchor(3), 200, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k'); % LOS anchor

hold off;

% Speed of light
c = 3e8; % meters per second

% Calculate actual distances between static objects and the anchor (LOS)
actual_distance_LOS = sqrt(sum((staticObjects - repmat(LOS_anchor, size(staticObjects,1), 1)).^2, 2));

% Calculate TOF for LOS
TOF_LOS = actual_distance_LOS / c;

% Display results
disp('TOF for LOS (seconds):');
disp(TOF_LOS');

% Define a scaling factor
scaling_factor = 0.0001; % Adjust as needed, should be less than 0.01 to keep the error less than 10 cm

% Estimated position for LOS (assuming perfect TOF measurement)
estimated_LOS = repmat(LOS_anchor, size(staticObjects, 1), 1) + TOF_LOS .* [scaling_factor, scaling_factor, scaling_factor];

% Calculate errors between each tag and the anchor (LOS)
error_LOS = zeros(size(staticObjects, 1), 1);

for i = 1:size(staticObjects, 1)
    % Error for the LOS anchor in centimeters
    error_LOS(i) = sqrt(sum((staticObjects(i, :) - estimated_LOS(i, :)).^2, 2)) / 100; % Dividing by 100 to convert to meters
    fprintf('Error for Tag %d (LOS) in meters: %.4f\n', i, error_LOS(i));
end
