function [xC, yC] = helperFindHyperbolicIntersection(xCell, yCell)
% HELPERFINDHYPERBOLICINTERSECTION Find intersection point(s) between 3 hyperbolas

% Copyright 2021 The MathWorks, Inc.

% A. Find closest points between hyperbolic surfaces.
% B. Linearize surfaces around their points closest to intersection, to
% interpolate actual intersection location.

numCurves = numel(xCell);
% Make all vectors have equal length
maxLen = max(cellfun(@length, xCell));
for curveIdx = 1:numCurves
    xCell{curveIdx} = [xCell{curveIdx} inf(1, maxLen-length(xCell{curveIdx}))];
    yCell{curveIdx} = [yCell{curveIdx} inf(1, maxLen-length(yCell{curveIdx}))];
end
tempIdx = 1;
[xC, yC] = deal(zeros(1, numCurves*(numCurves-1)/2)); % preallocate
for idx1 = 1:numCurves-1
    for idx2 = (idx1+1):numCurves
        [firstCurve,secondCurve] = findMinDistanceElements(xCell{idx1},yCell{idx1},xCell{idx2},yCell{idx2});
        for idx3 = 1:numel(firstCurve)
            [x1a,y1a,x1b,y1b] = deal(firstCurve{idx3}(1,1),firstCurve{idx3}(1,2), ...
                                     firstCurve{idx3}(2,1),firstCurve{idx3}(2,2));
            [x2a,y2a,x2b,y2b] = deal(secondCurve{idx3}(1,1),secondCurve{idx3}(1,2), ...
                                     secondCurve{idx3}(2,1),secondCurve{idx3}(2,2));
            a1 = (y1b-y1a)/(x1b-x1a);
            b1 = y1a - a1*x1a;

            a2 = (y2b-y2a)/(x2b-x2a);
            b2 = y2a - a2*x2a;

            xC(tempIdx) = (b2-b1)/(a1-a2);
            yC(tempIdx) = a1*xC(tempIdx) + b1;
            tempIdx = tempIdx+1;
        end
    end
end
numEstimations = numCurves*(numCurves-1)/2;
[xC, order] = sort(xC);
xC = reshape(xC, numEstimations, [])';
yC = reshape(yC(order), numEstimations, [])';
end

function [firstCurvePoints,secondCurvePoints] = findMinDistanceElements(xA,yA,xB,yB)
%   [FIRSTCURVEPOINTS,SECONDCURVEPOINTS] = findMinDistanceElements(XA,YA,XB,YB)
%   returns the closest points between the given hyperbolic surfaces.

    distAB = zeros(numel(xA),numel(xB));
    for idx1 = 1:numel(xA)
        distAB(idx1,:) = sqrt((xB-xA(idx1)).^2 + (yB-yA(idx1)).^2);
    end
    [~,rows] = min(distAB,[],'omitnan');
    [~, col] = min(min(distAB,[],'omitnan'));

    % 1st intersection is the closest distance point. That allows for more
    % accurate intersection points:
    allRows = rows(col);
    allCols = col;

    % Look for possible 2nd intersection 
    % One is identified outside a region around the 1st intersection, if
    % distance is smaller than max distance within that region
    numRegionSamples = 100;
    region = -numRegionSamples:numRegionSamples;    

    % Work with a copy, to still be able to check distAB values later on
    distAB2 = distAB;
    distAB2(allRows+region, col+region) = nan;

    [~,rows2] = min(distAB2,[],'omitnan');
    [minDist2, col2] = min(min(distAB2,[],'omitnan'));
    threshold = 0.1; % m
    if minDist2 < threshold
      allRows = [allRows rows2(col2)];
      allCols = [allCols col2];
    end

    for idx = 1:numel(allRows)
        firstCurveIndices = allRows(idx);
        secondCurveIndices = allCols(idx);
        x1a = xA(firstCurveIndices);
        y1a = yA(firstCurveIndices);
        x2a = xB(secondCurveIndices);
        y2a = yB(secondCurveIndices);

        % Use subsequent points to create line for linearization
        if firstCurveIndices == numel(xA) || distAB(firstCurveIndices-1, secondCurveIndices) < distAB(firstCurveIndices+1, secondCurveIndices)
            x1b = xA(firstCurveIndices-1);
            y1b = yA(firstCurveIndices-1);
        else
            x1b = xA(firstCurveIndices+1);
            y1b = yA(firstCurveIndices+1);
        end

        if secondCurveIndices == numel(xB) || distAB(firstCurveIndices, secondCurveIndices-1) < distAB(firstCurveIndices, secondCurveIndices+1)
            x2b = xB(secondCurveIndices-1);
            y2b = yB(secondCurveIndices-1);
        else
            x2b = xB(secondCurveIndices+1);
            y2b = yB(secondCurveIndices+1);
        end
        firstCurvePoints{idx} = [x1a y1a;x1b y1b]; %#ok<*AGROW> 
        secondCurvePoints{idx} = [x2a y2a;x2b y2b];
    end
end