function [image, rect] = gaussian_blob_image(g, centerDeg, sigmaDeg, contrast)
% GAUSSIAN_BLOB_IMAGE Sample a Gaussian in angular coordinates, clipped at 4 sigma.
% Returns a uint8 grayscale image and its integer pixel destination rectangle.
% Contrast [-1,1]: negative is dark, positive bright, zero matches background.
% Sigma is angular standard deviation, not diameter. Background is 0.5.
validateattributes(centerDeg, {'numeric'}, {'real','finite','size',[1 2]});
validateattributes(sigmaDeg, {'numeric'}, {'real','finite','positive','scalar'});
validateattributes(contrast, {'numeric'}, {'real','finite','scalar','>=',-1,'<=',1});
upperLeft = deg_to_px(centerDeg + [-4 4]*sigmaDeg, g);
lowerRight = deg_to_px(centerDeg + [4 -4]*sigmaDeg, g);
rect = [floor(upperLeft) ceil(lowerRight)];
assert(all(rect(1:2) >= 0) && all(rect(3:4) <= g.resolutionPx), ...
    'Blob extends beyond the display. Reduce eccentricity or sigma.');
[x,y] = meshgrid((rect(1):rect(3)-1)+0.5, (rect(2):rect(4)-1)+0.5);
a = px_to_deg([x(:) y(:)], g) - centerDeg;
envelope = reshape(exp(-sum(a.^2,2)/(2*sigmaDeg^2)), size(x));
image = uint8(round(255 * (0.5 + 0.5*contrast*envelope)));
end
