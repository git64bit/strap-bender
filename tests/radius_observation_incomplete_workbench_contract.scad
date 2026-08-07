//////////////////////////////////////////////////////////////////////
// LibFile: radius_observation_incomplete_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Proves Ready remains non-fatal while required fields are incomplete.
//////////////////////////////////////////////////////////////////////

observation_ready = true;
radius_coupon_name_selected = "ULINE_R90_TOOL_R1_6_EXPERIMENTAL";
specimen_id = "";
measured_width_mm = 0;
measured_thickness_mm = 0;
forming_method = "unset";
forming_temperature_c = 0;
dwell_seconds = 0;
cooling_restraint = "unset";
release_rest_seconds = 0;
measured_finished_inside_radius_mm = 0;
measurement_method = "";
measured_date = "";
measurement_uncertainty_mm = 0;
observation_notes = "";
report_level = "full";
calibration_trial_name_selected = "INCOMPLETE_TRIAL";
radius_observation_name_selected = "INCOMPLETE_OBSERVATION";
project_name_selected = "RADIUS_OBSERVATION_LAB";
workbench_name = "radius_observation";
render_mode = "report_only";

include <../main.scad>

assert(wb_calibration_trial_ready,
    "Incomplete contract must exercise Observation ready = true.");
assert(!WORKBENCH_CALIBRATION_TRIAL_COMPLETE,
    "Incomplete observation must not be marked complete.");
assert(len(WORKBENCH_RADIUS_OBSERVATION_ISSUES) >= 1,
    "Incomplete observation must report at least one actionable issue.");
assert(is_undef(WORKBENCH_CALIBRATION_TRIAL),
    "Incomplete observation must not emit a calibration-trial evidence record.");

echo("STRAP BENDER INCOMPLETE RADIUS-OBSERVATION WORKBENCH CONTRACT: PASS");
