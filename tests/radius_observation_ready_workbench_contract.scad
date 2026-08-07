//////////////////////////////////////////////////////////////////////
// LibFile: radius_observation_ready_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Exercises a synthetic ready observation through main.scad.
//////////////////////////////////////////////////////////////////////

observation_ready = true;
radius_coupon_name_selected = "ULINE_R90_TOOL_R1_6_EXPERIMENTAL";
specimen_id = "SYNTH-READY";
measured_width_mm = 15.88;
measured_thickness_mm = 0.51;
forming_method = "cold";
forming_temperature_c = 21;
dwell_seconds = 30;
cooling_restraint = "not_applicable";
release_rest_seconds = 60;
measured_finished_inside_radius_mm = 2.1;
measurement_method = "synthetic workbench contract value";
measured_date = "2099-01-01";
measurement_uncertainty_mm = 0.1;
observation_notes = "TEST DATA ONLY; not physical PET evidence.";
report_level = "full";
calibration_trial_name_selected = "SYNTHETIC_READY_TRIAL";
radius_observation_name_selected = "SYNTHETIC_READY_OBSERVATION";
project_name_selected = "RADIUS_OBSERVATION_LAB";
workbench_name = "radius_observation";
render_mode = "report_only";

include <../main.scad>

echo("STRAP BENDER READY RADIUS-OBSERVATION WORKBENCH CONTRACT: PASS");
