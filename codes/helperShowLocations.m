function helperShowLocations(deviceLoc, nodeLoc)
%HELPERSHOWLOCATIONS Visualize device and node positions in a 2D plane

%   Copyright 2021 The MathWorks, Inc. 

f = figure;
ax = gca(f);

% Device
plot(ax, deviceLoc(1), deviceLoc(2), 'mp');

hold(ax, 'on')

% Nodes
plot(ax, nodeLoc(:, 1), nodeLoc(:, 2), 'kd');
text(ax, nodeLoc(1, 1)+1.5, nodeLoc(1, 2)-1, 'A');
text(ax, nodeLoc(2, 1)+1.5, nodeLoc(2, 2)-1, 'B');
text(ax, nodeLoc(3, 1)+1.5, nodeLoc(3, 2)-1, 'C');

axis(ax, [0 100 0 100])

legend('Device', 'Synchronized Nodes', 'Location', 'NorthWest')