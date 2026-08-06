//////////////////////////////////////////////////////////////////////
// LibFile: analytical_bounds.scad
// Project: Strap Bender
// FileGroup: Analytical Path Kernel
// FileSummary: Calculates exact line and circular-arc XY bounds.
//////////////////////////////////////////////////////////////////////

function sb_bounds_from_points(points) = [
    min([for (point = points) sb_point_x(point)]),
    min([for (point = points) sb_point_y(point)]),
    max([for (point = points) sb_point_x(point)]),
    max([for (point = points) sb_point_y(point)])
];

function sb_bounds_union(bounds_list) = [
    min([for (bounds = bounds_list) sb_bounds_min_x(bounds)]),
    min([for (bounds = bounds_list) sb_bounds_min_y(bounds)]),
    max([for (bounds = bounds_list) sb_bounds_max_x(bounds)]),
    max([for (bounds = bounds_list) sb_bounds_max_y(bounds)])
];

function sb_angle_is_on_sweep(
    candidate_degrees,
    start_degrees,
    sweep_degrees,
    tolerance = SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
) =
    sweep_degrees > 0
        ? sb_positive_mod(candidate_degrees - start_degrees, 360)
            <= sweep_degrees + tolerance
        : sb_positive_mod(start_degrees - candidate_degrees, 360)
            <= -sweep_degrees + tolerance;

function sb_arc_start_radial_angle(primitive) =
    pose_heading_degrees(primitive_start_pose(primitive)) +
    (primitive_angle_degrees(primitive) > 0 ? -90 : 90);

function sb_arc_cardinal_points(primitive) =
    let(
        center = primitive_center(primitive),
        radius = primitive_inside_radius(primitive),
        start_angle = sb_arc_start_radial_angle(primitive),
        sweep = primitive_angle_degrees(primitive)
    )
    [
        for (candidate = [0, 90, 180, 270])
            if (sb_angle_is_on_sweep(candidate, start_angle, sweep))
                [
                    sb_point_x(center) + radius * cos(candidate),
                    sb_point_y(center) + radius * sin(candidate)
                ]
    ];

function analytical_primitive_bounds(primitive) =
    primitive_kind(primitive) == "line"
        ? sb_bounds_from_points([
            sb_pose_point(primitive_start_pose(primitive)),
            sb_pose_point(primitive_end_pose(primitive))
        ])
        : sb_bounds_from_points(concat(
            [
                sb_pose_point(primitive_start_pose(primitive)),
                sb_pose_point(primitive_end_pose(primitive))
            ],
            sb_arc_cardinal_points(primitive)
        ));

function sb_analytical_path_bounds_from_primitives(primitives) =
    sb_bounds_union([
        for (primitive = primitives)
            analytical_primitive_bounds(primitive)
    ]);
