//////////////////////////////////////////////////////////////////////
// LibFile: compile_regular_polygon.scad
// Project: Strap Bender
// FileGroup: Regular-Polygon Front End
// FileSummary: Compiles a regular-polygon source to a vertex polygon.
//////////////////////////////////////////////////////////////////////

function compile_regular_polygon(polygon) = let(
    circumradius = sb_regular_polygon_resolved_circumradius(polygon),
    apothem = sb_regular_polygon_apothem_from_circumradius(
        regular_polygon_side_count(polygon),
        circumradius
    ),
    side_length = sb_regular_polygon_side_length_from_circumradius(
        regular_polygon_side_count(polygon),
        circumradius
    ),
    vertices = sb_regular_polygon_vertices(polygon),
    generated_vertex_polygon = vertex_polygon_spec(
        name = regular_polygon_name(polygon),
        vertices = vertices,
        corner_radii = regular_polygon_corner_radii(polygon),
        start_vertex_index = regular_polygon_start_vertex_index(polygon),
        notes = str(
            "Generated from regular-polygon source '",
            regular_polygon_name(polygon),
            "'. Sharp vertices remain derived authoring geometry."
        )
    )
) regular_polygon_compilation_spec(
    source_polygon_name = regular_polygon_name(polygon),
    resolved_circumradius = circumradius,
    resolved_apothem = apothem,
    resolved_side_length = side_length,
    vertices = vertices,
    generated_vertex_polygon = generated_vertex_polygon,
    notes = str(
        "The regular-polygon source remains authoritative. The generated ",
        "vertex polygon enters the shared rounded-polygon pipeline."
    )
);
