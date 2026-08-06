//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_validation.scad
// Project: Strap Bender
// FileGroup: Validation
// FileSummary: Validates regular-polygon sources and compilations.
//////////////////////////////////////////////////////////////////////

function sb_regular_polygon_corner_radii_valid(radii, side_count) =
    is_num(radii)
        ? sb_finite_number(radii) && radii > 0
        : is_list(radii) && len(radii) == side_count &&
            len([
                for (radius = radii)
                    if (!sb_finite_number(radius) || radius <= 0) radius
            ]) == 0;

function sb_point_lists_near(
    first,
    second,
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) =
    is_list(first) && is_list(second) && len(first) == len(second) &&
    len([
        for (point_index = [0 : len(first) - 1])
            if (sb_point_distance(
                first[point_index],
                second[point_index]
            ) > tolerance)
                point_index
    ]) == 0;

function sb_regular_polygon_edges_match(
    vertices,
    expected_side_length,
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = len([
    for (edge_index = [0 : len(vertices) - 1])
        if (!sb_near(
            sb_polygon_edge_length(vertices, edge_index),
            expected_side_length,
            tolerance
        ))
            edge_index
]) == 0;

function sb_regular_polygon_vertices_match_radius(
    vertices,
    center,
    expected_circumradius,
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = len([
    for (vertex = vertices)
        if (!sb_near(
            sb_point_distance(center, vertex),
            expected_circumradius,
            tolerance
        ))
            vertex
]) == 0;

module validate_regular_polygon(polygon) {
    assert(is_list(polygon) && len(polygon) == 11,
        "Regular-polygon records must contain eleven fields.");
    assert(polygon[RP_RECORD_TYPE] == STRAP_BENDER_REGULAR_POLYGON_RECORD,
        "Invalid Strap Bender regular-polygon record type.");
    assert(sb_schema_version_valid(polygon[RP_SCHEMA_VERSION]),
        str("Unsupported regular-polygon schema version: ",
            polygon[RP_SCHEMA_VERSION]));
    assert(sb_nonempty_string(regular_polygon_name(polygon)),
        "Regular-polygon name must be a non-empty string.");
    assert(is_string(regular_polygon_notes(polygon)),
        "Regular-polygon notes must be a string.");
    assert(sb_nonnegative_integer(regular_polygon_side_count(polygon)) &&
        regular_polygon_side_count(polygon) >= 3,
        "Regular-polygon side count must be an integer of at least three.");
    assert(sb_regular_polygon_dimension_kind_valid(
        regular_polygon_dimension_kind(polygon)
    ), str("Unsupported regular-polygon dimension kind: ",
        regular_polygon_dimension_kind(polygon)));
    assert(sb_finite_number(regular_polygon_dimension_value(polygon)) &&
        regular_polygon_dimension_value(polygon) > 0,
        "Regular-polygon governing dimension must be positive and finite.");
    assert(sb_regular_polygon_corner_radii_valid(
        regular_polygon_corner_radii(polygon),
        regular_polygon_side_count(polygon)
    ), str(
        "Regular-polygon radii must be one positive value or one positive ",
        "value per side."
    ));
    assert(sb_point_valid(regular_polygon_center(polygon)),
        "Regular-polygon center must be a finite XY point.");
    assert(sb_finite_number(
        regular_polygon_first_vertex_angle_degrees(polygon)
    ), "Regular-polygon first-vertex angle must be finite.");
    assert(sb_nonnegative_integer(
        regular_polygon_start_vertex_index(polygon)
    ) && regular_polygon_start_vertex_index(polygon) <
        regular_polygon_side_count(polygon),
        "Regular-polygon start vertex index is outside the generated list.");
    assert(sb_finite_number(
        sb_regular_polygon_resolved_circumradius(polygon)
    ) && sb_regular_polygon_resolved_circumradius(polygon) > 0,
        "Regular-polygon resolved circumradius must be positive and finite.");
}

module validate_regular_polygon_compilation(compilation, source_polygon) {
    assert(is_list(compilation) && len(compilation) == 9,
        "Regular-polygon compilations must contain nine fields.");
    assert(compilation[RX_RECORD_TYPE] ==
        STRAP_BENDER_REGULAR_POLYGON_COMPILATION_RECORD,
        "Invalid regular-polygon compilation record type.");
    assert(sb_schema_version_valid(compilation[RX_SCHEMA_VERSION]),
        "Unsupported regular-polygon compilation schema version.");
    assert(regular_polygon_compilation_source_name(compilation) ==
        regular_polygon_name(source_polygon),
        "Regular-polygon compilation must preserve source identity.");
    assert(is_string(regular_polygon_compilation_notes(compilation)),
        "Regular-polygon compilation notes must be a string.");

    circumradius = regular_polygon_compilation_circumradius(compilation);
    apothem = regular_polygon_compilation_apothem(compilation);
    side_length = regular_polygon_compilation_side_length(compilation);
    vertices = regular_polygon_compilation_vertices(compilation);
    generated = regular_polygon_compilation_vertex_polygon(compilation);
    side_count = regular_polygon_side_count(source_polygon);
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM;

    assert(sb_near(
        circumradius,
        sb_regular_polygon_resolved_circumradius(source_polygon),
        tolerance
    ), "Resolved regular-polygon circumradius is inconsistent.");
    assert(sb_near(
        apothem,
        sb_regular_polygon_apothem_from_circumradius(
            side_count,
            circumradius
        ),
        tolerance
    ), "Resolved regular-polygon apothem is inconsistent.");
    assert(sb_near(
        side_length,
        sb_regular_polygon_side_length_from_circumradius(
            side_count,
            circumradius
        ),
        tolerance
    ), "Resolved regular-polygon side length is inconsistent.");
    assert(is_list(vertices) && len(vertices) == side_count &&
        len([for (vertex = vertices)
            if (!sb_point_valid(vertex)) vertex]) == 0,
        "Regular-polygon compilation must contain one finite vertex per side.");
    assert(sb_regular_polygon_edges_match(
        vertices,
        side_length,
        tolerance
    ), "Generated regular-polygon sharp edges are not equal.");
    assert(sb_regular_polygon_vertices_match_radius(
        vertices,
        regular_polygon_center(source_polygon),
        circumradius,
        tolerance
    ), "Generated regular-polygon vertices do not share one circumradius.");
    assert(sb_polygon_orientation_name(vertices) == "counter_clockwise",
        "Generated regular-polygon vertices must be counter-clockwise.");

    validate_vertex_polygon(generated);
    assert(vertex_polygon_name(generated) ==
        regular_polygon_name(source_polygon),
        "Generated vertex polygon must preserve source identity.");
    assert(sb_point_lists_near(
        vertex_polygon_vertices(generated),
        vertices,
        tolerance
    ), "Generated vertex polygon must contain the compiled sharp vertices.");
    assert(vertex_polygon_corner_radii(generated) ==
        sb_regular_polygon_resolved_corner_radii(source_polygon),
        "Generated vertex polygon must preserve resolved corner radii.");
    assert(vertex_polygon_start_vertex_index(generated) ==
        regular_polygon_start_vertex_index(source_polygon),
        "Generated vertex polygon must preserve the selected start vertex.");
}
