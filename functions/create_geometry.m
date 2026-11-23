function g = create_geometry(resolutionPx, screenSizeCm, distanceCm)
% CREATE_GEOMETRY Calibrate a flat, full-screen display; eye centered normally.
% Inputs: [width height] in pixels, measured active area in cm, eye distance cm.
validateattributes(resolutionPx, {'numeric'}, {'real','finite','positive','integer','size',[1 2]});
validateattributes(screenSizeCm, {'numeric'}, {'real','finite','positive','size',[1 2]});
validateattributes(distanceCm, {'numeric'}, {'real','finite','positive','scalar'});
g.resolutionPx = double(resolutionPx);
g.centerPx = resolutionPx / 2;
g.pixelsPerCm = resolutionPx ./ screenSizeCm;
g.distanceCm = distanceCm;
end
