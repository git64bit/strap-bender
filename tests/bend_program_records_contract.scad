//////////////////////////////////////////////////////////////////////
// LibFile: bend_program_records_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Validates a mixed-radius explicit bend program.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

commands = [
    straight_command(0, 120, "S0"),
    bend_command(1, 90, 1.6, "B0"),
    straight_command(2, 75, "S1"),
    bend_command(3, -45, 5, "B1"),
    straight_command(4, 40, "S2")
];

shape = bend_program_shape_spec(
    name = "MIXED_RADIUS_RECORD_TEST",
    commands = commands,
    closure = "open",
    start_pose = start_pose_spec(0, 0, 0),
    notes = "Record and validation contract only."
);

validate_bend_program_shape(shape);

assert(command_source_index(commands[4]) == 4,
    "Source-index contract failed.");
assert(command_inside_radius(commands[1]) == 1.6,
    "Small-radius record contract failed.");
assert(command_inside_radius(commands[3]) == 5,
    "Large-radius record contract failed.");
assert(shape_closure(shape) == "open",
    "Open-path record contract failed.");

echo("STRAP BENDER BEND-PROGRAM RECORDS CONTRACT: PASS");
