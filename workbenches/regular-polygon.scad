//////////////////////////////////////////////////////////////////////
// LibFile: regular-polygon.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Authors and previews one schedule-capable regular polygon.
//////////////////////////////////////////////////////////////////////

/* [Regular polygon] */
side_count = 9; // integer, 3 or greater
dimension_kind = "side_length"; // [side_length,circumradius,apothem]
dimension_value_mm = 50; // positive millimetres
first_vertex_angle_degrees = 90;
center_x_mm = 0;
center_y_mm = 0;

/* [Corner radius schedule] */
corner_radius_mode = "every_nth"; // [constant,every_nth]
corner_radius_mm = 1.6; // default or common radius, positive millimetres
scheduled_corner_radius_mm = 5; // selected radius, positive millimetres
schedule_interval = 3; // [1:1:100]
schedule_first_position = 3; // one-based, 1 through interval

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
regular_polygon_name_selected = "CUSTOM_REGULAR_POLYGON";
regular_side_count = side_count;
regular_dimension_kind = dimension_kind;
regular_dimension_value_mm = dimension_value_mm;
regular_corner_radius_mode = corner_radius_mode;
regular_corner_radius_mm = corner_radius_mm;
regular_scheduled_corner_radius_mm = scheduled_corner_radius_mm;
regular_schedule_interval = schedule_interval;
regular_schedule_first_position = schedule_first_position;
regular_first_vertex_angle_degrees = first_vertex_angle_degrees;
regular_center_x_mm = center_x_mm;
regular_center_y_mm = center_y_mm;
project_name_selected = "REGULAR_POLYGON_LAB";
workbench_name = "regular_polygon";
render_mode = show_diagnostic_preview
    ? "diagnostic_path" : "report_only";
include <../main.scad>
