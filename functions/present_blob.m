function timing = present_blob(window, texture, rect, g, durationSec, ifi)
% PRESENT_BLOB Present for a rounded number of frames; log actual flip times.
validateattributes(durationSec, {'numeric'}, {'real','finite','positive','scalar'});
frames = max(1, round(durationSec / ifi));
Screen('FillRect', window, 0.5);
Screen('DrawTexture', window, texture, [], rect);
draw_fixation(window, g);
[vbl,onset] = Screen('Flip', window);
% Keep the image visible while polling Escape; schedule its removal by flip.
while GetSecs < vbl + (frames-1)*ifi
    check_escape;
    WaitSecs('YieldSecs', 0.001);
end
Screen('FillRect', window, 0.5);
draw_fixation(window, g);
[~,offset,~,missed] = Screen('Flip', window, vbl + (frames-0.5)*ifi);
timing = struct('requestedSec',durationSec,'frames',frames, ...
    'onsetSec',onset,'offsetSec',offset,'actualSec',offset-onset, ...
    'offsetMissedSec',missed);
end
