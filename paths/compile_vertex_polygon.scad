//////////////////////////////////////////////////////////////////////
// LibFile: compile_vertex_polygon.scad
// Project: Strap Bender
// FileGroup: Vertex-Polygon Front End
// FileSummary: Compiles rounded ordered vertices to a normalized bend program.
//////////////////////////////////////////////////////////////////////

function sb_compile_polygon_corner(polygon, vertex_index) = let(
    vertices = vertex_polygon_vertices(polygon),
    radii = sb_vertex_polygon_resolved_corner_radii(polygon),
    vertex_count = len(vertices),
    previous_index = sb_polygon_previous_index(vertex_count, vertex_index),
    turn_angle = sb_polygon_vertex_turn_angle_degrees(
        vertices,
        vertex_index
    ),
    radius = radii[vertex_index],
    setback = sb_polygon_tangent_setback(radius, turn_angle)
) polygon_corner_spec(
    source_vertex_index = vertex_index,
    vertex = vertices[vertex_index],
    incoming_edge_index = previous_index,
    outgoing_edge_index = vertex_index,
    turn_angle_degrees = turn_angle,
    classification = sb_polygon_vertex_classification(
        vertices,
        vertex_index
    ),
    inside_radius = radius,
    tangent_setback = setback,
    entry_point = sb_polygon_vertex_entry_point(
        vertices,
        vertex_index,
        setback
    ),
    exit_point = sb_polygon_vertex_exit_point(
        vertices,
        vertex_index,
        setback
    ),
    bend_command_index = sb_polygon_corner_command_index(
        vertex_count,
        vertex_polygon_start_vertex_index(polygon),
        vertex_index
    )
);

function sb_compile_polygon_corners(polygon) = [
    for (vertex_index = [0 : len(vertex_polygon_vertices(polygon)) - 1])
        sb_compile_polygon_corner(polygon, vertex_index)
];

function sb_compile_polygon_edge(polygon, corners, edge_index) = let(
    vertex_count = len(vertex_polygon_vertices(polygon)),
    end_vertex_index = sb_polygon_next_index(vertex_count, edge_index),
    start_point = polygon_corner_exit_point(corners[edge_index]),
    end_point = polygon_corner_entry_point(corners[end_vertex_index]),
    edge_vector = sb_vector_subtract(end_point, start_point)
) polygon_edge_spec(
    source_edge_index = edge_index,
    start_vertex_index = edge_index,
    end_vertex_index = end_vertex_index,
    start_point = start_point,
    end_point = end_point,
    retained_length = sb_vector_length(edge_vector),
    heading_degrees = sb_vector_heading_degrees(edge_vector),
    straight_command_index = sb_polygon_edge_command_index(
        vertex_count,
        vertex_polygon_start_vertex_index(polygon),
        edge_index
    )
);

function sb_compile_polygon_edges(polygon, corners) = [
    for (edge_index = [0 : len(vertex_polygon_vertices(polygon)) - 1])
        sb_compile_polygon_edge(polygon, corners, edge_index)
];

function sb_polygon_command_sequence(
    polygon,
    corners,
    edges,
    sequence_index = 0
) = let(
    vertex_count = len(vertex_polygon_vertices(polygon)),
    start_vertex_index = vertex_polygon_start_vertex_index(polygon)
) sequence_index >= vertex_count
    ? []
    : let(
        edge_index = (start_vertex_index + sequence_index) % vertex_count,
        end_vertex_index = sb_polygon_next_index(vertex_count, edge_index),
        straight_index = 2 * sequence_index,
        bend_index = straight_index + 1
    ) concat(
        [
            straight_command(
                source_index = straight_index,
                distance = polygon_edge_retained_length(edges[edge_index]),
                label = str("E", edge_index)
            ),
            bend_command(
                source_index = bend_index,
                angle_degrees = polygon_corner_turn_angle_degrees(
                    corners[end_vertex_index]
                ),
                inside_radius = polygon_corner_inside_radius(
                    corners[end_vertex_index]
                ),
                label = str("V", end_vertex_index)
            )
        ],
        sb_polygon_command_sequence(
            polygon,
            corners,
            edges,
            sequence_index + 1
        )
    );

function compile_vertex_polygon(polygon) = let(
    corners = sb_compile_polygon_corners(polygon),
    edges = sb_compile_polygon_edges(polygon, corners),
    start_edge_index = vertex_polygon_start_vertex_index(polygon),
    start_point = polygon_edge_start_point(edges[start_edge_index]),
    normalized_shape = bend_program_shape_spec(
        name = vertex_polygon_name(polygon),
        commands = sb_polygon_command_sequence(polygon, corners, edges),
        closure = "closed",
        start_pose = start_pose_spec(
            sb_point_x(start_point),
            sb_point_y(start_point),
            polygon_edge_heading_degrees(edges[start_edge_index])
        ),
        notes = str(
            "Normalized from ordered sharp polygon vertices. Edge labels E# ",
            "and bend labels V# preserve source edge and vertex identity."
        )
    )
) polygon_compilation_spec(
    source_polygon_name = vertex_polygon_name(polygon),
    corners = corners,
    edges = edges,
    normalized_shape = normalized_shape,
    notes = str(
        "Circular tangent corners use desired finished inside radii. ",
        "The source polygon remains authoritative authoring intent."
    )
);
