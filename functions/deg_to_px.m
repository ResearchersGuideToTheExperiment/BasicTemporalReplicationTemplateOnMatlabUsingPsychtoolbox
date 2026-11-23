function pixels = deg_to_px(degrees, g)
% DEG_TO_PX Project N-by-2 angular positions: +x right, +y up; origin at center.
validateattributes(degrees, {'numeric'}, {'real','finite','size',[NaN 2]});
assert(all(abs(degrees(:)) < 89), 'Angles must lie strictly between -89 and 89 degrees.');
pixels = g.centerPx + g.distanceCm * tand(degrees) .* g.pixelsPerCm .* [1 -1];
end
