//////////////////////////////////////////////////////////////////////
// LibFile: concave_polygon_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies concave turn preservation and mixed corner radii.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

polygon = vertex_polygon_spec(
    name = "CONCAVE_L_POLYGON_TEST",
    vertices = [
        [0, 0],
        [120, 0],
        [120, 40],
        [60, 40],
        [60, 100],
        [0, 100]
    ],
    corner_radii = [5, 5, 5, 8, 5, 5],
    start_vertex_index = 0
);

validate_vertex_polygon(polygon);
compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(compilation, polygon);
corners = polygon_compilation_corners(compilation);
shape = polygon_compilation_normalized_shape(compilation);
commands = shape_commands(shape);

assert(len([
    for (corner = corners)
        if (polygon_corner_classification(corner) == "convex") corner
]) == 5,
    "Concave L polygon must contain five convex corners.");
assert(len([
    for (corner = corners)
        if (polygon_corner_classification(corner) == "concave") corner
]) == 1,
    "Concave L polygon must contain one concave corner.");
assert(polygon_corner_classification(corners[3]) == "concave" &&
    polygon_corner_turn_angle_degrees(corners[3]) == -90 &&
    polygon_corner_inside_radius(corners[3]) == 8,
    "Source vertex 3 concave turn or radius was not preserved.");
assert(command_label(commands[
    polygon_corner_bend_command_index(corners[3])
]) == "V3" &&
    command_angle_degrees(commands[
        polygon_corner_bend_command_index(corners[3])
    ]) == -90,
    "Normalized concave bend must retain source identity and turn direction.");

path = compile_bend_program(shape);
validate_analytical_path(path);
assert(analytical_path_closure_position_error(path) <= 0.000001 &&
    analytical_path_closure_angle_error(path) <= 0.000001,
    "Concave polygon must close positionally and tangentially.");
assert(sb_bounds_near(
    analytical_path_bounds(path),
    [0, 0, 120, 100],
    0.000001
), "Concave polygon analytical bounds failed.");

report_vertex_polygon(polygon, "summary");
echo("STRAP BENDER CONCAVE POLYGON CONTRACT: PASS");
