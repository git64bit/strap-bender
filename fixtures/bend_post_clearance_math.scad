//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_clearance_math.scad
// Project: Strap Bender
// FileGroup: Fixture Planning
// FileSummary: Exact post/post and post/nonlocal-path clearance diagnostics.
//////////////////////////////////////////////////////////////////////

function sb_fixture_clamp(value, lower, upper) =
    max(lower, min(upper, value));
function sb_fixture_point_to_segment_distance(point, start_point, end_point) =
    let(
        dx = sb_point_x(end_point) - sb_point_x(start_point),
        dy = sb_point_y(end_point) - sb_point_y(start_point),
        denominator = dx * dx + dy * dy,
        t = denominator <= pow(SB_NUMERIC_POSITION_TOLERANCE_MM, 2)
            ? 0
            : sb_fixture_clamp(
                ((sb_point_x(point) - sb_point_x(start_point)) * dx +
                    (sb_point_y(point) - sb_point_y(start_point)) * dy) /
                    denominator,
                0,
                1
            ),
        nearest = [
            sb_point_x(start_point) + t * dx,
            sb_point_y(start_point) + t * dy
        ]
    )
    sb_point_distance(point, nearest);
function sb_fixture_point_angle_degrees(center, point) =
    atan2(
        sb_point_y(point) - sb_point_y(center),
        sb_point_x(point) - sb_point_x(center)
    );
function sb_fixture_angle_on_signed_arc(candidate, start_angle, sweep) =
    sweep > 0
        ? sb_positive_mod(candidate - start_angle, 360) <=
            sweep + SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
        : sb_positive_mod(start_angle - candidate, 360) <=
            abs(sweep) + SB_NUMERIC_ANGLE_TOLERANCE_DEGREES;
function sb_fixture_point_to_arc_distance(point, primitive) =
    let(
        center = primitive_center(primitive),
        radius = primitive_inside_radius(primitive),
        radial_distance = sb_point_distance(point, center),
        start_point = sb_pose_point(primitive_start_pose(primitive)),
        end_point = sb_pose_point(primitive_end_pose(primitive)),
        start_angle = sb_fixture_point_angle_degrees(center, start_point),
        candidate_angle = radial_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
            ? start_angle
            : sb_fixture_point_angle_degrees(center, point),
        projects_to_arc = radial_distance <= SB_NUMERIC_POSITION_TOLERANCE_MM
            ? true
            : sb_fixture_angle_on_signed_arc(
                candidate_angle,
                start_angle,
                primitive_angle_degrees(primitive)
            )
    )
    projects_to_arc
        ? abs(radial_distance - radius)
        : min(
            sb_point_distance(point, start_point),
            sb_point_distance(point, end_point)
        );
function sb_fixture_point_to_primitive_distance(point, primitive) =
    primitive_kind(primitive) == "line"
        ? sb_fixture_point_to_segment_distance(
            point,
            sb_pose_point(primitive_start_pose(primitive)),
            sb_pose_point(primitive_end_pose(primitive))
        )
        : sb_fixture_point_to_arc_distance(point, primitive);
function sb_fixture_primitive_local_to_station(primitive, station, path) =
    let(
        path_length = analytical_path_length(path),
        station_start = bend_post_station_station_start(station),
        station_end = bend_post_station_station_end(station),
        primitive_start = primitive_station_start(primitive),
        primitive_end = primitive_station_end(primitive),
        direct_neighbor =
            abs(primitive_end - station_start) <=
                SB_NUMERIC_STATION_TOLERANCE_MM ||
            abs(primitive_start - station_end) <=
                SB_NUMERIC_STATION_TOLERANCE_MM,
        closed_wrap_neighbor = analytical_path_closure(path) == "closed" && (
            (station_start <= SB_NUMERIC_STATION_TOLERANCE_MM &&
                abs(primitive_end - path_length) <=
                    SB_NUMERIC_STATION_TOLERANCE_MM) ||
            (abs(station_end - path_length) <=
                    SB_NUMERIC_STATION_TOLERANCE_MM &&
                primitive_start <= SB_NUMERIC_STATION_TOLERANCE_MM)
        )
    )
    primitive_source_index(primitive) == bend_post_station_source_index(station) ||
    direct_neighbor || closed_wrap_neighbor;
function sb_bend_post_pair_gap_mm(first, second) =
    sb_point_distance(
        bend_post_station_tool_center(first),
        bend_post_station_tool_center(second)
    ) - bend_post_station_tool_inside_radius_mm(first) -
        bend_post_station_tool_inside_radius_mm(second);
