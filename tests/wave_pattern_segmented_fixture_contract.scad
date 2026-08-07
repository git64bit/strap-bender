//////////////////////////////////////////////////////////////////////
// LibFile: wave_pattern_segmented_fixture_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes the 30-wave source through segmented fixture routing.
//////////////////////////////////////////////////////////////////////

wave_repeat_count = 30;
wave_turn_angle_degrees = 45;
wave_segment_schedule_mode = "constant";
wave_base_segment_lengths_mm = [50];
wave_rising_segment_lengths_mm = [50];
wave_falling_segment_lengths_mm = [50];
wave_radius_mode = "every_nth";
wave_default_radius_mm = 1.6;
wave_selected_radius_mm = 5;
wave_radius_cycle_mm = [1.6, 1.6, 5];
wave_radius_interval = 3;
wave_radius_first_position = 3;
strap_material_name_selected = "ULINE_S_1655_BLACK";
fixture_base_thickness_mm = 3;
fixture_base_margin_mm = 8;
fixture_post_height_mm = 18;
fixture_strap_clearance_mm = 0.25;
fixture_minimum_post_gap_mm = 1;
fixture_retention_mode = "arc_follower";
fixture_follower_wall_thickness_mm = 2;
fixture_layout_mode = "segmented";
fixture_component_index = 0;
fixture_registration_mode = "pin_pair";
fixture_registration_pin_diameter_mm = 3;
fixture_registration_hole_clearance_mm = 0.3;
fixture_registration_tangent_spacing_mm = 8;
fixture_registration_normal_offset_mm = 3;
fixture_component_label_mode = "recessed_corner";
fixture_component_label_size_mm = 2.5;
fixture_component_label_depth_mm = 0.4;
fixture_max_base_width_mm = 220;
fixture_max_base_depth_mm = 220;
fixture_tool_surface_chord_error_mm = 0.02;
fixture_tool_surface_max_angle_step_degrees = 5;
project_name_selected = "WAVE_PATTERN_LAB";
workbench_name = "wave_pattern";
render_mode = "bend_post_fixture";
report_level = "summary";

include <../main.scad>

assert(wb_fixture_layout_mode == "segmented",
    "Long-wave fixture contract must preserve segmented layout mode.");
assert(wb_fixture_component_index == 0,
    "Long-wave fixture contract must preserve selected component index.");
assert(wb_fixture_registration_mode == "pin_pair" &&
    wb_fixture_component_label_mode == "recessed_corner",
    "Long-wave fixture contract must preserve segmented setup aids.");

echo("STRAP BENDER WAVE-PATTERN SEGMENTED FIXTURE CONTRACT: PASS");
