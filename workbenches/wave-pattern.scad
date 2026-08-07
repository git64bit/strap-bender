//////////////////////////////////////////////////////////////////////
// LibFile: wave-pattern.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Authors a compact repeated S-wave without per-bend controls.
//////////////////////////////////////////////////////////////////////

/* [Wave count and angle] */
wave_count = 30; // [1:1:100]
turn_angle_degrees = 45; // positive; reversing bend uses -2 times this value

/* [Straight segment schedules] */
segment_schedule_mode = "constant"; // [constant,periodic,explicit]
base_segment_lengths_mm = [50];
rising_segment_lengths_mm = [50];
falling_segment_lengths_mm = [50];

/* [Finished inside radius by wave] */
bend_radius_mode = "every_nth"; // [constant,periodic,every_nth]
default_bend_radius_mm = 1.6;
selected_bend_radius_mm = 5;
radius_cycle_mm = [1.6, 1.6, 5];
radius_interval = 3; // [1:1:100]
radius_first_position = 3; // one-based, 1 through interval

/* [Diagnostic preview] */
show_diagnostic_preview = true;
sample_chord_error_mm = 0.1; // [0.001:0.001:1]
sample_max_angle_step_degrees = 15; // [1:1:45]
diagnostic_path_width_mm = 0.8; // [0.1:0.1:5]
diagnostic_path_height_mm = 0.4; // [0.1:0.1:3]
show_tangent_points = false;
tangent_marker_diameter_mm = 1.6; // [0.2:0.1:8]

/* [Bend-post fixture] */
show_bend_post_fixture = false;
strap_material_name_selected = "ULINE_S_1655_BLACK"; // [ULINE_S_1655_BLACK]
fixture_base_thickness_mm = 3; // [1:0.5:10]
fixture_base_margin_mm = 8; // [0:1:30]
fixture_post_height_mm = 18; // [15.875:0.125:30]
fixture_strap_clearance_mm = 0.25; // [0:0.05:3]
fixture_minimum_post_gap_mm = 1; // [0:0.1:10]
fixture_max_base_width_mm = 220; // positive millimetres
fixture_max_base_depth_mm = 220; // positive millimetres
fixture_tool_surface_chord_error_mm = 0.02; // [0.001:0.001:0.2]
fixture_tool_surface_max_angle_step_degrees = 5; // [1:1:30]

/* [Console report] */
report_level = "summary"; // [summary,full]

/* [Hidden] */
pattern_instance_name_selected = "CUSTOM_S_WAVE";
wave_repeat_count = wave_count;
wave_turn_angle_degrees = turn_angle_degrees;
wave_segment_schedule_mode = segment_schedule_mode;
wave_base_segment_lengths_mm = base_segment_lengths_mm;
wave_rising_segment_lengths_mm = rising_segment_lengths_mm;
wave_falling_segment_lengths_mm = falling_segment_lengths_mm;
wave_radius_mode = bend_radius_mode;
wave_default_radius_mm = default_bend_radius_mm;
wave_selected_radius_mm = selected_bend_radius_mm;
wave_radius_cycle_mm = radius_cycle_mm;
wave_radius_interval = radius_interval;
wave_radius_first_position = radius_first_position;
project_name_selected = "WAVE_PATTERN_LAB";
workbench_name = "wave_pattern";
render_mode = show_bend_post_fixture
    ? "bend_post_fixture"
    : show_diagnostic_preview
        ? "diagnostic_path" : "report_only";
include <../main.scad>
