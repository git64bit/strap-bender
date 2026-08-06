//////////////////////////////////////////////////////////////////////
// LibFile: vertex_polygon_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies rounded ordered-vertex records and compilation.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

polygon = vertex_polygon_spec(
    name = "ROUNDED_SQUARE_POLYGON_TEST",
    vertices = [
        [0, 0],
        [100, 0],
        [100, 100],
        [0, 100]
    ],
    corner_radii = 10,
    start_vertex_index = 0
);

validate_vertex_polygon(polygon);
compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(compilation, polygon);
corners = polygon_compilation_corners(compilation);
edges = polygon_compilation_edges(compilation);
shape = polygon_compilation_normalized_shape(compilation);
commands = shape_commands(shape);
tolerance = 0.000001;

assert(len(vertex_polygon_corner_radii(polygon)) == 4,
    "A scalar polygon radius must resolve once per source vertex.");
assert(sb_polygon_orientation_name(vertex_polygon_vertices(polygon)) ==
    "counter_clockwise",
    "Rounded square orientation classification failed.");
assert(len([
    for (corner = corners)
        if (polygon_corner_classification(corner) == "convex") corner
]) == 4,
    "All rounded-square corners must classify as convex.");
assert(len(edges) == 4 && len(commands) == 8,
    "Rounded square must derive four edges and eight commands.");
assert(len([
    for (edge = edges)
        if (abs(polygon_edge_retained_length(edge) - 80) <= tolerance)
            edge
]) == 4,
    "A 100 mm square with 10 mm radii must retain 80 mm straights.");
assert(sb_point_distance(
    polygon_edge_start_point(edges[0]),
    [10, 0]
) <= tolerance,
    "Polygon start tangent point failed.");
assert(polygon_corner_bend_command_index(corners[0]) == 7,
    "The selected start corner must be the final closing bend.");
assert(polygon_corner_bend_command_index(corners[1]) == 1,
    "The next source vertex must become the first bend command.");
assert(command_kind(commands[0]) == "straight" &&
    command_label(commands[0]) == "E0" &&
    abs(command_distance(commands[0]) - 80) <= tolerance,
    "First normalized polygon command failed.");
assert(command_kind(commands[1]) == "bend" &&
    command_label(commands[1]) == "V1" &&
    command_angle_degrees(commands[1]) == 90 &&
    command_inside_radius(commands[1]) == 10,
    "First normalized polygon bend failed.");

path = compile_bend_program(shape);
validate_analytical_path(path);
assert(analytical_path_closure_position_error(path) <= tolerance &&
    analytical_path_closure_angle_error(path) <= tolerance,
    "Normalized rounded-square polygon must close exactly.");
assert(abs(analytical_path_length(path) - (320 + 20 * SB_PI)) <=
    tolerance,
    "Rounded-square polygon reference length failed.");
assert(sb_bounds_near(
    analytical_path_bounds(path),
    [0, 0, 100, 100],
    tolerance
), "Rounded-square polygon exact bounds failed.");

report_vertex_polygon(polygon, "summary");
report_polygon_compilation(compilation, "summary");
echo("STRAP BENDER VERTEX-POLYGON CONTRACT: PASS");
