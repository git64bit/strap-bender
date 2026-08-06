//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_radius_schedule_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies explicit regular-polygon corner radii are preserved.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

radii = [1.6, 1.6, 5, 1.6, 1.6];
regular = regular_polygon_spec(
    name = "REGULAR_PENTAGON_RADIUS_TEST",
    side_count = 5,
    dimension_kind = "circumradius",
    dimension_value = 60,
    corner_radii = radii,
    center = [0, 0],
    first_vertex_angle_degrees = 90,
    start_vertex_index = 0
);

validate_regular_polygon(regular);
regular_compilation = compile_regular_polygon(regular);
validate_regular_polygon_compilation(regular_compilation, regular);
polygon = regular_polygon_compilation_vertex_polygon(
    regular_compilation
);
assert(vertex_polygon_corner_radii(polygon) == radii,
    "Regular-polygon explicit radius list must reach the vertex polygon.");

polygon_compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(polygon_compilation, polygon);
corners = polygon_compilation_corners(polygon_compilation);
shape = polygon_compilation_normalized_shape(polygon_compilation);
commands = shape_commands(shape);

assert(polygon_corner_inside_radius(corners[2]) == 5,
    "Source vertex 2 must preserve its 5 mm radius.");
assert(command_inside_radius(commands[
    polygon_corner_bend_command_index(corners[2])
]) == 5 && command_label(commands[
    polygon_corner_bend_command_index(corners[2])
]) == "V2",
    "Normalized bend V2 must preserve regular-source radius provenance.");
assert(len([for (corner_index = [0 : 4])
    if (polygon_corner_inside_radius(corners[corner_index]) !=
        radii[corner_index]) corner_index]) == 0,
    "Every regular-polygon radius must survive normalization.");

path = compile_bend_program(shape);
validate_analytical_path(path);
assert(analytical_path_closure_position_error(path) <= 0.000001 &&
    analytical_path_closure_angle_error(path) <= 0.000001,
    "Mixed-radius regular pentagon must remain closed.");

echo("STRAP BENDER REGULAR-POLYGON RADIUS SCHEDULE CONTRACT: PASS");
