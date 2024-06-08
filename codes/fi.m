% Define or input the floor plan
num_floors = 3; % Example: 3 floors
floor_tags = [5, 7, 9]; % Example: Number of tags on each floor

% Define UWB communication parameters
error_threshold = 0.1; % Error threshold in meters (10 cm)
building_height = 3; % Height of each floor in meters
anchor_height = 2; % Height at which anchors are placed in meters
floor_height = 3; % Height of each floor in meters

% Generate random tag positions for each floor
tag_positions = cell(1, num_floors);
for i = 1:num_floors
    tag_positions{i} = rand(floor_tags(i), 3); % Random positions in 3D space
    tag_positions{i}(:, 3) = tag_positions{i}(:, 3) * floor_height; % Adjust height
end

% Define optimization parameters
options = optimoptions(@ga,'Display','iter','PopulationSize',100,'MaxGenerations',100);

% Define objective function (minimize number of anchors while ensuring error is within threshold)
objectiveFcn = @(x) anchor_placement_objective(x, tag_positions, error_threshold);

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

% Plot tag positions
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
legend('Tag Positions', 'Optimal Anchor Positions', 'Location', 'best');
grid on;
hold off;

% Objective function to minimize the number of anchors while satisfying error threshold
function error = anchor_placement_objective(anchor_positions, tag_positions, error_threshold)
    num_tags = 0; % Total number of tags
    errors = 0; % Total number of errors exceeding threshold
    
    % Calculate the total number of tags and errors
    for floor = 1:length(tag_positions)
        num_tags = num_tags + size(tag_positions{floor}, 1);
        
        % Calculate distances between tags and anchors on each floor
        distances = pdist2(tag_positions{floor}, anchor_positions);
        
        % Check if any distance exceeds the threshold
        if any(distances(:) > error_threshold)
            errors = errors + sum(distances(:) > error_threshold);
        end
    end
    
    % Calculate error as the negative of the total number of anchors
    % plus the total number of errors (to minimize anchors while satisfying error threshold)
    error = -size(anchor_positions, 1) + errors / num_tags;
end
