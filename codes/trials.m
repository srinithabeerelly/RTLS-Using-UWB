% Speed of light
c = 3e8; % meters per second

% Define positions for static objects
staticObjects = [1.5 1.5 0.5; 2.5 2.5 0.5; 1.5 2.5 0.5; 2.5 1.5 0.5]; % Add more objects as needed

% Define positions for the anchor (LOS)
LOS_anchor = [1.5, 1, 0.5];  % LOS anchor

% Calculate actual distances between static objects and the anchor (LOS)
actual_distance_LOS = sqrt(sum((staticObjects - repmat(LOS_anchor, size(staticObjects,1), 1)).^2, 2));

% Simulate noisy measurements (for demonstration purposes)
noisy_distances = actual_distance_LOS + randn(size(actual_distance_LOS)) * 0.01; % Adding Gaussian noise with standard deviation 0.01 meters

% Calculate TOF for LOS
TOF_LOS = noisy_distances / c;

% Define a scaling factor for centimeters
scaling_factor = 1e2; % Representing centimeters

% Estimated position for LOS using multilateration
estimated_LOS = multilateration(staticObjects, TOF_LOS * scaling_factor, LOS_anchor);

% Print out estimated positions
disp('Estimated positions for LOS:');
disp(estimated_LOS);

% Calculate errors between each tag and the anchor (LOS)
error_LOS = zeros(size(staticObjects, 1), 1);

for i = 1:size(staticObjects, 1)
    % Calculate Euclidean distance between actual position and estimated position
    error_LOS(i) = norm(staticObjects(i, :) - estimated_LOS(i, :)); % No need to multiply by 100
    fprintf('Error for Tag %d (LOS) in centimeters: %.4f\n', i, error_LOS(i) * 100); % Multiply error by 100 to convert to centimeters for printing
end

function estimated_positions = multilateration(anchors, distances, anchor_point)
    num_anchors = size(anchors, 1);
    num_dimensions = size(anchors, 2);
    
    A = 2 * (anchors - repmat(anchor_point, num_anchors, 1));
    b = sum(anchors.^2, 2) - sum(anchor_point.^2) - distances.^2;
    
    estimated_positions = pinv(A) * b;
    estimated_positions = repmat(anchor_point, num_anchors, 1) + estimated_positions';
end
