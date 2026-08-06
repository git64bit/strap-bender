//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_scheduled_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes the every-nth radius Customizer route through main.scad.
//////////////////////////////////////////////////////////////////////

regular_polygon_name_selected = "CUSTOM_SCHEDULED_NONAGON";
regular_side_count = 9;
regular_dimension_kind = "side_length";
regular_dimension_value_mm = 50;
regular_corner_radius_mode = "every_nth";
regular_corner_radius_mm = 1.6;
regular_scheduled_corner_radius_mm = 5;
regular_schedule_interval = 3;
regular_schedule_first_position = 3;
regular_first_vertex_angle_degrees = 90;
regular_center_x_mm = 0;
regular_center_y_mm = 0;
project_name_selected = "REGULAR_POLYGON_LAB";
workbench_name = "regular_polygon";
render_mode = "report_only";
report_level = "summary";

include <../main.scad>

echo("STRAP BENDER SCHEDULED WORKBENCH CONTRACT: PASS");
