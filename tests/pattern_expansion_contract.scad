//////////////////////////////////////////////////////////////////////
// LibFile: pattern_expansion_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies scheduled values and repetition provenance.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../patterns/standard_patterns.scad>

pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
instance = pattern_instance_spec(
    name = "THREE_WAVE_EXPANSION_TEST",
    pattern_name = pattern_block_name(pattern),
    repeat_count = 3,
    parameters = [
        pattern_parameter_spec(
            "base_segment_mm",
            value_schedule_explicit([10, 20, 30])
        ),
        pattern_parameter_spec(
            "rising_segment_mm",
            value_schedule_explicit([40, 50, 60])
        ),
        pattern_parameter_spec("falling_segment_mm", 70),
        pattern_parameter_spec(
            "turn_angle_degrees",
            value_schedule_periodic([30, 45])
        ),
        pattern_parameter_spec(
            "inside_radius_mm",
            value_schedule_every_nth(1.6, 5, 2, 2)
        )
    ]
);

validate_pattern_instance(instance, pattern);
compilation = compile_pattern_instance(instance, pattern);
validate_pattern_compilation(compilation, instance, pattern);
commands = shape_commands(
    pattern_compilation_normalized_shape(compilation)
);
traces = pattern_compilation_provenance(compilation);

assert([for (wave = [0 : 2]) command_distance(commands[wave * 6])] ==
    [10, 20, 30], "Base-segment explicit schedule failed.");
assert([for (wave = [0 : 2]) command_distance(commands[wave * 6 + 2])] ==
    [40, 50, 60], "Rising-segment explicit schedule failed.");
assert([for (wave = [0 : 2]) command_distance(commands[wave * 6 + 4])] ==
    [70, 70, 70], "Falling-segment scalar schedule failed.");
assert([for (wave = [0 : 2]) command_angle_degrees(
    commands[wave * 6 + 1]
)] == [30, 45, 30], "Positive wave-angle schedule failed.");
assert([for (wave = [0 : 2]) command_angle_degrees(
    commands[wave * 6 + 3]
)] == [-60, -90, -60], "Reversing bend multiplier failed.");
assert([for (wave = [0 : 2]) command_inside_radius(
    commands[wave * 6 + 1]
)] == [1.6, 5, 1.6],
    "Radius schedule must resolve once per wave.");
assert([for (local = [1, 3, 5]) command_inside_radius(
    commands[6 + local]
)] == [5, 5, 5],
    "All bends in selected wave two must use R5.");
assert(command_label(commands[7]) ==
    "THREE_WAVE_EXPANSION_TEST/W2/RISE_BEND",
    "Expanded command label lost wave and local identity.");
assert(pattern_provenance_repetition_index(traces[7]) == 1 &&
    pattern_provenance_local_element_index(traces[7]) == 1 &&
    pattern_provenance_local_label(traces[7]) == "RISE_BEND",
    "Pattern provenance mapping failed.");

echo("STRAP BENDER PATTERN EXPANSION CONTRACT: PASS");
