function [window, g, ifi] = open_display(screenSizeCm, distanceCm)
% OPEN_DISPLAY Full-screen normalized colors; caller owns cleanup guard.
assert(exist('Screen','file') ~= 0, 'Install Psychtoolbox separately first.');
PsychDefaultSetup(2);
KbName('UnifyKeyNames');
[window,rect] = Screen('OpenWindow', max(Screen('Screens')), 0.5);
g = create_geometry([rect(3)-rect(1) rect(4)-rect(2)], screenSizeCm, distanceCm);
ifi = Screen('GetFlipInterval',window);
HideCursor;
end
