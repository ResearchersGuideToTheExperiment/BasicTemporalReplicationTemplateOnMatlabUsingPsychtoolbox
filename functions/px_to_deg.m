function degrees = px_to_deg(pixels, g)
% PX_TO_DEG Inverse projection; N-by-2 window-local coordinates in pixels.
validateattributes(pixels, {'numeric'}, {'real','finite','size',[NaN 2]});
degrees = atand((pixels - g.centerPx) ./ g.pixelsPerCm .* [1 -1] / g.distanceCm);
end
