//////////////////////////////////////////////////////////////////////
// LibFile: vertex-polygon.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Selects, compiles, reports, and previews one named polygon.
//////////////////////////////////////////////////////////////////////

/* [Vertex polygon] */
polygon_name_selected = "ROUNDED_SQUARE_EXAMPLE"; // [ROUNDED_SQUARE_EXAMPLE,CONCAVE_L_EXAMPLE]

/* [Diagnostic preview] */
show_diagnostic_preview = true;
sample_chord_error_mm = 0.05; // [0.001:0.001:1]
sample_max_angle_step_degrees = 10; // [1:1:45]
diagnostic_path_width_mm = 0.8; // [0.1:0.1:5]
diagnostic_path_height_mm = 0.4; // [0.1:0.1:3]
show_tangent_points = true;
tangent_marker_diameter_mm = 1.6; // [0.2:0.1:8]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
project_name_selected = "VERTEX_POLYGON_LAB";
workbench_name = "vertex_polygon";
render_mode = show_diagnostic_preview
    ? "diagnostic_path" : "report_only";
include <../main.scad>
