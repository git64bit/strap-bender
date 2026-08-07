//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_schema.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Data Model
// FileSummary: Constructor for coupon-linked physical calibration trials.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_CALIBRATION_TRIAL_RECORD =
    "strap_bender_calibration_trial";

function calibration_trial_spec(
    name,
    coupon_name,
    observation,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_CALIBRATION_TRIAL_RECORD,
    schema_version,
    name,
    coupon_name,
    observation,
    notes
];
