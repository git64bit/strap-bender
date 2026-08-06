//////////////////////////////////////////////////////////////////////
// LibFile: analytical_scale_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Compiles the accepted 73-command scale example analytically.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_bend_programs.scad>

shape = named_record(
    LABORATORY_BEND_PROGRAMS,
    "THIRTY_SIX_BEND_SCALE_EXAMPLE",
    "bend program"
);

validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);
primitives = analytical_path_primitives(path);

assert(len(primitives) == 73,
    "Every explicit command must compile to one analytical primitive.");
assert(primitive_source_index(primitives[72]) == 72,
    "Scale compilation must preserve the last source index.");
assert(primitive_kind(primitives[72]) == "line",
    "Scale compilation must preserve final straight command kind.");
assert(analytical_path_length(path) >
    analytical_path_straight_length(path),
    "Analytical total must include positive arc length.");
assert(sb_analytical_primitives_continuous(primitives),
    "Scale compilation must remain pose- and station-continuous.");

report_analytical_path(path, "summary");
echo("STRAP BENDER ANALYTICAL SCALE CONTRACT: PASS");
