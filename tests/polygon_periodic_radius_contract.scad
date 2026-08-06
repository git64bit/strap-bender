//////////////////////////////////////////////////////////////////////
// LibFile: polygon_periodic_radius_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Routes compact radius schedules through both polygon front ends.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

square = vertex_polygon_spec(
    name = "SCHEDULED_VERTEX_SQUARE",
    vertices = [[0, 0], [100, 0], [100, 100], [0, 100]],
    corner_radii = value_schedule_periodic([2, 5], "alternating square"),
    start_vertex_index = 0
);
validate_vertex_polygon(square);
square_radii = sb_vertex_polygon_resolved_corner_radii(square);
assert(square_radii == [2, 5, 2, 5],
    "Vertex-polygon periodic radius schedule did not resolve correctly.");
square_compilation = compile_vertex_polygon(square);
validate_polygon_compilation(square_compilation, square);
assert([for (corner = polygon_compilation_corners(square_compilation))
    polygon_corner_inside_radius(corner)] == square_radii,
    "Vertex-polygon compilation did not preserve resolved schedule values.");

regular = regular_polygon_spec(
    name = "REGULAR_NONAGON_EVERY_THIRD_TEST",
    side_count = 9,
    dimension_kind = "side_length",
    dimension_value = 50,
    corner_radii = value_schedule_every_nth(
        default_value = 1.6,
        selected_value = 5,
        interval = 3,
        first_position = 3,
        label = "every third corner"
    ),
    center = [0, 0],
    first_vertex_angle_degrees = 90,
    start_vertex_index = 0
);
validate_regular_polygon(regular);
regular_radii = sb_regular_polygon_resolved_corner_radii(regular);
assert(regular_radii == [1.6, 1.6, 5, 1.6, 1.6, 5, 1.6, 1.6, 5],
    "Regular-polygon every-third schedule did not resolve correctly.");
regular_compilation = compile_regular_polygon(regular);
validate_regular_polygon_compilation(regular_compilation, regular);
generated = regular_polygon_compilation_vertex_polygon(regular_compilation);
assert(vertex_polygon_corner_radii(generated) == regular_radii,
    "Generated vertex polygon must contain the explicit resolved radii.");

polygon_compilation = compile_vertex_polygon(generated);
validate_polygon_compilation(polygon_compilation, generated);
commands = shape_commands(
    polygon_compilation_normalized_shape(polygon_compilation)
);
assert(len([for (command = commands)
    if (command_kind(command) == "bend" &&
        command_inside_radius(command) == 5) command]) == 3,
    "Exactly every third nonagon bend must use the 5 mm radius.");

path = compile_bend_program(
    polygon_compilation_normalized_shape(polygon_compilation)
);
validate_analytical_path(path);
assert(analytical_path_closure_position_error(path) <= 0.000001 &&
    analytical_path_closure_angle_error(path) <= 0.000001,
    "Scheduled regular polygon must remain exactly closed.");

echo("STRAP BENDER POLYGON PERIODIC-RADIUS CONTRACT: PASS");
