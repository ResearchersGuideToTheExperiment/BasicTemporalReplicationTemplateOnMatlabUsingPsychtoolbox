function check_escape
% CHECK_ESCAPE Abort through normal cleanup, including inside waiting loops.
[~,~,keys] = KbCheck;
if keys(KbName('ESCAPE'))
    error('Template:Aborted', 'Stopped with Escape.');
end
end
