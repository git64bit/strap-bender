//////////////////////////////////////////////////////////////////////
// LibFile: wave_pattern_scheduled_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes explicit segment arrays and every-third-wave radii.
//////////////////////////////////////////////////////////////////////

pattern_instance_name_selected = "CUSTOM_SCHEDULED_WAVE";
wave_repeat_count = 4;
wave_turn_angle_degrees = 40;
wave_segment_schedule_mode = "explicit";
wave_base_segment_lengths_mm = [40, 45, 50, 55];
wave_rising_segment_lengths_mm = [50, 55, 60, 65];
wave_falling_segment_lengths_mm = [60, 55, 50, 45];
wave_radius_mode = "every_nth";
wave_default_radius_mm = 1.6;
wave_selected_radius_mm = 5;
wave_radius_cycle_mm = [1.6, 1.6, 5];
wave_radius_interval = 3;
wave_radius_first_position = 3;
project_name_selected = "WAVE_PATTERN_LAB";
workbench_name = "wave_pattern";
render_mode = "report_only";
report_level = "summary";

include <../main.scad>

scheduled_compilation = compile_pattern_instance(
    WORKBENCH_PATTERN_INSTANCE,
    named_record(PATTERN_BLOCKS, "THREE_SEGMENT_S_WAVE", "pattern block")
);
scheduled_commands = shape_commands(
    pattern_compilation_normalized_shape(scheduled_compilation)
);
assert(len(scheduled_commands) == 24,
    "Four Customizer waves must expand to 24 commands.");
assert([for (local = [1, 3, 5]) command_inside_radius(
    scheduled_commands[12 + local]
)] == [5, 5, 5],
    "Customizer wave three must apply R5 to all local bends.");
assert(command_distance(scheduled_commands[18]) == 55 &&
    command_distance(scheduled_commands[20]) == 65 &&
    command_distance(scheduled_commands[22]) == 45,
    "Explicit Customizer segment arrays did not preserve wave four.");

echo("STRAP BENDER SCHEDULED WAVE WORKBENCH CONTRACT: PASS");
