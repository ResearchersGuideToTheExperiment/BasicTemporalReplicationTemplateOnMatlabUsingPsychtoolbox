function results = main_temporal_replication_template(screenSizeCm, distanceCm)
% MAIN_TEMPORAL_REPLICATION_TEMPLATE Run a generic demonstration; results remain in memory.
% Supply measured active screen [width height] in cm and eye distance in cm.
% Example only: results = main_temporal_replication_template([50 30], 60);
if nargin ~= 2
    error('Supply measured screen size [width height] cm and viewing distance cm.');
end
root = fileparts(mfilename('fullpath'));
oldPath = path;
pathGuard = onCleanup(@() path(oldPath)); %#ok<NASGU>
addpath(fullfile(root,'functions'));
% Validate calibration before opening the display.
create_geometry([1 1],screenSizeCm,distanceCm);
assert(exist('Screen','file') ~= 0, 'Install Psychtoolbox separately first.');
oldSync = Screen('Preference','SkipSyncTests',0);
displayGuard = onCleanup(@() cleanup_display(oldSync)); %#ok<NASGU>
[window,g,ifi] = open_display(screenSizeCm,distanceCm);
sigmaDeg = 0.35; % Gaussian standard deviation; support extends to +/-4 sigma.
seed = 1; % Reproducible demonstration, without modifying the caller's RNG state.
oldRng = rng; rngGuard = onCleanup(@() rng(oldRng)); %#ok<NASGU>
rng(seed,'twister');
results = struct('geometry',g,'refreshIntervalSec',ifi,'seed',seed,'sigmaDeg',sigmaDeg);
Screen('TextSize',window,24);
DrawFormattedText(window, 'Remember each duration. At the cue, hold SPACE to reproduce it.\n\nPress SPACE to start. ESC to stop.', ...
    'center','center',0);
Screen('Flip',window);
wait_for_space;
durations = repmat([0.4 0.8 1.2],1,2);
durations = durations(randperm(numel(durations)));
[im,rect] = gaussian_blob_image(g,[0 2],sigmaDeg,1);
texture = Screen('MakeTexture',window,im);
mask = zeros(1,256); mask(KbName('space')) = 1; mask(KbName('ESCAPE')) = 1;
KbQueueCreate([],mask); KbQueueStart;
for trial = 1:numel(durations)
    timing = present_blob(window,texture,rect,g,durations(trial),ifi);
    wait_seconds(0.4);
    Screen('FillRect',window,0.5);
    DrawFormattedText(window,'Hold SPACE for the remembered duration, then release.', ...
        'center','center',0);
    % Clear both scored and raw queue events before the cue.
    KbQueueFlush([],3);
    [~,~,keysBeforeCue] = KbCheck;
    [~,cueSec] = Screen('Flip',window);
    response = collect_duration(cueSec,10,keysBeforeCue(KbName('space')));
    results.trials(trial).timing = timing;
    results.trials(trial).cueSec = cueSec;
    results.trials(trial).response = response;
    results.trials(trial).errorSec = response.durationSec-timing.actualSec;
    Screen('FillRect',window,0.5); draw_fixation(window,g); Screen('Flip',window);
    wait_seconds(0.5);
end
end
