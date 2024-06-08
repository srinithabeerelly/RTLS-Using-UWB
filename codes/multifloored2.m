% Define or input the floor plan
num_floors = 3; % Example: 3 floors
floor_tags = [5, 7, 9]; % Example: Number of tags on each floor

% Define UWB communication parameters
error_threshold = 0.1; % Error threshold in meters (10 cm)
building_height = 3; % Height of each floor in meters
anchor_height = 2; % Height at which anchors are placed in meters
floor_height = 3; % Height of each floor in meters

% Generate random tag positions for each floor along with identifiers
tag_positions = cell(1, num_floors);
for i = 1:num_floors
    % Random positions in 3D space with identifiers for floor and tag
    tag_positions{i} = [rand(floor_tags(i), 2), ones(floor_tags(i), 1) * i]; 
    tag_positions{i}(:, 3) = tag_positions{i}(:, 3) * floor_height; % Adjust height
end

% Define optimization parameters
options = optimoptions(@ga,'Display','iter','PopulationSize',100,'MaxGenerations',100);

% Define objective function (minimize number of anchors while ensuring error is within threshold)
objectiveFcn = @(x) anchor_placement_objective(x, tag_positions, floor_height, anchor_height, error_threshold);

% Define bounds for anchor positions (assuming the building has dimensions [10x10] meters)
lb = [0, 0, 0]; % Lower bound for anchor positions
ub = [10, 10, 3]; % Upper bound for anchor positions

% Run genetic algorithm
[x, fval] = ga(objectiveFcn, 3, [], [], [], [], lb, ub, [], options);

% Output results
disp('Optimal number of anchors required:');
disp(size(x, 1));
disp('Optimal anchor positions:');
disp(x);

% Plotting
figure;

% Plot tag positions with different colors for each floor
for floor = 1:num_floors
    scatter3(tag_positions{floor}(:,1), tag_positions{floor}(:,2), tag_positions{floor}(:,3), 'filled', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
    hold on;
end

% Plot anchor positions
scatter3(x(:,1), x(:,2), x(:,3), 'filled', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');

xlabel('X');
ylabel('Y');
zlabel('Z');
title('Tag and Anchor Positions');
legend('Floor 1 Tags', 'Floor 2 Tags', 'Floor 3 Tags', 'Optimal Anchor Positions', 'Location', 'best');
grid on;
hold off;

function error = anchor_placement_objective(anchor_positions, tag_positions, floor_height, anchor_height, error_threshold)
    num_floors = length(tag_positions);
    estimated_positions = cell(1, num_floors);
    for floor = 1:num_floors
        num_tags = size(tag_positions{floor}, 1);
        estimated_positions{floor} = zeros(num_tags, 4); % Adjusted to include floor identifier
        for tag = 1:num_tags
            % Ensure both anchor_positions and tag_positions{floor}(tag, 1:2) have the same number of columns
            distances = sqrt(sum((anchor_positions(:, 1:2) - tag_positions{floor}(tag, 1:2)).^2, 2));
            [~, nearest_anchor] = min(distances);
            % Concatenate anchor position with floor identifier separately
            estimated_positions{floor}(tag, :) = [anchor_positions(nearest_anchor, :), tag_positions{floor}(tag, 3)]; % Include floor identifier
        end
    end
    
    errors = cell(1, num_floors);
    for floor = 1:num_floors
        errors{floor} = sqrt(sum((tag_positions{floor}(:,1:2) - estimated_positions{floor}(:,1:2)).^2, 2));
    end
    
    error = sum(cellfun(@(x) all(x <= error_threshold), errors)) - size(anchor_positions, 1);
end

