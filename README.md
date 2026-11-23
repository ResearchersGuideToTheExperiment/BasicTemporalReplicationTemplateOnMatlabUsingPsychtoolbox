# Temporal Replication Task Template (MATLAB / Psychtoolbox)

Build duration-reproduction tasks with Gaussian stimuli and timestamped key responses using MATLAB and Psychtoolbox.

## Features

- Small reusable helpers in `functions/` and a single main entry point.
- Explicit measured display geometry, angular positions, and Gaussian sigma.
- Normalized 0-to-1 drawing colors and frame-synchronized stimulus removal.
- Escape cancellation and automatic display/path/RNG cleanup.
- Generic demonstration conditions; no identifying fields or automatic data writes.

## Folder structure

```text
BasicTemporalReplicationTemplateOnMatlabUsingPsychtoolbox/
  main_temporal_replication_template.m
  functions/
  README.md
  DEPENDENCIES.md
  DESCRIPTION.txt
  LICENSE
  .gitignore
  .gitattributes
```

## Usage

1. Install MATLAB and Psychtoolbox separately (see `DEPENDENCIES.md`). The source uses MATLAB R2016b-or-newer language features; use a MATLAB version supported by your installed Psychtoolbox.
2. Open this repository as MATLAB's current folder. Run one template repository at a time; shared helpers deliberately have the same names.
3. Measure the active display width and height and the perpendicular eye-to-screen distance, in centimeters. The demo opens the highest-numbered screen full-screen; change `open_display` to select another screen if needed.
4. Call the entry point with your measurements:

```matlab
% EXAMPLE MEASUREMENTS ONLY: replace with your own measured values.
results = main_temporal_replication_template([50 30], 60);
```

Press SPACE to start and ESC to abort. Returned results stay in memory and are
not automatically saved. An abort/error closes the display and does not return
partial results. To save a completed run explicitly:

```matlab
if ~exist('results', 'dir'), mkdir('results'); end
save(fullfile('results', 'demo.mat'), 'results');
```

The optional save overwrites `demo.mat` if it exists. `results/` and common data
formats are ignored by Git. Use a new filename to retain multiple runs.

## Task and results

Six shuffled trials present three example durations twice each. After a 0.4-second retention interval, press and hold SPACE for the remembered duration, then release. The response queue timestamps the first fresh press and its release. A held key must be released before a new response. A 10-second deadline covers both press and release. `errorSec` is reproduced duration minus actual displayed duration; positive means over-reproduction.

All time values are seconds. Presentation timing includes requested duration,
frame count, actual onset/offset, actual duration, and the offset flip's missed
deadline value (positive indicates a missed deadline). Motion uses per-frame
logs instead. Timeout responses have `status = 'timeout'` and unavailable
measurements remain `NaN`; they must not be scored as zero responses.

## Consistent visual degrees

`create_geometry` uses separate horizontal and vertical pixels-per-centimeter
scales. Coordinates are measured from display center: positive x is right and
positive y is up. For each axis, position is projected as
`offsetCm = distanceCm * tand(angleDeg)`; `px_to_deg` is its inverse.
A centered object's full width in cm is `2*distanceCm*tand(widthDeg/2)`;
full width and eccentricity are different quantities.

`gaussian_blob_image` evaluates `exp(-(dxDeg^2+dyDeg^2)/(2*sigmaDeg^2))`
at pixel centers after inverse projection. The Gaussian therefore uses angular
sigma even away from screen center and on displays with unequal pixel scales.
Its support is truncated at +/-4 sigma; sigma is not the diameter.
The helper rejects off-screen support instead of silently clipping it.
These are separable horizontal/vertical tangent-angle coordinates on a flat
screen, not spherical retinal coordinates. Eye position must remain centered
and distance fixed. Pixel sampling and 8-bit intensity quantization limit
precision; display gamma is not calibrated by this template.

## Reusing and customizing functions

```matlab
addpath('functions');
g = create_geometry([1920 1080], [50 30], 60); % illustrative geometry only
pixelPosition = deg_to_px([4 2], g);
angularPosition = px_to_deg(pixelPosition, g);
[image, destinationRect] = gaussian_blob_image(g, [4 2], 0.35, 1);
% With an open Psychtoolbox window:
% texture = Screen('MakeTexture', window, image);
% Screen('DrawTexture', window, texture, [], destinationRect);
```

Edit positions, durations, repetitions, sigma, and seed near the main trial loop.
Contrast ranges from -1 (dark) through 0 (background) to 1 (bright).
The central fixation cross is drawn after the target, so it overlays any target
placed at the center. All conditions are illustrative, not a validated study protocol.

## License

MIT for the included template source and documentation. Dependencies are
separate and retain their own terms; see `DEPENDENCIES.md`.
