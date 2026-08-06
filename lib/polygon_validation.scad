//////////////////////////////////////////////////////////////////////
// LibFile: polygon_validation.scad
// Project: Strap Bender
// FileGroup: Vertex-Polygon Validation
// FileSummary: Validates source polygons and their normalized compilations.
//////////////////////////////////////////////////////////////////////

function sb_polygon_vertices_valid(vertices) =
    is_list(vertices) && len(vertices) >= 3 &&
    len([for (vertex = vertices) if (!sb_point_valid(vertex)) vertex]) == 0;

function sb_polygon_consecutive_vertices_distinct(
    vertices,
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = len([
    for (vertex_index = [0 : len(vertices) - 1])
        let(next_index = sb_polygon_next_index(len(vertices), vertex_index))
        if (sb_point_distance(
            vertices[vertex_index],
            vertices[next_index]
        ) <= tolerance)
            vertex_index
]) == 0;

function sb_polygon_corner_radii_valid(radii, vertex_count) =
    is_list(radii) && len(radii) == vertex_count &&
    len([
        for (radius = radii)
            if (!sb_finite_number(radius) || radius <= 0) radius
    ]) == 0;

function sb_polygon_turns_valid(
    vertices,
    angle_tolerance = SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
) = len([
    for (vertex_index = [0 : len(vertices) - 1])
        let(turn = sb_polygon_vertex_turn_angle_degrees(
            vertices,
            vertex_index
        ))
        if (abs(turn) <= angle_tolerance ||
            abs(turn) >= 180 - angle_tolerance)
                vertex_index
]) == 0;

function sb_vertex_polygon_radius_feasible(
    polygon,
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = let(
    vertices = vertex_polygon_vertices(polygon),
    radii = vertex_polygon_corner_radii(polygon),
    setbacks = [
        for (vertex_index = [0 : len(vertices) - 1])
            sb_polygon_tangent_setback(
                radii[vertex_index],
                sb_polygon_vertex_turn_angle_degrees(
                    vertices,
                    vertex_index
                )
            )
    ]
) len([
    for (edge_index = [0 : len(vertices) - 1])
        let(next_index = sb_polygon_next_index(len(vertices), edge_index))
        if (sb_polygon_edge_length(vertices, edge_index) -
            setbacks[edge_index] - setbacks[next_index] <= tolerance)
                edge_index
]) == 0;

module validate_vertex_polygon(polygon) {
    assert(is_list(polygon) && len(polygon) == 7,
        "Vertex-polygon records must contain seven fields.");
    assert(polygon[VP_RECORD_TYPE] == STRAP_BENDER_VERTEX_POLYGON_RECORD,
        "Invalid Strap Bender vertex-polygon record type.");
    assert(sb_schema_version_valid(polygon[VP_SCHEMA_VERSION]),
        str("Unsupported vertex-polygon schema version: ",
            polygon[VP_SCHEMA_VERSION]));
    assert(sb_nonempty_string(vertex_polygon_name(polygon)),
        "Vertex-polygon name must be a non-empty string.");
    assert(is_string(vertex_polygon_notes(polygon)),
        "Vertex-polygon notes must be a string.");

    vertices = vertex_polygon_vertices(polygon);
    radii = vertex_polygon_corner_radii(polygon);
    assert(sb_polygon_vertices_valid(vertices),
        "A vertex polygon must contain at least three finite XY vertices.");
    assert(sb_polygon_consecutive_vertices_distinct(vertices),
        "Consecutive polygon vertices, including closure, must be distinct.");
    assert(abs(sb_polygon_signed_double_area(vertices)) >
        SB_NUMERIC_POSITION_TOLERANCE_MM,
        "Vertex-polygon signed area must be nonzero.");
    assert(sb_polygon_turns_valid(vertices),
        str(
            "Every polygon vertex must define a nonzero turn strictly below ",
            "180 degrees."
        ));
    assert(sb_polygon_corner_radii_valid(radii, len(vertices)),
        str(
            "Corner radii must resolve to one finite positive value per ",
            "polygon vertex."
        ));
    assert(sb_nonnegative_integer(
        vertex_polygon_start_vertex_index(polygon)
    ) && vertex_polygon_start_vertex_index(polygon) < len(vertices),
        "Polygon start vertex index is outside the vertex list.");
    assert(sb_vertex_polygon_radius_feasible(polygon),
        str(
            "At least one polygon edge is fully consumed by neighboring ",
            "corner tangent setbacks."
        ));
}

module validate_polygon_corner(corner, expected_vertex_index) {
    assert(is_list(corner) && len(corner) == 13,
        "Derived polygon-corner records must contain thirteen fields.");
    assert(corner[PC_RECORD_TYPE] == STRAP_BENDER_POLYGON_CORNER_RECORD,
        "Invalid derived polygon-corner record type.");
    assert(sb_schema_version_valid(corner[PC_SCHEMA_VERSION]),
        "Unsupported derived polygon-corner schema version.");
    assert(polygon_corner_source_vertex_index(corner) ==
        expected_vertex_index,
        "Derived polygon-corner source index must match list position.");
    assert(sb_point_valid(polygon_corner_vertex(corner)) &&
        sb_point_valid(polygon_corner_entry_point(corner)) &&
        sb_point_valid(polygon_corner_exit_point(corner)),
        "Derived polygon-corner points must be finite XY points.");
    assert(sb_bend_angle_valid(
        polygon_corner_turn_angle_degrees(corner)
    ) && abs(polygon_corner_turn_angle_degrees(corner)) < 180,
        "Derived polygon-corner turn must be nonzero and below 180 degrees.");
    assert(polygon_corner_classification(corner) == "convex" ||
        polygon_corner_classification(corner) == "concave",
        "Derived polygon-corner classification is invalid.");
    assert(sb_finite_number(polygon_corner_inside_radius(corner)) &&
        polygon_corner_inside_radius(corner) > 0,
        "Derived polygon-corner radius must be positive.");
    assert(sb_finite_number(polygon_corner_tangent_setback(corner)) &&
        polygon_corner_tangent_setback(corner) > 0,
        "Derived polygon-corner setback must be positive.");
    assert(sb_nonnegative_integer(
        polygon_corner_bend_command_index(corner)
    ) && polygon_corner_bend_command_index(corner) % 2 == 1,
        "Derived polygon bend-command index must be odd and nonnegative.");
}

module validate_polygon_edge(edge, expected_edge_index) {
    assert(is_list(edge) && len(edge) == 10,
        "Derived polygon-edge records must contain ten fields.");
    assert(edge[PE_RECORD_TYPE] == STRAP_BENDER_POLYGON_EDGE_RECORD,
        "Invalid derived polygon-edge record type.");
    assert(sb_schema_version_valid(edge[PE_SCHEMA_VERSION]),
        "Unsupported derived polygon-edge schema version.");
    assert(polygon_edge_source_index(edge) == expected_edge_index,
        "Derived polygon-edge source index must match list position.");
    assert(sb_point_valid(polygon_edge_start_point(edge)) &&
        sb_point_valid(polygon_edge_end_point(edge)),
        "Derived polygon-edge endpoints must be finite XY points.");
    assert(sb_finite_number(polygon_edge_retained_length(edge)) &&
        polygon_edge_retained_length(edge) >
            SB_NUMERIC_POSITION_TOLERANCE_MM,
        "Derived polygon retained straight must be greater than zero.");
    assert(sb_finite_number(polygon_edge_heading_degrees(edge)),
        "Derived polygon-edge heading must be finite.");
    assert(sb_nonnegative_integer(
        polygon_edge_straight_command_index(edge)
    ) && polygon_edge_straight_command_index(edge) % 2 == 0,
        "Derived polygon straight-command index must be even.");
}

module validate_polygon_compilation(compilation, source_polygon) {
    assert(is_list(compilation) && len(compilation) == 7,
        "Polygon-compilation records must contain seven fields.");
    assert(compilation[PX_RECORD_TYPE] ==
        STRAP_BENDER_POLYGON_COMPILATION_RECORD,
        "Invalid polygon-compilation record type.");
    assert(sb_schema_version_valid(compilation[PX_SCHEMA_VERSION]),
        "Unsupported polygon-compilation schema version.");
    assert(polygon_compilation_source_name(compilation) ==
        vertex_polygon_name(source_polygon),
        "Polygon compilation must preserve its source polygon name.");
    assert(is_string(polygon_compilation_notes(compilation)),
        "Polygon-compilation notes must be a string.");

    corners = polygon_compilation_corners(compilation);
    edges = polygon_compilation_edges(compilation);
    vertex_count = len(vertex_polygon_vertices(source_polygon));
    assert(is_list(corners) && len(corners) == vertex_count,
        "Polygon compilation must contain one corner per source vertex.");
    assert(is_list(edges) && len(edges) == vertex_count,
        "Polygon compilation must contain one edge per source edge.");
    for (vertex_index = [0 : vertex_count - 1])
        validate_polygon_corner(corners[vertex_index], vertex_index);
    for (edge_index = [0 : vertex_count - 1])
        validate_polygon_edge(edges[edge_index], edge_index);

    normalized_shape = polygon_compilation_normalized_shape(compilation);
    validate_bend_program_shape(normalized_shape);
    assert(shape_name(normalized_shape) == vertex_polygon_name(source_polygon),
        "Normalized polygon shape must preserve source identity.");
    assert(shape_closure(normalized_shape) == "closed",
        "Vertex polygons must normalize to closed bend programs.");
    assert(len(shape_commands(normalized_shape)) == vertex_count * 2,
        "A rounded polygon must normalize to one straight and bend per vertex.");

    for (corner = corners) {
        command = shape_commands(normalized_shape)[
            polygon_corner_bend_command_index(corner)
        ];
        assert(command_kind(command) == "bend" &&
            command_label(command) == str(
                "V", polygon_corner_source_vertex_index(corner)
            ),
            "Derived bend command must preserve source vertex identity.");
    }

    for (edge = edges) {
        command = shape_commands(normalized_shape)[
            polygon_edge_straight_command_index(edge)
        ];
        assert(command_kind(command) == "straight" &&
            command_label(command) == str(
                "E", polygon_edge_source_index(edge)
            ),
            "Derived straight command must preserve source edge identity.");
    }
}
