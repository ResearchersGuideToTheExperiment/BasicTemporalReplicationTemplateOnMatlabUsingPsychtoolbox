function draw_fixation(window, g)
% DRAW_FIXATION A central cross with 0.3 degree total arm length.
p = deg_to_px([-0.15 0; 0.15 0; 0 -0.15; 0 0.15], g);
Screen('DrawLine', window, 0, p(1,1), p(1,2), p(2,1), p(2,2), 2);
Screen('DrawLine', window, 0, p(3,1), p(3,2), p(4,1), p(4,2), 2);
end
