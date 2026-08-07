//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_accessors.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Data Model
// FileSummary: Named accessors for coupon-linked calibration trials.
//////////////////////////////////////////////////////////////////////

function calibration_trial_name(trial) = trial[CT_NAME];
function calibration_trial_coupon_name(trial) = trial[CT_COUPON_NAME];
function calibration_trial_observation(trial) = trial[CT_OBSERVATION];
function calibration_trial_notes(trial) = trial[CT_NOTES];
