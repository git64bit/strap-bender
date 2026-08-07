//////////////////////////////////////////////////////////////////////
// LibFile: bend-program.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Selects, samples, reports, and previews one named program.
//////////////////////////////////////////////////////////////////////

/* [Bend program] */
program_name_selected = "OPEN_MIXED_RADIUS_EXAMPLE"; // [OPEN_MIXED_RADIUS_EXAMPLE,THIRTY_SIX_BEND_SCALE_EXAMPLE]

/* [Diagnostic preview] */
show_diagnostic_preview = true;
sample_chord_error_mm = 0.05; // [0.001:0.001:1]
sample_max_angle_step_degrees = 10; // [1:1:45]
diagnostic_path_width_mm = 0.8; // [0.1:0.1:5]
diagnostic_path_height_mm = 0.4; // [0.1:0.1:3]
show_tangent_points = true;
tangent_marker_diameter_mm = 1.6; // [0.2:0.1:8]

/* [Bend-post fixture] */
show_bend_post_fixture = false;
strap_material_name_selected = "ULINE_S_1655_BLACK"; // [ULINE_S_1655_BLACK]
fixture_base_thickness_mm = 3; // [1:0.5:10]
fixture_base_margin_mm = 8; // [0:1:30]
fixture_post_height_mm = 18; // [15.875:0.125:30]
fixture_strap_clearance_mm = 0.25; // [0:0.05:3]
fixture_minimum_post_gap_mm = 1; // [0:0.1:10]
fixture_retention_mode = "arc_follower"; // [arc_follower,none]
fixture_follower_wall_thickness_mm = 2; // [0.8:0.2:6]
fixture_max_base_width_mm = 220; // positive millimetres
fixture_max_base_depth_mm = 220; // positive millimetres
fixture_tool_surface_chord_error_mm = 0.02; // [0.001:0.001:0.2]
fixture_tool_surface_max_angle_step_degrees = 5; // [1:1:30]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
project_name_selected = "BEND_PROGRAM_LAB";
workbench_name = "bend_program";
render_mode = show_bend_post_fixture
    ? "bend_post_fixture"
    : show_diagnostic_preview
        ? "diagnostic_path" : "report_only";
include <../main.scad>
