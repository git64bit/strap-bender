//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_vertex_polygons.scad
// Project: Strap Bender
// FileGroup: Laboratory Vertex-Polygon Registry
// FileSummary: Registers mutable rounded ordered-vertex polygon records.
//////////////////////////////////////////////////////////////////////

LABORATORY_VERTEX_POLYGONS = [
    vertex_polygon_spec(
        name = "ROUNDED_SQUARE_EXAMPLE",
        vertices = [
            [0, 0],
            [100, 0],
            [100, 100],
            [0, 100]
        ],
        corner_radii = 10,
        start_vertex_index = 0,
        notes = str(
            "Counter-clockwise 100 mm square with a common 10 mm desired ",
            "finished inside radius. It normalizes to four 80 mm straights ",
            "and four 90 degree bends."
        )
    ),
    vertex_polygon_spec(
        name = "CONCAVE_L_EXAMPLE",
        vertices = [
            [0, 0],
            [120, 0],
            [120, 40],
            [60, 40],
            [60, 100],
            [0, 100]
        ],
        corner_radii = [5, 5, 5, 8, 5, 5],
        start_vertex_index = 0,
        notes = str(
            "Simple counter-clockwise concave polygon. Source vertex 3 is ",
            "a right-turn concave corner using an 8 mm radius; all other ",
            "corners are convex and use 5 mm."
        )
    )
];
