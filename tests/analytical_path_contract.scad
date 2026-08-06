//////////////////////////////////////////////////////////////////////
// LibFile: analytical_path_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies exact line, arc, station, pose, and bounds output.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

shape = bend_program_shape_spec(
    name = "ANALYTICAL_MIXED_RADIUS_TEST",
    commands = [
        straight_command(0, 120, "S0"),
        bend_command(1, 90, 1.6, "B0"),
        straight_command(2, 75, "S1"),
        bend_command(3, -45, 5, "B1"),
        straight_command(4, 40, "S2")
    ],
    closure = "open",
    start_pose = start_pose_spec(0, 0, 0)
);

validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);
primitives = analytical_path_primitives(path);
end_pose = analytical_path_end_pose(path);
bounds = analytical_path_bounds(path);

tolerance = 0.000001;
expected_length = 120 + 1.6 * SB_PI / 2 + 75 + 5 * SB_PI / 4 + 40;
expected_end_x = 123.06446609406726 + 40 * cos(45);
expected_end_y = 80.13553390593274 + 40 * sin(45);

assert(len(primitives) == 5,
    "Mixed-radius program must compile to five analytical primitives.");
assert(primitive_kind(primitives[0]) == "line" &&
    primitive_kind(primitives[1]) == "arc",
    "Straight and bend commands must compile to line and arc primitives.");
assert(sb_point_distance(primitive_center(primitives[1]), [120, 1.6])
    <= tolerance,
    "Left-bend center calculation failed.");
assert(sb_point_distance(primitive_center(primitives[3]), [126.6, 76.6])
    <= tolerance,
    "Right-bend center calculation failed.");
assert(abs(analytical_path_length(path) - expected_length) <= tolerance,
    "Inside-reference path length calculation failed.");
assert(abs(pose_x(end_pose) - expected_end_x) <= tolerance &&
    abs(pose_y(end_pose) - expected_end_y) <= tolerance,
    "Mixed-radius endpoint calculation failed.");
assert(abs(pose_heading_degrees(end_pose) - 45) <= tolerance,
    "Mixed-radius endpoint heading failed.");
assert(abs(sb_bounds_min_x(bounds) - 0) <= tolerance &&
    abs(sb_bounds_min_y(bounds) - 0) <= tolerance &&
    abs(sb_bounds_max_x(bounds) - expected_end_x) <= tolerance &&
    abs(sb_bounds_max_y(bounds) - expected_end_y) <= tolerance,
    "Exact analytical bounds calculation failed.");
assert(primitive_source_index(primitives[4]) == 4,
    "Source-command provenance must survive compilation.");

report_analytical_path(path, "summary");
echo("STRAP BENDER ANALYTICAL PATH CONTRACT: PASS");
