function wait_seconds(durationSec)
% WAIT_SECONDS Responsive non-stimulus pause; not a presentation timing method.
finish = GetSecs + durationSec;
while GetSecs < finish
    check_escape;
    WaitSecs('YieldSecs', 0.001);
end
end
