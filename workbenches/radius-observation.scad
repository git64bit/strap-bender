//////////////////////////////////////////////////////////////////////
// LibFile: radius-observation.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Captures one guarded observation from a named coupon trial.
//////////////////////////////////////////////////////////////////////

/* [Evidence gate] */
observation_ready = false;

/* [Printed source coupon] */
radius_coupon_name_selected = "ULINE_R90_TOOL_R1_6_EXPERIMENTAL"; // [ULINE_R90_TOOL_R1_6_EXPERIMENTAL,ULINE_R90_TOOL_R5_EXPERIMENTAL]

/* [Specimen measurements] */
specimen_id = "";
measured_width_mm = 0; // [0:0.01:30]
measured_thickness_mm = 0; // [0:0.001:2]

/* [Forming process] */
forming_method = "unset"; // [unset,cold,local_heat,global_heat,other]
forming_temperature_c = 0; // [-20:1:250]
dwell_seconds = 0; // [0:1:3600]
cooling_restraint = "unset"; // [unset,restrained,released_hot,not_applicable]
release_rest_seconds = 0; // [0:1:86400]

/* [Finished radius measurement] */
measured_finished_inside_radius_mm = 0; // [0:0.01:50]
measurement_method = "";
measured_date = "";
measurement_uncertainty_mm = 0; // [0:0.01:5]

/* [Notes] */
observation_notes = "";

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
calibration_trial_name_selected = "CUSTOM_CALIBRATION_TRIAL";
radius_observation_name_selected = "CUSTOM_RADIUS_OBSERVATION";
project_name_selected = "RADIUS_OBSERVATION_LAB";
workbench_name = "radius_observation";
render_mode = "report_only";
include <../main.scad>
