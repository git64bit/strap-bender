//////////////////////////////////////////////////////////////////////
// LibFile: closed_path_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies exact closure and extrema for a rounded square.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

commands = [
    straight_command(0, 100, "S0"),
    bend_command(1, 90, 10, "B0"),
    straight_command(2, 100, "S1"),
    bend_command(3, 90, 10, "B1"),
    straight_command(4, 100, "S2"),
    bend_command(5, 90, 10, "B2"),
    straight_command(6, 100, "S3"),
    bend_command(7, 90, 10, "B3")
];

shape = bend_program_shape_spec(
    name = "CLOSED_ROUNDED_SQUARE_TEST",
    commands = commands,
    closure = "closed",
    start_pose = start_pose_spec(0, 0, 0)
);

validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);
bounds = analytical_path_bounds(path);

tolerance = 0.000001;
expected_length = 400 + 20 * SB_PI;

assert(analytical_path_closure_position_error(path) <= tolerance,
    "Rounded square must close positionally.");
assert(analytical_path_closure_angle_error(path) <= tolerance,
    "Rounded square must close tangentially.");
assert(abs(analytical_path_length(path) - expected_length) <= tolerance,
    "Rounded-square path length calculation failed.");
assert(abs(sb_bounds_min_x(bounds) + 10) <= tolerance &&
    abs(sb_bounds_min_y(bounds) - 0) <= tolerance &&
    abs(sb_bounds_max_x(bounds) - 110) <= tolerance &&
    abs(sb_bounds_max_y(bounds) - 120) <= tolerance,
    "Rounded-square arc extrema contract failed.");
assert(len(analytical_path_primitives(path)) == 8,
    "Rounded square must contain four lines and four arcs.");

report_analytical_path(path, "summary");
echo("STRAP BENDER CLOSED PATH CONTRACT: PASS");
