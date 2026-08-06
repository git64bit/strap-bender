//////////////////////////////////////////////////////////////////////
// LibFile: polygon_equivalence_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Compares polygon and explicit bend-program analytical output.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

function primitive_equivalent(first, second, tolerance) =
    primitive_kind(first) == primitive_kind(second) &&
    sb_pose_near(
        primitive_start_pose(first),
        primitive_start_pose(second),
        tolerance,
        tolerance
    ) &&
    sb_pose_near(
        primitive_end_pose(first),
        primitive_end_pose(second),
        tolerance,
        tolerance
    ) &&
    abs(primitive_length(first) - primitive_length(second)) <= tolerance &&
    (primitive_kind(first) == "line" ||
        (abs(primitive_angle_degrees(first) -
            primitive_angle_degrees(second)) <= tolerance &&
        abs(primitive_inside_radius(first) -
            primitive_inside_radius(second)) <= tolerance &&
        sb_point_distance(
            primitive_center(first),
            primitive_center(second)
        ) <= tolerance));

polygon = vertex_polygon_spec(
    "POLYGON_EQUIVALENCE_TEST",
    [[0, 0], [100, 0], [100, 100], [0, 100]],
    [10, 10, 10, 10]
);
validate_vertex_polygon(polygon);
polygon_compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(polygon_compilation, polygon);
polygon_path = compile_bend_program(
    polygon_compilation_normalized_shape(polygon_compilation)
);
validate_analytical_path(polygon_path);

explicit_shape = bend_program_shape_spec(
    name = "EXPLICIT_EQUIVALENCE_TEST",
    commands = [
        straight_command(0, 80, "E0"),
        bend_command(1, 90, 10, "V1"),
        straight_command(2, 80, "E1"),
        bend_command(3, 90, 10, "V2"),
        straight_command(4, 80, "E2"),
        bend_command(5, 90, 10, "V3"),
        straight_command(6, 80, "E3"),
        bend_command(7, 90, 10, "V0")
    ],
    closure = "closed",
    start_pose = start_pose_spec(10, 0, 0)
);
validate_bend_program_shape(explicit_shape);
explicit_path = compile_bend_program(explicit_shape);
validate_analytical_path(explicit_path);

polygon_primitives = analytical_path_primitives(polygon_path);
explicit_primitives = analytical_path_primitives(explicit_path);
tolerance = 0.000001;

assert(len(polygon_primitives) == len(explicit_primitives),
    "Equivalent polygon and explicit programs must have equal primitive counts.");
assert(len([
    for (primitive_index = [0 : len(polygon_primitives) - 1])
        if (!primitive_equivalent(
            polygon_primitives[primitive_index],
            explicit_primitives[primitive_index],
            tolerance
        )) primitive_index
]) == 0,
    "Polygon and explicit programs must produce equivalent primitives.");
assert(abs(analytical_path_length(polygon_path) -
    analytical_path_length(explicit_path)) <= tolerance,
    "Equivalent authoring routes must preserve analytical length.");
assert(sb_bounds_near(
    analytical_path_bounds(polygon_path),
    analytical_path_bounds(explicit_path),
    tolerance
), "Equivalent authoring routes must preserve exact bounds.");

echo("STRAP BENDER POLYGON EQUIVALENCE CONTRACT: PASS");
