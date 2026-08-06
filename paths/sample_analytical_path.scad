//////////////////////////////////////////////////////////////////////
// LibFile: sample_analytical_path.scad
// Project: Strap Bender
// FileGroup: Analytical Path Consumer
// FileSummary: Samples exact line and arc primitives for display only.
//////////////////////////////////////////////////////////////////////

SB_DEFAULT_SAMPLE_CHORD_ERROR_MM = 0.05;
SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES = 10;
SB_MAX_SAMPLED_PATH_POINTS = 100000;

function sb_sampling_chord_error_valid(value) =
    sb_finite_number(value) && value > 0;

function sb_sampling_max_angle_step_valid(value) =
    sb_finite_number(value) && value > 0 && value <= 180;

function sb_arc_chord_angle_limit_degrees(radius, chord_error_mm) =
    chord_error_mm >= radius
        ? 180
        : max(
            SB_NUMERIC_ANGLE_TOLERANCE_DEGREES,
            2 * acos(1 - chord_error_mm / radius)
        );

function sb_arc_sample_count(
    primitive,
    chord_error_mm = SB_DEFAULT_SAMPLE_CHORD_ERROR_MM,
    max_angle_step_degrees = SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES
) =
    assert(sb_sampling_chord_error_valid(chord_error_mm),
        "Sampling chord error must be finite and greater than zero.")
    assert(sb_sampling_max_angle_step_valid(max_angle_step_degrees),
        "Sampling maximum angular step must be within (0, 180].")
    let(
        chord_limit = sb_arc_chord_angle_limit_degrees(
            primitive_inside_radius(primitive),
            chord_error_mm
        ),
        step_limit = min(chord_limit, max_angle_step_degrees)
    )
    max(1, ceil(abs(primitive_angle_degrees(primitive)) / step_limit));

function sb_arc_sample_sagitta_mm(primitive, sample_count) =
    primitive_inside_radius(primitive) *
    (1 - cos(
        abs(primitive_angle_degrees(primitive)) /
        (2 * sample_count)
    ));

function sb_sample_analytical_primitive_points(
    primitive,
    chord_error_mm = SB_DEFAULT_SAMPLE_CHORD_ERROR_MM,
    max_angle_step_degrees = SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES,
    include_start = true
) =
    primitive_kind(primitive) == "line"
        ? include_start
            ? [
                sb_pose_point(primitive_start_pose(primitive)),
                sb_pose_point(primitive_end_pose(primitive))
            ]
            : [sb_pose_point(primitive_end_pose(primitive))]
        : let(
            sample_count = sb_arc_sample_count(
                primitive,
                chord_error_mm,
                max_angle_step_degrees
            ),
            first_index = include_start ? 0 : 1,
            start_point = sb_pose_point(primitive_start_pose(primitive)),
            end_point = sb_pose_point(primitive_end_pose(primitive)),
            center = primitive_center(primitive),
            sweep = primitive_angle_degrees(primitive)
        )
        [
            for (sample_index = [first_index : sample_count])
                sample_index == 0
                    ? start_point
                    : sample_index == sample_count
                        ? end_point
                        : sb_rotate_point_about(
                            start_point,
                            center,
                            sweep * sample_index / sample_count
                        )
        ];

function sb_sample_analytical_path_points(
    path,
    chord_error_mm = SB_DEFAULT_SAMPLE_CHORD_ERROR_MM,
    max_angle_step_degrees = SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES
) =
    let(primitives = analytical_path_primitives(path))
    [
        for (primitive_index = [0 : len(primitives) - 1])
            each sb_sample_analytical_primitive_points(
                primitives[primitive_index],
                chord_error_mm,
                max_angle_step_degrees,
                primitive_index == 0
            )
    ];

function sb_sampled_path_point_count(
    path,
    chord_error_mm = SB_DEFAULT_SAMPLE_CHORD_ERROR_MM,
    max_angle_step_degrees = SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES
) =
    1 + sb_list_sum([
        for (primitive = analytical_path_primitives(path))
            primitive_kind(primitive) == "line"
                ? 1
                : sb_arc_sample_count(
                    primitive,
                    chord_error_mm,
                    max_angle_step_degrees
                )
    ]);

function sample_analytical_path(
    path,
    chord_error_mm = SB_DEFAULT_SAMPLE_CHORD_ERROR_MM,
    max_angle_step_degrees = SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES
) =
    assert(sb_sampling_chord_error_valid(chord_error_mm),
        "Sampling chord error must be finite and greater than zero.")
    assert(sb_sampling_max_angle_step_valid(max_angle_step_degrees),
        "Sampling maximum angular step must be within (0, 180].")
    assert(sb_sampled_path_point_count(
        path,
        chord_error_mm,
        max_angle_step_degrees
    ) <= SB_MAX_SAMPLED_PATH_POINTS,
        str("Sampling request exceeds the supported point limit of ",
            SB_MAX_SAMPLED_PATH_POINTS, "."))
    sampled_path_spec(
        name = analytical_path_name(path),
        reference_axis = analytical_path_reference_axis(path),
        closure = analytical_path_closure(path),
        points = sb_sample_analytical_path_points(
            path,
            chord_error_mm,
            max_angle_step_degrees
        ),
        chord_error_mm = chord_error_mm,
        max_angle_step_degrees = max_angle_step_degrees,
        notes = str(
            "Derived display polyline only. Exact measurements, bounds, ",
            "stations, and fixture datums remain properties of the analytical ",
            "line-and-arc path."
        )
    );

function sampled_path_polyline_length(path) =
    let(points = sampled_path_points(path))
    sb_list_sum([
        for (point_index = [0 : len(points) - 2])
            sb_point_distance(
                points[point_index],
                points[point_index + 1]
            )
    ]);

function sampled_path_bounds(path) =
    sb_bounds_from_points(sampled_path_points(path));
