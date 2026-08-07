//////////////////////////////////////////////////////////////////////
// LibFile: analytical_intersections.scad
// Project: Strap Bender
// FileGroup: Analytical Path Kernel
// FileSummary: Exact nonlocal line/arc intersection and near-pass diagnostics.
//////////////////////////////////////////////////////////////////////

function sb_path_diag_clamp(value, low, high) =
    min(max(value, low), high);

function sb_path_diag_point_to_segment_distance(point, start, end) = let(
    segment = sb_vector_subtract(end, start),
    length_squared = sb_vector_dot(segment, segment),
    parameter = length_squared <= 0
        ? 0
        : sb_path_diag_clamp(
            sb_vector_dot(sb_vector_subtract(point, start), segment) /
                length_squared,
            0,
            1
        ),
    projection = sb_vector_add(start, sb_vector_scale(segment, parameter))
) sb_point_distance(point, projection);

function sb_path_diag_point_on_arc(
    primitive,
    point,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM
) = let(
    center = primitive_center(primitive),
    radius = primitive_inside_radius(primitive),
    relative = sb_vector_subtract(point, center),
    radial_distance = sb_vector_length(relative),
    candidate_angle = atan2(sb_point_y(relative), sb_point_x(relative))
) abs(radial_distance - radius) <= position_tolerance &&
    sb_angle_is_on_sweep(
        candidate_angle,
        sb_arc_start_radial_angle(primitive),
        primitive_angle_degrees(primitive)
    );

function sb_path_diag_arc_point_at_angle(primitive, angle_degrees) = [
    sb_point_x(primitive_center(primitive)) +
        primitive_inside_radius(primitive) * cos(angle_degrees),
    sb_point_y(primitive_center(primitive)) +
        primitive_inside_radius(primitive) * sin(angle_degrees)
];

function sb_path_diag_point_to_arc_distance(point, primitive) = let(
    center = primitive_center(primitive),
    radius = primitive_inside_radius(primitive),
    relative = sb_vector_subtract(point, center),
    radial_distance = sb_vector_length(relative),
    radial_angle = atan2(sb_point_y(relative), sb_point_x(relative)),
    start_point = sb_pose_point(primitive_start_pose(primitive)),
    end_point = sb_pose_point(primitive_end_pose(primitive))
) radial_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
    ? radius
    : sb_angle_is_on_sweep(
        radial_angle,
        sb_arc_start_radial_angle(primitive),
        primitive_angle_degrees(primitive)
      )
        ? abs(radial_distance - radius)
        : min(
            sb_point_distance(point, start_point),
            sb_point_distance(point, end_point)
        );

function sb_path_diag_line_arc_intersection_points(line, arc) = let(
    start = sb_pose_point(primitive_start_pose(line)),
    end = sb_pose_point(primitive_end_pose(line)),
    center = primitive_center(arc),
    direction = sb_vector_subtract(end, start),
    relative = sb_vector_subtract(start, center),
    a = sb_vector_dot(direction, direction),
    b = 2 * sb_vector_dot(relative, direction),
    c = sb_vector_dot(relative, relative) -
        pow(primitive_inside_radius(arc), 2),
    discriminant = b * b - 4 * a * c,
    roots = discriminant < -SB_NUMERIC_POSITION_TOLERANCE_MM
        ? []
        : let(root = sqrt(max(0, discriminant)))
          abs(discriminant) <= SB_NUMERIC_POSITION_TOLERANCE_MM
            ? [-b / (2 * a)]
            : [(-b - root) / (2 * a), (-b + root) / (2 * a)]
) [
    for (parameter = roots)
        if (parameter >= -SB_NUMERIC_POSITION_TOLERANCE_MM &&
            parameter <= 1 + SB_NUMERIC_POSITION_TOLERANCE_MM)
            let(point = sb_vector_add(
                start,
                sb_vector_scale(direction, parameter)
            ))
            if (sb_path_diag_point_on_arc(arc, point)) point
];

function sb_path_diag_line_arc_intersects(line, arc) =
    len(sb_path_diag_line_arc_intersection_points(line, arc)) > 0;

function sb_path_diag_line_line_distance(first, second) = let(
    first_start = sb_pose_point(primitive_start_pose(first)),
    first_end = sb_pose_point(primitive_end_pose(first)),
    second_start = sb_pose_point(primitive_start_pose(second)),
    second_end = sb_pose_point(primitive_end_pose(second))
) sb_segments_intersect(first_start, first_end, second_start, second_end)
    ? 0
    : min([
        sb_path_diag_point_to_segment_distance(
            first_start, second_start, second_end),
        sb_path_diag_point_to_segment_distance(
            first_end, second_start, second_end),
        sb_path_diag_point_to_segment_distance(
            second_start, first_start, first_end),
        sb_path_diag_point_to_segment_distance(
            second_end, first_start, first_end)
    ]);

