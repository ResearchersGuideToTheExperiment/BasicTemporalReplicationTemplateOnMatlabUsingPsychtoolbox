function cleanup_display(oldSync)
% CLEANUP_DISPLAY Restore resources on normal return or error.
try KbQueueRelease; catch, end
try Screen('CloseAll'); catch, end
try ShowCursor; catch, end
try Screen('Preference','SkipSyncTests',oldSync); catch, end
end
