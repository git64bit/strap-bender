//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_dimension_modes_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Proves equivalent side, radius, and apothem authorities.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

function square_source(name, kind, value) = regular_polygon_spec(
    name = name,
    side_count = 4,
    dimension_kind = kind,
    dimension_value = value,
    corner_radii = 10,
    center = [50, 50],
    first_vertex_angle_degrees = -135,
    start_vertex_index = 0
);

by_side = square_source("SQUARE_BY_SIDE", "side_length", 100);
by_radius = square_source(
    "SQUARE_BY_RADIUS",
    "circumradius",
    50 / cos(45)
);
by_apothem = square_source("SQUARE_BY_APOTHEM", "apothem", 50);

validate_regular_polygon(by_side);
validate_regular_polygon(by_radius);
validate_regular_polygon(by_apothem);
side_compilation = compile_regular_polygon(by_side);
radius_compilation = compile_regular_polygon(by_radius);
apothem_compilation = compile_regular_polygon(by_apothem);
validate_regular_polygon_compilation(side_compilation, by_side);
validate_regular_polygon_compilation(radius_compilation, by_radius);
validate_regular_polygon_compilation(apothem_compilation, by_apothem);

tolerance = 0.000001;
side_vertices = regular_polygon_compilation_vertices(side_compilation);
radius_vertices = regular_polygon_compilation_vertices(radius_compilation);
apothem_vertices = regular_polygon_compilation_vertices(apothem_compilation);

assert(sb_point_lists_near(side_vertices, radius_vertices, tolerance),
    "Side-length and circumradius authorities must generate equal vertices.");
assert(sb_point_lists_near(side_vertices, apothem_vertices, tolerance),
    "Side-length and apothem authorities must generate equal vertices.");
assert(sb_near(
    regular_polygon_compilation_side_length(apothem_compilation),
    100,
    tolerance
), "Apothem authority must resolve the expected square side length.");
assert(sb_near(
    regular_polygon_compilation_circumradius(side_compilation),
    50 / cos(45),
    tolerance
), "Side authority must resolve the expected square circumradius.");

side_polygon = regular_polygon_compilation_vertex_polygon(side_compilation);
radius_polygon = regular_polygon_compilation_vertex_polygon(
    radius_compilation
);
apothem_polygon = regular_polygon_compilation_vertex_polygon(
    apothem_compilation
);
side_path = compile_bend_program(
    polygon_compilation_normalized_shape(
        compile_vertex_polygon(side_polygon)
    )
);
radius_path = compile_bend_program(
    polygon_compilation_normalized_shape(
        compile_vertex_polygon(radius_polygon)
    )
);
apothem_path = compile_bend_program(
    polygon_compilation_normalized_shape(
        compile_vertex_polygon(apothem_polygon)
    )
);
validate_analytical_path(side_path);
validate_analytical_path(radius_path);
validate_analytical_path(apothem_path);

assert(sb_near(
    analytical_path_length(side_path),
    analytical_path_length(radius_path),
    tolerance
) && sb_near(
    analytical_path_length(side_path),
    analytical_path_length(apothem_path),
    tolerance
), "Equivalent dimension authorities must preserve analytical length.");
assert(sb_bounds_near(
    analytical_path_bounds(side_path),
    analytical_path_bounds(radius_path),
    tolerance
) && sb_bounds_near(
    analytical_path_bounds(side_path),
    analytical_path_bounds(apothem_path),
    tolerance
), "Equivalent dimension authorities must preserve exact bounds.");

echo("STRAP BENDER REGULAR-POLYGON DIMENSION MODES CONTRACT: PASS");