function sb_path_diag_line_arc_distance(line, arc) =
    sb_path_diag_line_arc_intersects(line, arc)
        ? 0
        : let(
            line_start = sb_pose_point(primitive_start_pose(line)),
            line_end = sb_pose_point(primitive_end_pose(line)),
            arc_start = sb_pose_point(primitive_start_pose(arc)),
            arc_end = sb_pose_point(primitive_end_pose(arc)),
            line_vector = sb_vector_subtract(line_end, line_start),
            line_heading = sb_vector_heading_degrees(line_vector),
            normal_angles = [line_heading + 90, line_heading - 90],
            normal_candidates = [
                for (angle = normal_angles)
                    if (sb_angle_is_on_sweep(
                        angle,
                        sb_arc_start_radial_angle(arc),
                        primitive_angle_degrees(arc)
                    ))
                        sb_path_diag_point_to_segment_distance(
                            sb_path_diag_arc_point_at_angle(arc, angle),
                            line_start,
                            line_end
                        )
            ],
            candidates = concat([
                sb_path_diag_point_to_arc_distance(line_start, arc),
                sb_path_diag_point_to_arc_distance(line_end, arc),
                sb_path_diag_point_to_segment_distance(
                    arc_start, line_start, line_end),
                sb_path_diag_point_to_segment_distance(
                    arc_end, line_start, line_end)
            ], normal_candidates)
        ) min(candidates);

function sb_path_diag_circle_intersection_points(first, second) = let(
    first_center = primitive_center(first),
    second_center = primitive_center(second),
    first_radius = primitive_inside_radius(first),
    second_radius = primitive_inside_radius(second),
    center_vector = sb_vector_subtract(second_center, first_center),
    center_distance = sb_vector_length(center_vector),
    impossible = center_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM ||
        center_distance > first_radius + second_radius +
            SB_NUMERIC_POSITION_TOLERANCE_MM ||
        center_distance < abs(first_radius - second_radius) -
            SB_NUMERIC_POSITION_TOLERANCE_MM,
    along = impossible ? 0 :
        (first_radius * first_radius - second_radius * second_radius +
            center_distance * center_distance) / (2 * center_distance),
    height_squared = impossible ? -1 :
        first_radius * first_radius - along * along,
    unit = impossible ? [0, 0] : sb_vector_scale(
        center_vector, 1 / center_distance),
    base = impossible ? first_center : sb_vector_add(
        first_center, sb_vector_scale(unit, along)),
    perpendicular = [-sb_point_y(unit), sb_point_x(unit)],
    height = height_squared < 0 ? 0 : sqrt(max(0, height_squared)),
    raw_points = impossible ||
        height_squared < -SB_NUMERIC_POSITION_TOLERANCE_MM
        ? []
        : height <= SB_NUMERIC_POSITION_TOLERANCE_MM
            ? [base]
            : [
                sb_vector_add(base, sb_vector_scale(perpendicular, height)),
                sb_vector_subtract(base, sb_vector_scale(perpendicular, height))
            ]
) [
    for (point = raw_points)
        if (sb_path_diag_point_on_arc(first, point) &&
            sb_path_diag_point_on_arc(second, point)) point
];

function sb_path_diag_concentric_arcs_overlap(first, second) = let(
    same_center = sb_point_distance(
        primitive_center(first), primitive_center(second)) <=
            SB_NUMERIC_POSITION_TOLERANCE_MM,
    same_radius = abs(
        primitive_inside_radius(first) - primitive_inside_radius(second)) <=
            SB_NUMERIC_POSITION_TOLERANCE_MM,
    first_start = sb_pose_point(primitive_start_pose(first)),
    first_end = sb_pose_point(primitive_end_pose(first)),
    second_start = sb_pose_point(primitive_start_pose(second)),
    second_end = sb_pose_point(primitive_end_pose(second))
) same_center && same_radius && (
    sb_path_diag_point_on_arc(second, first_start) ||
    sb_path_diag_point_on_arc(second, first_end) ||
    sb_path_diag_point_on_arc(first, second_start) ||
    sb_path_diag_point_on_arc(first, second_end)
);

function sb_path_diag_arc_arc_intersects(first, second) =
    sb_path_diag_concentric_arcs_overlap(first, second) ||
    len(sb_path_diag_circle_intersection_points(first, second)) > 0;

function sb_path_diag_arc_axis_candidates(first, second) = let(
    center_vector = sb_vector_subtract(
        primitive_center(second), primitive_center(first)),
    center_distance = sb_vector_length(center_vector),
    axis_angle = center_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
        ? 0 : sb_vector_heading_degrees(center_vector)
) center_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
    ? []
    : concat(
        [
            for (angle = [axis_angle, axis_angle + 180])
                if (sb_angle_is_on_sweep(
                    angle,
                    sb_arc_start_radial_angle(first),
                    primitive_angle_degrees(first)
                ))
                    sb_path_diag_point_to_arc_distance(
                        sb_path_diag_arc_point_at_angle(first, angle),
                        second
                    )
        ],
        [
            for (angle = [axis_angle, axis_angle + 180])
                if (sb_angle_is_on_sweep(
                    angle,
                    sb_arc_start_radial_angle(second),
                    primitive_angle_degrees(second)
                ))
                    sb_path_diag_point_to_arc_distance(
                        sb_path_diag_arc_point_at_angle(second, angle),
                        first
                    )
        ]
    );

