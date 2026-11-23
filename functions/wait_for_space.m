function wait_for_space
% WAIT_FOR_SPACE Require a fresh space press, then release; Escape cancels.
space = KbName('space');
while true
    check_escape;
    [~,~,keys] = KbCheck;
    if ~keys(space), break; end
    WaitSecs('YieldSecs', 0.001);
end
while true
    check_escape;
    [~,~,keys] = KbCheck;
    if keys(space), break; end
    WaitSecs('YieldSecs', 0.001);
end
while true
    check_escape;
    [~,~,keys] = KbCheck;
    if ~keys(space), break; end
    WaitSecs('YieldSecs', 0.001);
end
end
