//////////////////////////////////////////////////////////////////////
// LibFile: long_wave_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies the 10-20 foot every-third-wave reference case.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../patterns/standard_patterns.scad>
include <../registries/laboratory_pattern_instances.scad>

pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
instance = named_record(
    LABORATORY_PATTERN_INSTANCES,
    "THIRTY_WAVE_EVERY_THIRD_R5",
    "pattern instance"
);

validate_pattern_instance(instance, pattern);
compilation = compile_pattern_instance(instance, pattern);
validate_pattern_compilation(compilation, instance, pattern);
shape = pattern_compilation_normalized_shape(compilation);
commands = shape_commands(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);
sampled = sample_analytical_path(path, 0.1, 15);
validate_sampled_path(sampled, path);

bends = [for (command = commands)
    if (command_kind(command) == "bend") command];
r5_bends = [for (command = bends)
    if (command_inside_radius(command) == 5) command];
r16_bends = [for (command = bends)
    if (command_inside_radius(command) == 1.6) command];
expected_length_mm = 4500 + 82 * PI;

assert(len(commands) == 180,
    "Thirty six-element waves must expand to 180 commands.");
assert(len(bends) == 90 && len(r5_bends) == 30 && len(r16_bends) == 60,
    "Every third wave must assign R5 to all three of its bends.");
for (wave_index = [0 : 29]) {
    expected_radius = (wave_index + 1) % 3 == 0 ? 5 : 1.6;
    assert([for (local_index = [1, 3, 5])
        command_inside_radius(commands[wave_index * 6 + local_index])
    ] == [expected_radius, expected_radius, expected_radius],
        str("Wave ", wave_index + 1,
            " did not preserve one radius across all local bends."));
}
assert(sb_near(analytical_path_straight_length(path), 4500, 0.000001),
    "Long-wave straight length changed unexpectedly.");
assert(sb_near(analytical_path_length(path), expected_length_mm, 0.000001),
    "Long-wave analytical length changed unexpectedly.");
assert(analytical_path_length(path) >= 10 * 12 * 25.4 &&
    analytical_path_length(path) <= 20 * 12 * 25.4,
    "Reference wave path must remain between 10 and 20 feet.");
assert(sb_near(pose_y(analytical_path_end_pose(path)), 0, 0.000001) &&
    sb_near(pose_heading_degrees(
        analytical_path_end_pose(path)
    ), 0, 0.000001),
    "Symmetric complete waves must return to baseline heading and Y.");
assert(len(sampled_path_points(sampled)) < 5000,
    "Diagnostic sampling expanded the reference wave excessively.");

echo(str("Long-wave analytical length: ",
    analytical_path_length(path), " mm"));
echo(str("Long-wave sampled points: ",
    len(sampled_path_points(sampled))));
echo("STRAP BENDER LONG-WAVE CONTRACT: PASS");
