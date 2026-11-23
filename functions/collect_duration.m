function response = collect_duration(cueSec, timeoutSec, spaceWasDown)
% COLLECT_DURATION Timestamp a fresh SPACE press/release using the event queue.
% Queue must already be started. Ignore a held key until its release.
space = KbName('space'); escape = KbName('ESCAPE');
armed = ~spaceWasDown;
response = struct('pressSec',NaN,'releaseSec',NaN,'durationSec',NaN, ...
    'reactionSec',NaN,'status','timeout');
while GetSecs < cueSec + timeoutSec
    check_escape;
    event = KbEventGet([],0.001);
    if isempty(event), continue; end
    if event.Keycode == escape && event.Pressed
        error('Template:Aborted','Stopped with Escape.');
    end
    if event.Keycode ~= space, continue; end
    if event.Time < cueSec
        armed = ~event.Pressed;
        continue;
    end
    if event.Time > cueSec+timeoutSec, continue; end
    if ~armed
        if ~event.Pressed, armed = true; end
        continue;
    end
    if event.Pressed && isnan(response.pressSec)
        response.pressSec = event.Time;
        response.reactionSec = event.Time-cueSec;
    elseif ~event.Pressed && ~isnan(response.pressSec)
        response.releaseSec = event.Time;
        response.durationSec = event.Time-response.pressSec;
        response.status = 'ok';
        return;
    end
end
end
