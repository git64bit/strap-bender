//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies regular-triangle generation and shared compilation.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

regular = regular_polygon_spec(
    name = "REGULAR_TRIANGLE_TEST",
    side_count = 3,
    dimension_kind = "side_length",
    dimension_value = 100,
    corner_radii = 5,
    center = [0, 0],
    first_vertex_angle_degrees = 90,
    start_vertex_index = 0
);

validate_regular_polygon(regular);
regular_compilation = compile_regular_polygon(regular);
validate_regular_polygon_compilation(regular_compilation, regular);

assert(sb_near(
    regular_polygon_compilation_side_length(regular_compilation),
    100,
    0.000001
), "Regular triangle must preserve its governing side length.");
assert(sb_near(
    regular_polygon_compilation_circumradius(regular_compilation),
    100 / (2 * sin(60)),
    0.000001
), "Regular triangle circumradius resolution failed.");
assert(sb_near(
    regular_polygon_compilation_apothem(regular_compilation),
    100 / (2 * tan(60)),
    0.000001
), "Regular triangle apothem resolution failed.");

polygon = regular_polygon_compilation_vertex_polygon(
    regular_compilation
);
polygon_compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(polygon_compilation, polygon);
corners = polygon_compilation_corners(polygon_compilation);

assert(len(corners) == 3,
    "Regular triangle must generate three rounded corners.");
assert(len([for (corner = corners)
    if (polygon_corner_classification(corner) != "convex") corner]) == 0,
    "Every regular triangle corner must be convex.");
assert(len([for (corner = corners)
    if (!sb_near(
        polygon_corner_turn_angle_degrees(corner),
        120,
        0.000001
    )) corner]) == 0,
    "Every counter-clockwise regular triangle turn must be 120 degrees.");

shape = polygon_compilation_normalized_shape(polygon_compilation);
path = compile_bend_program(shape);
validate_analytical_path(path);
assert(analytical_path_closure_position_error(path) <= 0.000001 &&
    analytical_path_closure_angle_error(path) <= 0.000001,
    "Generated regular triangle must close positionally and tangentially.");

report_regular_polygon(regular, "summary");
report_regular_polygon_compilation(regular_compilation, "summary");
echo("STRAP BENDER REGULAR-POLYGON CONTRACT: PASS");
