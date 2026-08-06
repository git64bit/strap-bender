//////////////////////////////////////////////////////////////////////
// LibFile: arbitrary_length_program_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Proves registries and main records have no fixed bend count.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_bend_programs.scad>

program = named_record(
    LABORATORY_BEND_PROGRAMS,
    "THIRTY_SIX_BEND_SCALE_EXAMPLE",
    "bend program"
);
commands = shape_commands(program);
straight_commands = [
    for (command = commands)
        if (command_kind(command) == "straight") command
];
bend_commands = [
    for (command = commands)
        if (command_kind(command) == "bend") command
];

validate_bend_program_shape(program);

assert(len(commands) == 73,
    "Scale example must contain 73 ordered commands.");
assert(len(straight_commands) == 37,
    "Scale example must contain 37 straight commands.");
assert(len(bend_commands) == 36,
    "Scale example must contain 36 bend commands.");
assert(command_inside_radius(commands[1]) == 1.6,
    "First bend radius schedule contract failed.");
assert(command_inside_radius(commands[5]) == 5,
    "Every-third-bend radius schedule contract failed.");
assert(command_source_index(commands[72]) == 72,
    "Arbitrary-length source-index contract failed.");

report_bend_program_shape(program, "summary");
echo("STRAP BENDER ARBITRARY-LENGTH PROGRAM CONTRACT: PASS");
