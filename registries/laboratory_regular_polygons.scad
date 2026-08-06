//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_regular_polygons.scad
// Project: Strap Bender
// FileGroup: Laboratory Regular-Polygon Registry
// FileSummary: Registers mutable regular triangle, square, and pentagon sources.
//////////////////////////////////////////////////////////////////////

LABORATORY_REGULAR_POLYGONS = [
    regular_polygon_spec(
        name = "REGULAR_TRIANGLE_SIDE_100_R5",
        side_count = 3,
        dimension_kind = "side_length",
        dimension_value = 100,
        corner_radii = 5,
        center = [0, 0],
        first_vertex_angle_degrees = 90,
        start_vertex_index = 0,
        notes = str(
            "Equilateral sharp triangle governed by 100 mm side length, ",
            "with a common 5 mm desired finished inside radius."
        )
    ),
    regular_polygon_spec(
        name = "REGULAR_SQUARE_APOTHEM_50_R10",
        side_count = 4,
        dimension_kind = "apothem",
        dimension_value = 50,
        corner_radii = 10,
        center = [50, 50],
        first_vertex_angle_degrees = -135,
        start_vertex_index = 0,
        notes = str(
            "Sharp square with 50 mm center-to-side apothem. The generated ",
            "vertices match the 0–100 mm rounded-square example."
        )
    ),
    regular_polygon_spec(
        name = "REGULAR_PENTAGON_CIRCUMRADIUS_60_MIXED",
        side_count = 5,
        dimension_kind = "circumradius",
        dimension_value = 60,
        corner_radii = [1.6, 1.6, 5, 1.6, 1.6],
        center = [0, 0],
        first_vertex_angle_degrees = 90,
        start_vertex_index = 0,
        notes = str(
            "Regular pentagon governed by a 60 mm sharp circumradius. ",
            "Source vertex 2 uses a 5 mm radius; all others use 1.6 mm."
        )
    )
];
