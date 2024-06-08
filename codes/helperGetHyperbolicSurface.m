function [x, y] = helperGetHyperbolicSurface(nodeLoc1, nodeLoc2, tdoa)
% HELPERGETHYPERBOLICSURFACE Get hyperbolic surface for a given pair of nodes spaced D apart
% This function finds a hyperbolic surface between two nodes, in a manner
% that all points of the surface correspond to the same time difference of
% arrival (TDOA).

% Copyright 2021 The MathWorks, Inc.

% Convert time difference of arrival (TDOA) to distance:
c = physconst('LightSpeed'); % speed of light (m/s)
d = tdoa*c;                  % in meters

% Calculate vector between two gNBs
delta = nodeLoc1-nodeLoc2;

% Express the distance vector in polar form
[phi,r] = cart2pol(delta(1),delta(2));
rd = (r+d)/2;

% Compute the hyperbola parameters
a = (r/2)-rd;      % Vertex
c = r/2;           % Focus
b = sqrt(c^2-a^2); % Co-vertex
hk = (nodeLoc1 + nodeLoc2)/2;
maxMu = 10;
step = 1e-3;
mu = -maxMu:step:maxMu;

% Get the x-y coordinates of hyperbola equation
x = (a*cosh(mu)*cos(phi) - b*sinh(mu)*sin(phi)) + hk(1);
y = (a*cosh(mu)*sin(phi) + b*sinh(mu)*cos(phi)) + hk(2);