function sb_path_diag_arc_arc_distance(first, second) =
    sb_path_diag_arc_arc_intersects(first, second)
        ? 0
        : let(
            first_start = sb_pose_point(primitive_start_pose(first)),
            first_end = sb_pose_point(primitive_end_pose(first)),
            second_start = sb_pose_point(primitive_start_pose(second)),
            second_end = sb_pose_point(primitive_end_pose(second)),
            candidates = concat([
                sb_path_diag_point_to_arc_distance(first_start, second),
                sb_path_diag_point_to_arc_distance(first_end, second),
                sb_path_diag_point_to_arc_distance(second_start, first),
                sb_path_diag_point_to_arc_distance(second_end, first)
            ], sb_path_diag_arc_axis_candidates(first, second))
        ) min(candidates);

function sb_analytical_primitive_pair_distance(first, second) =
    primitive_kind(first) == "line" && primitive_kind(second) == "line"
        ? sb_path_diag_line_line_distance(first, second)
        : primitive_kind(first) == "line" && primitive_kind(second) == "arc"
            ? sb_path_diag_line_arc_distance(first, second)
            : primitive_kind(first) == "arc" && primitive_kind(second) == "line"
                ? sb_path_diag_line_arc_distance(second, first)
                : sb_path_diag_arc_arc_distance(first, second);

function sb_path_diag_bounds_distance(first_bounds, second_bounds) = let(
    dx = max(0,
        max(sb_bounds_min_x(first_bounds), sb_bounds_min_x(second_bounds)) -
        min(sb_bounds_max_x(first_bounds), sb_bounds_max_x(second_bounds))),
    dy = max(0,
        max(sb_bounds_min_y(first_bounds), sb_bounds_min_y(second_bounds)) -
        min(sb_bounds_max_y(first_bounds), sb_bounds_max_y(second_bounds)))
) sqrt(dx * dx + dy * dy);

function sb_analytical_primitives_adjacent(path, first_index, second_index) = let(
    primitive_count = len(analytical_path_primitives(path)),
    sequential = second_index == first_index + 1,
    closure_neighbor = analytical_path_closure(path) == "closed" &&
        primitive_count > 2 && first_index == 0 &&
        second_index == primitive_count - 1
) sequential || closure_neighbor;

function sb_analytical_nonlocal_index_pairs(path) = let(
    primitive_count = len(analytical_path_primitives(path))
) primitive_count < 2
    ? []
    : [
        for (first_index = [0 : primitive_count - 2])
            for (second_index = [first_index + 1 : primitive_count - 1])
                if (!sb_analytical_primitives_adjacent(
                    path, first_index, second_index))
                    [first_index, second_index]
    ];

function sb_path_diag_pair_from_indexes(path, pair, threshold_mm) = let(
    primitives = analytical_path_primitives(path),
    first = primitives[pair[0]],
    second = primitives[pair[1]],
    distance = sb_analytical_primitive_pair_distance(first, second),
    classification = distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
        ? "intersection" : "near"
) distance <= threshold_mm + SB_NUMERIC_POSITION_TOLERANCE_MM
    ? path_pair_diagnostic_spec(
        pair[0],
        pair[1],
        primitive_source_index(first),
        primitive_source_index(second),
        primitive_label(first),
        primitive_label(second),
        primitive_kind(first),
        primitive_kind(second),
        max(0, distance),
        classification
      )
    : undef;

function analyze_analytical_path_interactions(path, near_threshold_mm = 1) = let(
    pairs = sb_analytical_nonlocal_index_pairs(path),
    primitives = analytical_path_primitives(path),
    bounds_candidates = [
        for (pair = pairs)
            if (sb_path_diag_bounds_distance(
                analytical_primitive_bounds(primitives[pair[0]]),
                analytical_primitive_bounds(primitives[pair[1]])
            ) <= near_threshold_mm + SB_NUMERIC_POSITION_TOLERANCE_MM)
                pair
    ],
    interactions = [
        for (pair = bounds_candidates)
            let(diagnostic = sb_path_diag_pair_from_indexes(
                path, pair, near_threshold_mm))
            if (!is_undef(diagnostic)) diagnostic
    ]
) path_diagnostic_report_spec(
    analytical_path_name(path),
    near_threshold_mm,
    len(pairs),
    len(bounds_candidates),
    interactions,
    str(
        "Adjacent primitives, including the first/last pair of a closed path, ",
        "are intentional continuity neighbors and are excluded. Exact line/line, ",
        "line/arc, and arc/arc distance is evaluated only for bounding-box ",
        "candidates within the configured near threshold. The threshold is a ",
        "finished-inside-edge geometric diagnostic, not physical strap or fixture ",
        "clearance."
    )
);
