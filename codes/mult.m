% Define initial positions for device and anchor nodes
deviceLocInitial = [50 50];  % Initial device position
nodeLocInitial = [40 41;     % Initial anchor node positions
                  62 83;
                  87 24];

% Define velocities for device and anchor nodes (change as needed)
deviceVelocity = [0.1, 0.05];   % Velocity of the device in x and y directions
nodeVelocities = [0.05, 0.1;    % Velocities of anchor nodes in x and y directions
                  -0.1, 0.05;
                  0.05, -0.1];

% Simulation parameters
numTimeSteps = 10;  % Number of time steps for simulation
timeStep = 0.1;      % Time step duration (adjust as needed)

% Initialize device and anchor node positions
deviceLoc = deviceLocInitial;
nodeLoc = nodeLocInitial;

% Initialize figure for visualization
figure;
hold on;
grid on;
xlabel('X position');
ylabel('Y position');
title('Dynamic UWB Localization');
axis equal; % Set equal aspect ratio

% Set axis limits based on initial positions
axisLimits = [min([deviceLocInitial; nodeLocInitial]) - 10, max([deviceLocInitial; nodeLocInitial]) + 10];
axis(axisLimits);

% Plot initial positions of device and anchor nodes
plot(deviceLocInitial(1), deviceLocInitial(2), 'ro', 'MarkerSize', 10, 'DisplayName', 'Device Initial');
plot(nodeLocInitial(:, 1), nodeLocInitial(:, 2), 'bs', 'MarkerSize', 10, 'DisplayName', 'Anchor Nodes');

% Main simulation loop
for t = 1:numTimeSteps
    % Update device position
    deviceLoc = deviceLoc + deviceVelocity * timeStep;
    
    % Update anchor node positions
    nodeLoc = nodeLoc + nodeVelocities * timeStep;
    
    % Plot updated positions
    plot(deviceLoc(1), deviceLoc(2), 'r.', 'MarkerSize', 10, 'DisplayName', 'Device');
    plot(nodeLoc(:, 1), nodeLoc(:, 2), 'b.', 'MarkerSize', 10, 'DisplayName', 'Anchor Nodes');
    
    % Run the localization algorithm with updated positions
    % Here you would integrate the localization algorithm using the 
    % updated positions of the device and anchor nodes
    
    % For demonstration purposes, I'll just print out the positions
    disp(['Time Step: ' num2str(t)]);
    disp(['Device Location: ' num2str(deviceLoc)]);
    disp(['Anchor Node Locations:']);
    disp(nodeLoc);
    disp(' ');
    
    % Pause for visualization (optional)
    pause(0.1);
end

% Add legend
legend('Location', 'best');
