//////////////////////////////////////////////////////////////////////
// LibFile: radius-calibration.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Authors and renders one experimental radius-calibration coupon.
//////////////////////////////////////////////////////////////////////

/* [Tool geometry] */
strap_material_name_selected = "ULINE_S_1655_BLACK"; // [ULINE_S_1655_BLACK]
tool_inside_radius_mm = 1.6; // designed tool radius; not predicted finished radius
bend_angle_degrees = 90; // [-180:1:180]
entry_tangent_mm = 30; // [5:1:100]
exit_tangent_mm = 30; // [5:1:100]
form_depth_mm = 8; // [2:0.5:30]
form_height_mm = 18; // [15.875:0.125:30]

/* [Base] */
base_thickness_mm = 3; // [1:0.5:10]
base_margin_mm = 5; // [1:0.5:20]

/* [Tool surface tessellation] */
tool_surface_chord_error_mm = 0.02; // [0.005:0.005:0.1]
tool_surface_max_angle_step_degrees = 5; // [1:1:15]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
radius_coupon_name_selected = "CUSTOM_RADIUS_CALIBRATION_COUPON";
project_name_selected = "RADIUS_CALIBRATION_LAB";
workbench_name = "radius_calibration";
render_mode = "calibration_coupon";
include <../main.scad>