function sb_bend_post_to_primitive_gap_mm(station, primitive) =
    sb_fixture_point_to_primitive_distance(
        bend_post_station_tool_center(station),
        primitive
    ) - bend_post_station_tool_inside_radius_mm(station);
function sb_fixture_post_pair_gaps(stations) =
    len(stations) < 2
        ? []
        : [
            for (first_index = [0 : len(stations) - 2])
                for (second_index = [first_index + 1 : len(stations) - 1])
                    sb_bend_post_pair_gap_mm(
                        stations[first_index],
                        stations[second_index]
                    )
        ];
function sb_fixture_post_pair_issues(stations, required_gap_mm) =
    len(stations) < 2
        ? []
        : [
            for (first_index = [0 : len(stations) - 2])
                for (second_index = [first_index + 1 : len(stations) - 1])
                    let(
                        first = stations[first_index],
                        second = stations[second_index],
                        gap = sb_bend_post_pair_gap_mm(first, second)
                    )
                    if (gap + SB_NUMERIC_POSITION_TOLERANCE_MM < required_gap_mm)
                        fixture_clearance_issue_spec(
                            kind = "post_post",
                            primary_source_index =
                                bend_post_station_source_index(first),
                            secondary_source_index =
                                bend_post_station_source_index(second),
                            measured_gap_mm = gap,
                            required_gap_mm = required_gap_mm,
                            label = str(
                                bend_post_station_label(first),
                                " / ",
                                bend_post_station_label(second)
                            )
                        )
        ];
function sb_fixture_post_path_gaps(stations, path) = [
    for (station = stations)
        for (primitive = analytical_path_primitives(path))
            if (!sb_fixture_primitive_local_to_station(primitive, station, path))
                sb_bend_post_to_primitive_gap_mm(station, primitive)
];
function sb_fixture_post_path_issues(stations, path, required_gap_mm) = [
    for (station = stations)
        for (primitive = analytical_path_primitives(path))
            if (!sb_fixture_primitive_local_to_station(primitive, station, path))
                let(gap = sb_bend_post_to_primitive_gap_mm(station, primitive))
                if (gap + SB_NUMERIC_POSITION_TOLERANCE_MM < required_gap_mm)
                    fixture_clearance_issue_spec(
                        kind = "post_path",
                        primary_source_index =
                            bend_post_station_source_index(station),
                        secondary_source_index = primitive_source_index(primitive),
                        measured_gap_mm = gap,
                        required_gap_mm = required_gap_mm,
                        label = str(
                            "post ", bend_post_station_label(station),
                            " vs path ", primitive_label(primitive)
                        )
                    )
];
function analyze_bend_post_fixture_clearance(
    plan,
    fixture,
    path,
    material_registry
) =
    let(
        material = named_record(
            material_registry,
            bend_post_fixture_strap_material_name(fixture),
            "strap material"
        ),
        strap_thickness = strap_material_nominal_thickness_mm(material),
        required_path_gap = strap_thickness +
            bend_post_fixture_strap_clearance_mm(fixture),
        required_post_gap = bend_post_fixture_minimum_post_gap_mm(fixture),
        stations = bend_post_fixture_plan_stations(plan),
        post_pair_gaps = sb_fixture_post_pair_gaps(stations),
        post_path_gaps = sb_fixture_post_path_gaps(stations, path),
        pair_issues = sb_fixture_post_pair_issues(stations, required_post_gap),
        path_issues = sb_fixture_post_path_issues(
            stations,
            path,
            required_path_gap
        )
    )
    fixture_clearance_report_spec(
        fixture_name = bend_post_fixture_name(fixture),
        source_path_name = analytical_path_name(path),
        nominal_strap_thickness_mm = strap_thickness,
        required_nonlocal_path_gap_mm = required_path_gap,
        required_post_gap_mm = required_post_gap,
        post_pair_issues = pair_issues,
        post_path_issues = path_issues,
        minimum_post_pair_gap_mm = len(post_pair_gaps) == 0
            ? undef : min(post_pair_gaps),
        minimum_post_path_gap_mm = len(post_path_gaps) == 0
            ? undef : min(post_path_gaps),
        notes = str(
            "Exact XY clearance diagnostic. Local source arc and its tangent ",
            "neighbors are excluded from post/path checks. Nonlocal required ",
            "gap equals nominal strap thickness plus configured clearance."
        )
    );
