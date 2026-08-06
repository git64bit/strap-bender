//////////////////////////////////////////////////////////////////////
// LibFile: polygon_math.scad
// Project: Strap Bender
// FileGroup: Vertex-Polygon Front End
// FileSummary: Exact ordered-vertex, turn, and tangent-setback mathematics.
//////////////////////////////////////////////////////////////////////

function sb_vector_add(first, second) = [
    sb_point_x(first) + sb_point_x(second),
    sb_point_y(first) + sb_point_y(second)
];

function sb_vector_subtract(first, second) = [
    sb_point_x(first) - sb_point_x(second),
    sb_point_y(first) - sb_point_y(second)
];

function sb_vector_scale(vector, scale) = [
    sb_point_x(vector) * scale,
    sb_point_y(vector) * scale
];

function sb_vector_dot(first, second) =
    sb_point_x(first) * sb_point_x(second) +
    sb_point_y(first) * sb_point_y(second);

function sb_vector_cross_z(first, second) =
    sb_point_x(first) * sb_point_y(second) -
    sb_point_y(first) * sb_point_x(second);

function sb_vector_length(vector) =
    sqrt(pow(sb_point_x(vector), 2) + pow(sb_point_y(vector), 2));

function sb_vector_unit(vector) =
    let(length = sb_vector_length(vector))
    [sb_point_x(vector) / length, sb_point_y(vector) / length];

function sb_vector_heading_degrees(vector) =
    atan2(sb_point_y(vector), sb_point_x(vector));

function sb_polygon_previous_index(vertex_count, vertex_index) =
    (vertex_index - 1 + vertex_count) % vertex_count;

function sb_polygon_next_index(vertex_count, vertex_index) =
    (vertex_index + 1) % vertex_count;

function sb_polygon_edge_vector(vertices, edge_index) =
    sb_vector_subtract(
        vertices[sb_polygon_next_index(len(vertices), edge_index)],
        vertices[edge_index]
    );

function sb_polygon_edge_length(vertices, edge_index) =
    sb_vector_length(sb_polygon_edge_vector(vertices, edge_index));

function sb_polygon_signed_double_area(vertices) =
    sb_list_sum([
        for (vertex_index = [0 : len(vertices) - 1])
            let(next_index = sb_polygon_next_index(
                len(vertices),
                vertex_index
            ))
            sb_point_x(vertices[vertex_index]) *
                sb_point_y(vertices[next_index]) -
            sb_point_x(vertices[next_index]) *
                sb_point_y(vertices[vertex_index])
    ]);

function sb_polygon_orientation_sign(vertices) =
    sb_polygon_signed_double_area(vertices) > 0 ? 1 : -1;

function sb_polygon_orientation_name(vertices) =
    sb_polygon_orientation_sign(vertices) > 0
        ? "counter_clockwise" : "clockwise";

function sb_polygon_vertex_turn_angle_degrees(vertices, vertex_index) =
    let(
        vertex_count = len(vertices),
        previous_index = sb_polygon_previous_index(
            vertex_count,
            vertex_index
        ),
        next_index = sb_polygon_next_index(vertex_count, vertex_index),
        incoming = sb_vector_unit(sb_vector_subtract(
            vertices[vertex_index],
            vertices[previous_index]
        )),
        outgoing = sb_vector_unit(sb_vector_subtract(
            vertices[next_index],
            vertices[vertex_index]
        ))
    )
    atan2(
        sb_vector_cross_z(incoming, outgoing),
        sb_vector_dot(incoming, outgoing)
    );

function sb_polygon_vertex_classification(vertices, vertex_index) =
    sb_polygon_vertex_turn_angle_degrees(vertices, vertex_index) *
        sb_polygon_orientation_sign(vertices) > 0
            ? "convex" : "concave";

function sb_polygon_tangent_setback(radius, turn_angle_degrees) =
    radius * tan(abs(turn_angle_degrees) / 2);

function sb_polygon_vertex_entry_point(
    vertices,
    vertex_index,
    setback
) = let(
    vertex_count = len(vertices),
    previous_index = sb_polygon_previous_index(vertex_count, vertex_index),
    incoming_unit = sb_vector_unit(sb_vector_subtract(
        vertices[vertex_index],
        vertices[previous_index]
    ))
) sb_vector_subtract(
    vertices[vertex_index],
    sb_vector_scale(incoming_unit, setback)
);

function sb_polygon_vertex_exit_point(
    vertices,
    vertex_index,
    setback
) = let(
    vertex_count = len(vertices),
    next_index = sb_polygon_next_index(vertex_count, vertex_index),
    outgoing_unit = sb_vector_unit(sb_vector_subtract(
        vertices[next_index],
        vertices[vertex_index]
    ))
) sb_vector_add(
    vertices[vertex_index],
    sb_vector_scale(outgoing_unit, setback)
);

function sb_polygon_cyclic_offset(count, start_index, target_index) =
    (target_index - start_index + count) % count;

function sb_polygon_edge_command_index(
    vertex_count,
    start_vertex_index,
    edge_index
) = 2 * sb_polygon_cyclic_offset(
    vertex_count,
    start_vertex_index,
    edge_index
);

function sb_polygon_corner_command_index(
    vertex_count,
    start_vertex_index,
    vertex_index
) = let(
    offset = sb_polygon_cyclic_offset(
        vertex_count,
        start_vertex_index,
        vertex_index
    ),
    positive_step = offset == 0 ? vertex_count : offset
) 2 * positive_step - 1;
