% Define data points
x = [1 1; 1 2; 1 3; 2 1; 2 3; 3 1; 3 2; 3 3];

% Plot histogram
hist3(x);

% Set up the axes
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Frequency');
title('Parking lot with Static Objects (LOS)');

% Define positions for static objects
staticObjects = [1.5 1.5 0.5; 2.5 2.5 0.5; 1.5 2.5 0.5; 2.5 1.5 0.5]; % Add more objects as needed

% Define positions for the anchors (LOS)
LOS_anchor = [1.5, 1, 0.5];  % LOS anchor
LOS_anchor2 = [3, 3, 0.5];    % Second LOS anchor

% Plot static objects
hold on;
scatter3(staticObjects(:, 1), staticObjects(:, 2), staticObjects(:, 3), 100, 'filled', 'MarkerFaceColor', 'r');

% Plot the anchors (LOS)
scatter3(LOS_anchor(1), LOS_anchor(2), LOS_anchor(3), 200, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k'); % LOS anchor
scatter3(LOS_anchor2(1), LOS_anchor2(2), LOS_anchor2(3), 200, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'); % Second LOS anchor
hold off;

% Speed of light
c = 3e8; % meters per second

% Calculate actual distances between static objects and the anchors (LOS)
actual_distance_LOS = sqrt(sum((staticObjects - repmat(LOS_anchor, size(staticObjects,1), 1)).^2, 2));
actual_distance_LOS2 = sqrt(sum((staticObjects - repmat(LOS_anchor2, size(staticObjects,1), 1)).^2, 2));

% Calculate TOF for the anchors
TOF_LOS = actual_distance_LOS / c;
TOF_LOS2 = actual_distance_LOS2 / c;

% Display TOF for the first anchor (LOS)
disp('TOF for first anchor (LOS) (seconds):');
disp(TOF_LOS');

% Display TOF for the second anchor (LOS)
disp('TOF for second anchor (LOS) (seconds):');
disp(TOF_LOS2');

% Define a scaling factor
scaling_factor = 0.0001; % Adjust as needed, should be less than 0.01 to keep the error less than 10 cm

% Estimated position for both anchors (assuming perfect TOF measurement)
estimated_LOS = repmat(LOS_anchor, size(staticObjects, 1), 1) + TOF_LOS .* [scaling_factor, scaling_factor, scaling_factor];
estimated_LOS2 = repmat(LOS_anchor2, size(staticObjects, 1), 1) + TOF_LOS2 .* [scaling_factor, scaling_factor, scaling_factor];

% Plot estimated positions
hold on;
scatter3(estimated_LOS(:, 1), estimated_LOS(:, 2), estimated_LOS(:, 3), 100, 'filled', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'k'); % Estimated position for LOS anchor
scatter3(estimated_LOS2(:, 1), estimated_LOS2(:, 2), estimated_LOS2(:, 3), 100, 'filled', 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'k'); % Estimated position for second LOS anchor
hold off;

% Calculate errors between each tag and the first anchor (LOS)
error_LOS = zeros(size(staticObjects, 1), 1);
for i = 1:size(staticObjects, 1)
    % Error for the first anchor (LOS) in centimeters
    error_LOS(i) = sqrt(sum((staticObjects(i, :) - estimated_LOS(i, :)).^2, 2)) / 100; % Dividing by 100 to convert to meters
    %fprintf('Error for Tag %d (LOS) in meters: %.4f\n', i, error_LOS(i));
end

% Calculate errors between each tag and the second anchor (LOS2)
error_LOS2 = zeros(size(staticObjects, 1), 1);
for i = 1:size(staticObjects, 1)
    % Error for the second anchor (LOS2) in centimeters
    error_LOS2(i) = sqrt(sum((staticObjects(i, :) - estimated_LOS2(i, :)).^2, 2)) / 100; % Dividing by 100 to convert to meters
    %fprintf('Error for Tag %d (Second LOS) in meters: %.4f\n', i, error_LOS2(i));
end

% Calculate weights based on inverse of errors
weight_1 = 1 ./ error_LOS;
weight_2 = 1 ./ error_LOS2;

% Combine weights
total_weight = weight_1 + weight_2;

% Calculate weighted average of estimates
combined_estimated_position = (repmat(weight_1, 1, 3) .* estimated_LOS + repmat(weight_2, 1, 3) .* estimated_LOS2) ./ repmat(total_weight, 1, 3);

% Calculate errors using combined estimates
error_combined = sqrt(sum((staticObjects - combined_estimated_position).^2, 2)) / 100; % Error in meters

for i = 1:size(staticObjects, 1)
    fprintf('Error for Tag %d (Combined Anchors) in meters: %.4f\n', i, error_combined(i));
end

