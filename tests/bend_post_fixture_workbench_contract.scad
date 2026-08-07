//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_fixture_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes fixture rendering through the regular-polygon route.
//////////////////////////////////////////////////////////////////////

regular_polygon_name_selected = "CUSTOM_FIXTURE_SQUARE";
regular_side_count = 4;
regular_dimension_kind = "side_length";
regular_dimension_value_mm = 80;
regular_corner_radius_mode = "constant";
regular_corner_radius_mm = 5;
regular_scheduled_corner_radius_mm = 5;
regular_schedule_interval = 3;
regular_schedule_first_position = 3;
regular_first_vertex_angle_degrees = 45;
regular_center_x_mm = 0;
regular_center_y_mm = 0;
strap_material_name_selected = "ULINE_S_1655_BLACK";
fixture_base_thickness_mm = 3;
fixture_base_margin_mm = 8;
fixture_post_height_mm = 18;
fixture_max_base_width_mm = 220;
fixture_max_base_depth_mm = 220;
fixture_tool_surface_chord_error_mm = 0.02;
fixture_tool_surface_max_angle_step_degrees = 5;
project_name_selected = "REGULAR_POLYGON_LAB";
workbench_name = "regular_polygon";
render_mode = "bend_post_fixture";
report_level = "summary";

include <../main.scad>

assert(wb_render_mode == "bend_post_fixture",
    "Fixture workbench contract did not preserve render mode.");
assert(bend_post_fixture_radius_mode(WORKBENCH_BEND_POST_FIXTURE) ==
    "nominal_target",
    "Fixture workbench must use explicit uncompensated nominal radius mode.");
assert(bend_post_fixture_retention_mode(WORKBENCH_BEND_POST_FIXTURE) ==
    "none",
    "Batch 015 fixture workbench must remain open-top without retention.");

echo("STRAP BENDER BEND-POST FIXTURE WORKBENCH CONTRACT: PASS");
