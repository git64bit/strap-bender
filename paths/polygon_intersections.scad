//////////////////////////////////////////////////////////////////////
// LibFile: polygon_intersections.scad
// Project: Strap Bender
// FileGroup: Vertex-Polygon Diagnostics
// FileSummary: Detects nonadjacent intersections in the sharp source polygon.
//////////////////////////////////////////////////////////////////////

function sb_polygon_edges_adjacent(vertex_count, first_edge, second_edge) =
    first_edge == second_edge ||
    sb_polygon_next_index(vertex_count, first_edge) == second_edge ||
    sb_polygon_next_index(vertex_count, second_edge) == first_edge;

function sb_segment_side_value(line_start, line_end, point) =
    sb_vector_cross_z(
        sb_vector_subtract(line_end, line_start),
        sb_vector_subtract(point, line_start)
    );

function sb_segment_side_tolerance(
    line_start,
    line_end,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = position_tolerance * max(
    sb_vector_length(sb_vector_subtract(line_end, line_start)),
    1
);

function sb_point_in_segment_bounds(
    point,
    segment_start,
    segment_end,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) =
    sb_point_x(point) >= min(
        sb_point_x(segment_start),
        sb_point_x(segment_end)
    ) - position_tolerance &&
    sb_point_x(point) <= max(
        sb_point_x(segment_start),
        sb_point_x(segment_end)
    ) + position_tolerance &&
    sb_point_y(point) >= min(
        sb_point_y(segment_start),
        sb_point_y(segment_end)
    ) - position_tolerance &&
    sb_point_y(point) <= max(
        sb_point_y(segment_start),
        sb_point_y(segment_end)
    ) + position_tolerance;

function sb_point_on_segment(
    point,
    segment_start,
    segment_end,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) =
    abs(sb_segment_side_value(segment_start, segment_end, point)) <=
        sb_segment_side_tolerance(
            segment_start,
            segment_end,
            position_tolerance
        ) &&
    sb_point_in_segment_bounds(
        point,
        segment_start,
        segment_end,
        position_tolerance
    );

function sb_segments_intersect(
    first_start,
    first_end,
    second_start,
    second_end,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = let(
    first_tolerance = sb_segment_side_tolerance(
        first_start,
        first_end,
        position_tolerance
    ),
    second_tolerance = sb_segment_side_tolerance(
        second_start,
        second_end,
        position_tolerance
    ),
    second_start_side = sb_segment_side_value(
        first_start,
        first_end,
        second_start
    ),
    second_end_side = sb_segment_side_value(
        first_start,
        first_end,
        second_end
    ),
    first_start_side = sb_segment_side_value(
        second_start,
        second_end,
        first_start
    ),
    first_end_side = sb_segment_side_value(
        second_start,
        second_end,
        first_end
    ),
    proper_crossing =
        ((second_start_side > first_tolerance &&
          second_end_side < -first_tolerance) ||
         (second_start_side < -first_tolerance &&
          second_end_side > first_tolerance)) &&
        ((first_start_side > second_tolerance &&
          first_end_side < -second_tolerance) ||
         (first_start_side < -second_tolerance &&
          first_end_side > second_tolerance)),
    touching =
        sb_point_on_segment(
            second_start,
            first_start,
            first_end,
            position_tolerance
        ) ||
        sb_point_on_segment(
            second_end,
            first_start,
            first_end,
            position_tolerance
        ) ||
        sb_point_on_segment(
            first_start,
            second_start,
            second_end,
            position_tolerance
        ) ||
        sb_point_on_segment(
            first_end,
            second_start,
            second_end,
            position_tolerance
        )
) proper_crossing || touching;

function sb_polygon_self_intersection_pairs(
    vertices,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = len(vertices) < 4
    ? []
    : [
        for (first_edge = [0 : len(vertices) - 2])
            for (second_edge = [first_edge + 1 : len(vertices) - 1])
                if (!sb_polygon_edges_adjacent(
                    len(vertices),
                    first_edge,
                    second_edge
                ) && sb_segments_intersect(
                    vertices[first_edge],
                    vertices[sb_polygon_next_index(
                        len(vertices),
                        first_edge
                    )],
                    vertices[second_edge],
                    vertices[sb_polygon_next_index(
                        len(vertices),
                        second_edge
                    )],
                    position_tolerance
                ))
                    [first_edge, second_edge]
    ];

function sb_polygon_has_self_intersections(
    vertices,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = len(sb_polygon_self_intersection_pairs(
    vertices,
    position_tolerance
)) > 0;
