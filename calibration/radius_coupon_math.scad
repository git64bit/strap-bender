//////////////////////////////////////////////////////////////////////
// LibFile: radius_coupon_math.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Mathematics
// FileSummary: Exact contact datums and bounded chordal surface resolution.
//////////////////////////////////////////////////////////////////////

function radius_coupon_turn_sign(coupon) =
    radius_coupon_bend_angle_degrees(coupon) < 0 ? -1 : 1;

function radius_coupon_abs_angle_degrees(coupon) =
    abs(radius_coupon_bend_angle_degrees(coupon));

function radius_coupon_entry_tangent_point(coupon) = [0, 0];

function radius_coupon_arc_center(coupon) = [
    0,
    radius_coupon_turn_sign(coupon) *
        radius_coupon_tool_inside_radius_mm(coupon)
];

function radius_coupon_exit_tangent_point(coupon) = let(
    angle = radius_coupon_abs_angle_degrees(coupon),
    sign = radius_coupon_turn_sign(coupon),
    radius = radius_coupon_tool_inside_radius_mm(coupon)
) [
    radius * sin(angle),
    sign * radius * (1 - cos(angle))
];

function radius_coupon_entry_leg_start(coupon) = [
    -radius_coupon_entry_tangent_mm(coupon),
    0
];

function radius_coupon_exit_leg_end(coupon) = let(
    point = radius_coupon_exit_tangent_point(coupon),
    angle = radius_coupon_bend_angle_degrees(coupon),
    length = radius_coupon_exit_tangent_mm(coupon)
) [
    point[0] + length * cos(angle),
    point[1] + length * sin(angle)
];

function radius_coupon_inside_normal(heading_degrees, turn_sign) = [
    -turn_sign * sin(heading_degrees),
    turn_sign * cos(heading_degrees)
];

function radius_coupon_arc_segment_count(coupon) = let(
    radius = radius_coupon_tool_inside_radius_mm(coupon),
    chord_limit = sb_arc_chord_angle_limit_degrees(
        radius,
        radius_coupon_tool_surface_chord_error_mm(coupon)
    ),
    step_limit = min(
        chord_limit,
        radius_coupon_tool_surface_max_angle_step_degrees(coupon)
    )
) max(
    1,
    ceil(radius_coupon_abs_angle_degrees(coupon) / step_limit)
);

function radius_coupon_actual_surface_sagitta_mm(coupon) = let(
    radius = radius_coupon_tool_inside_radius_mm(coupon),
    count = radius_coupon_arc_segment_count(coupon),
    step = radius_coupon_abs_angle_degrees(coupon) / count
) radius * (1 - cos(step / 2));

function radius_coupon_outer_arc_points(coupon) = let(
    center = radius_coupon_arc_center(coupon),
    radius = radius_coupon_tool_inside_radius_mm(coupon),
    sign = radius_coupon_turn_sign(coupon),
    sweep = radius_coupon_bend_angle_degrees(coupon),
    start_radial_angle = -90 * sign,
    count = radius_coupon_arc_segment_count(coupon)
) [
    for (index = [0 : count]) let(
        radial_angle = start_radial_angle + sweep * index / count
    ) [
        center[0] + radius * cos(radial_angle),
        center[1] + radius * sin(radial_angle)
    ]
];

function radius_coupon_inner_arc_points(coupon) = let(
    center = radius_coupon_arc_center(coupon),
    outer_radius = radius_coupon_tool_inside_radius_mm(coupon),
    inner_radius = max(
        0,
        outer_radius - radius_coupon_form_depth_mm(coupon)
    ),
    sign = radius_coupon_turn_sign(coupon),
    sweep = radius_coupon_bend_angle_degrees(coupon),
    start_radial_angle = -90 * sign,
    count = radius_coupon_arc_segment_count(coupon)
) inner_radius <= SB_NUMERIC_POSITION_TOLERANCE_MM
    ? [center]
    : [
        for (index = [count : -1 : 0]) let(
            radial_angle = start_radial_angle + sweep * index / count
        ) [
            center[0] + inner_radius * cos(radial_angle),
            center[1] + inner_radius * sin(radial_angle)
        ]
    ];

function radius_coupon_arc_band_polygon(coupon) = concat(
    radius_coupon_outer_arc_points(coupon),
    radius_coupon_inner_arc_points(coupon)
);

function radius_coupon_entry_strip_polygon(coupon) = let(
    start = radius_coupon_entry_leg_start(coupon),
    end = radius_coupon_entry_tangent_point(coupon),
    normal = radius_coupon_inside_normal(
        0,
        radius_coupon_turn_sign(coupon)
    ),
    depth = radius_coupon_form_depth_mm(coupon),
    offset = [normal[0] * depth, normal[1] * depth]
) [
    start,
    end,
    [end[0] + offset[0], end[1] + offset[1]],
    [start[0] + offset[0], start[1] + offset[1]]
];

function radius_coupon_exit_strip_polygon(coupon) = let(
    start = radius_coupon_exit_tangent_point(coupon),
    end = radius_coupon_exit_leg_end(coupon),
    normal = radius_coupon_inside_normal(
        radius_coupon_bend_angle_degrees(coupon),
        radius_coupon_turn_sign(coupon)
    ),
    depth = radius_coupon_form_depth_mm(coupon),
    offset = [normal[0] * depth, normal[1] * depth]
) [
    start,
    end,
    [end[0] + offset[0], end[1] + offset[1]],
    [start[0] + offset[0], start[1] + offset[1]]
];
