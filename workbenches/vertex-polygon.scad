//////////////////////////////////////////////////////////////////////
// LibFile: vertex-polygon.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Selects, compiles, reports, and previews one named polygon.
//////////////////////////////////////////////////////////////////////

/* [Vertex polygon] */
polygon_name_selected = "ROUNDED_SQUARE_EXAMPLE"; // [ROUNDED_SQUARE_EXAMPLE,CONCAVE_L_EXAMPLE]

/* [Analytical path diagnostics] */
path_diagnostics_enabled = true;
path_near_threshold_mm = 1; // [0:0.1:20]
/* [Nominal strap cut plan] */
cut_plan_enabled = true;
cut_development_mode = "nominal_mid_thickness"; // [nominal_mid_thickness,custom_fraction]
cut_neutral_axis_fraction = 0.5; // [0:0.05:1]
cut_start_allowance_mm = 0; // [0:1:500]
cut_end_allowance_mm = 0; // [0:1:500]
cut_closure_mode = "none"; // [none,butt,overlap]
cut_closure_overlap_mm = 0; // [0:1:500]
cut_joining_allowance_mm = 0; // [0:1:500]
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
fixture_layout_mode = "auto"; // [auto,full_form,segmented]
fixture_component_index = 0; // nonnegative; used when segmented

/* [Segmented setup aids] */
fixture_registration_mode = "pin_pair"; // [pin_pair,none]
fixture_registration_pin_diameter_mm = 3; // [1:0.1:8]
fixture_registration_hole_clearance_mm = 0.3; // [0:0.05:1]
fixture_registration_tangent_spacing_mm = 8; // [4:0.5:20]
fixture_registration_normal_offset_mm = 3; // [2:0.5:15]
fixture_component_label_mode = "recessed_corner"; // [recessed_corner,none]
fixture_component_label_size_mm = 2.5; // [1:0.25:6]
fixture_component_label_depth_mm = 0.4; // [0.1:0.1:1]
fixture_max_base_width_mm = 220; // positive millimetres
fixture_max_base_depth_mm = 220; // positive millimetres
fixture_tool_surface_chord_error_mm = 0.02; // [0.001:0.001:0.2]
fixture_tool_surface_max_angle_step_degrees = 5; // [1:1:30]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
project_name_selected = "VERTEX_POLYGON_LAB";
workbench_name = "vertex_polygon";
render_mode = show_bend_post_fixture
    ? "bend_post_fixture"
    : show_diagnostic_preview
        ? "diagnostic_path" : "report_only";
include <../main.scad>
