//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_segmentation_math.scad
// Project: Strap Bender
// FileGroup: Fixture Planning
// FileSummary: Partitions long fixtures at straight-region stations.
//////////////////////////////////////////////////////////////////////

function sb_fixture_plan_fits_print_envelope(plan, fixture) =
    bend_post_fixture_plan_base_width_mm(plan) <=
        bend_post_fixture_max_base_width_mm(fixture) +
            SB_NUMERIC_POSITION_TOLERANCE_MM &&
    bend_post_fixture_plan_base_depth_mm(plan) <=
        bend_post_fixture_max_base_depth_mm(fixture) +
            SB_NUMERIC_POSITION_TOLERANCE_MM;

function sb_fixture_segmentation_candidate_spacing_mm(fixture) =
    min(
        bend_post_fixture_max_base_width_mm(fixture),
        bend_post_fixture_max_base_depth_mm(fixture)
    ) / 3;

function sb_line_split_segment_count(primitive, fixture) =
    max(2, ceil(
        primitive_length(primitive) /
        sb_fixture_segmentation_candidate_spacing_mm(fixture)
    ));

function sb_fixture_straight_split_candidates(path, fixture) =
    let(primitives = analytical_path_primitives(path))
    concat(
        [0],
        [
            for (primitive = primitives)
                if (primitive_kind(primitive) == "line")
                    for (split_index = [1 :
                        sb_line_split_segment_count(primitive, fixture) - 1])
                        primitive_station_start(primitive) +
                        primitive_length(primitive) * split_index /
                        sb_line_split_segment_count(primitive, fixture)
        ],
        [analytical_path_length(path)]
    );

function sb_line_point_at_station(primitive, station_mm) =
    sb_pose_point(sb_advance_straight_pose(
        primitive_start_pose(primitive),
        station_mm - primitive_station_start(primitive)
    ));

function sb_path_primitive_at_split_station(path, station_mm) =
    station_mm <= SB_NUMERIC_STATION_TOLERANCE_MM
        ? analytical_path_primitives(path)[0]
        : station_mm >= analytical_path_length(path) -
                SB_NUMERIC_STATION_TOLERANCE_MM
            ? analytical_path_primitives(path)[
                len(analytical_path_primitives(path)) - 1
            ]
            : let(matches = [
                for (primitive = analytical_path_primitives(path))
                    if (primitive_kind(primitive) == "line" &&
                        station_mm > primitive_station_start(primitive) +
                            SB_NUMERIC_STATION_TOLERANCE_MM &&
                        station_mm < primitive_station_end(primitive) -
                            SB_NUMERIC_STATION_TOLERANCE_MM)
                        primitive
            ])
            assert(len(matches) == 1,
                str("Fixture split station ", station_mm,
                    " mm must lie inside exactly one straight primitive."))
            matches[0];

function sb_fixture_datum_at_station(path, station_mm, role) =
    station_mm <= SB_NUMERIC_STATION_TOLERANCE_MM
        ? fixture_assembly_datum_spec(
            station_mm = 0,
            point = sb_pose_point(analytical_path_start_pose(path)),
            heading_degrees =
                pose_heading_degrees(analytical_path_start_pose(path)),
            role = role,
            source_index = primitive_source_index(
                analytical_path_primitives(path)[0]
            ),
            label = "PATH_START"
        )
        : station_mm >= analytical_path_length(path) -
                SB_NUMERIC_STATION_TOLERANCE_MM
            ? fixture_assembly_datum_spec(
                station_mm = analytical_path_length(path),
                point = sb_pose_point(analytical_path_end_pose(path)),
                heading_degrees =
                    pose_heading_degrees(analytical_path_end_pose(path)),
                role = role,
                source_index = primitive_source_index(
                    analytical_path_primitives(path)[
                        len(analytical_path_primitives(path)) - 1
                    ]
                ),
                label = "PATH_END"
            )
            : let(
                primitive = sb_path_primitive_at_split_station(
                    path, station_mm
                ),
                point = sb_line_point_at_station(primitive, station_mm)
            )
            fixture_assembly_datum_spec(
                station_mm = station_mm,
                point = point,
                heading_degrees =
                    pose_heading_degrees(primitive_start_pose(primitive)),
                role = role,
                source_index = primitive_source_index(primitive),
                label = str("STRAIGHT_SPLIT_CMD_",
                    primitive_source_index(primitive))
            );

function sb_primitive_overlaps_station_window(
    primitive,
    station_start_mm,
    station_end_mm
) =
    min(primitive_station_end(primitive), station_end_mm) -
    max(primitive_station_start(primitive), station_start_mm) >
        SB_NUMERIC_STATION_TOLERANCE_MM;

function sb_line_window_bounds(primitive, station_start_mm, station_end_mm) =
    let(
        clipped_start = max(
            primitive_station_start(primitive), station_start_mm
        ),
        clipped_end = min(
            primitive_station_end(primitive), station_end_mm
        )
    )
    sb_bounds_from_points([
        sb_line_point_at_station(primitive, clipped_start),
        sb_line_point_at_station(primitive, clipped_end)
    ]);

function sb_fixture_component_path_bounds(
    path,
    station_start_mm,
    station_end_mm
) =
    sb_bounds_union([
        for (primitive = analytical_path_primitives(path))
            if (sb_primitive_overlaps_station_window(
                    primitive, station_start_mm, station_end_mm
                ))
                primitive_kind(primitive) == "line"
                    ? sb_line_window_bounds(
                        primitive, station_start_mm, station_end_mm
                    )
                    : analytical_primitive_bounds(primitive)
    ]);

function sb_fixture_component_bend_stations(
    full_plan,
    station_start_mm,
    station_end_mm
) = [
    for (station = bend_post_fixture_plan_stations(full_plan))
        if (bend_post_station_station_start(station) >=
                station_start_mm - SB_NUMERIC_STATION_TOLERANCE_MM &&
            bend_post_station_station_end(station) <=
                station_end_mm + SB_NUMERIC_STATION_TOLERANCE_MM)
            station
];

function sb_fixture_component_contact_bounds(
    path,
    full_plan,
    fixture,
    station_start_mm,
    station_end_mm
) =
    let(
        stations = sb_fixture_component_bend_stations(
            full_plan, station_start_mm, station_end_mm
        ),
        strap_thickness_mm =
            bend_post_fixture_plan_nominal_strap_thickness_mm(full_plan),
        post_bounds = [
            for (station = stations)
                sb_bend_post_station_circle_bounds(station)
        ],
        follower_bounds = sb_bend_post_retention_enabled(fixture)
            ? [
                for (station = stations)
                    sb_bend_post_follower_bounds(
                        station, fixture, strap_thickness_mm
                    )
            ]
            : []
    )
    sb_bounds_union(concat(
        [sb_fixture_component_path_bounds(
            path, station_start_mm, station_end_mm
        )],
        post_bounds,
        follower_bounds
    ));

function sb_fixture_component_base_bounds(
    path,
    full_plan,
    fixture,
    station_start_mm,
    station_end_mm
) =
    sb_bounds_expand_by_margin(
        sb_fixture_component_contact_bounds(
            path,
            full_plan,
            fixture,
            station_start_mm,
            station_end_mm
        ),
        bend_post_fixture_base_margin_mm(fixture)
    );

function sb_fixture_component_bounds_fit_envelope(bounds, fixture) =
    sb_bounds_width(bounds) <= bend_post_fixture_max_base_width_mm(fixture) +
        SB_NUMERIC_POSITION_TOLERANCE_MM &&
    sb_bounds_height(bounds) <= bend_post_fixture_max_base_depth_mm(fixture) +
        SB_NUMERIC_POSITION_TOLERANCE_MM;

function sb_farthest_fitting_split_index(
    path,
    full_plan,
    fixture,
    candidates,
    start_index,
    candidate_index,
    last_fit = undef
) =
    candidate_index >= len(candidates)
        ? assert(!is_undef(last_fit),
            str("No printable straight-split interval begins at station ",
                candidates[start_index], " mm."))
            last_fit
        : let(
            bounds = sb_fixture_component_base_bounds(
                path,
                full_plan,
                fixture,
                candidates[start_index],
                candidates[candidate_index]
            ),
            fits = sb_fixture_component_bounds_fit_envelope(bounds, fixture)
        )
        fits
            ? sb_farthest_fitting_split_index(
                path,
                full_plan,
                fixture,
                candidates,
                start_index,
                candidate_index + 1,
                candidate_index
            )
            : assert(!is_undef(last_fit),
                str("The fixture interval beginning at station ",
                    candidates[start_index],
                    " mm cannot reach the next straight-region split within ",
                    "the configured print envelope. Increase the envelope or ",
                    "provide a longer straight region."))
                last_fit;

function sb_fixture_component_id(fixture, component_index) =
    str(
        bend_post_fixture_name(fixture),
        "__C",
        component_index + 1 < 10 ? "00" :
            component_index + 1 < 100 ? "0" : "",
        component_index + 1
    );

function sb_fixture_component_from_interval(
    path,
    full_plan,
    fixture,
    component_index,
    station_start_mm,
    station_end_mm
) =
    fixture_component_spec(
        component_id = sb_fixture_component_id(fixture, component_index),
        component_index = component_index,
        station_start_mm = station_start_mm,
        station_end_mm = station_end_mm,
        start_datum = sb_fixture_datum_at_station(
            path,
            station_start_mm,
            station_start_mm <= SB_NUMERIC_STATION_TOLERANCE_MM
                ? "path_start" : "component_split"
        ),
        end_datum = sb_fixture_datum_at_station(
            path,
            station_end_mm,
            station_end_mm >= analytical_path_length(path) -
                    SB_NUMERIC_STATION_TOLERANCE_MM
                ? "path_end" : "component_split"
        ),
        bend_stations = sb_fixture_component_bend_stations(
            full_plan, station_start_mm, station_end_mm
        ),
        base_bounds = sb_fixture_component_base_bounds(
            path,
            full_plan,
            fixture,
            station_start_mm,
            station_end_mm
        ),
        notes = str(
            "Sequential long-form fixture component. Interior boundaries are ",
            "located only inside analytical straight primitives; no bend post ",
            "or arc follower is split. Global station and tangent-pose datums ",
            "are preserved for setup and verification."
        )
    );

function sb_partition_fixture_components(
    path,
    full_plan,
    fixture,
    candidates,
    start_index = 0,
    component_index = 0
) =
    start_index >= len(candidates) - 1
        ? []
        : let(
            end_index = sb_farthest_fitting_split_index(
                path,
                full_plan,
                fixture,
                candidates,
                start_index,
                start_index + 1
            ),
            component = sb_fixture_component_from_interval(
                path,
                full_plan,
                fixture,
                component_index,
                candidates[start_index],
                candidates[end_index]
            )
        )
        concat(
            [component],
            sb_partition_fixture_components(
                path,
                full_plan,
                fixture,
                candidates,
                end_index,
                component_index + 1
            )
        );

function plan_bend_post_fixture_segmentation(path, full_plan, fixture) =
    let(
        candidates = sb_fixture_straight_split_candidates(path, fixture),
        components = sb_partition_fixture_components(
            path, full_plan, fixture, candidates
        ),
        split_stations = [
            for (component_index = [0 : len(components)])
                component_index == 0
                    ? fixture_component_station_start_mm(components[0])
                    : fixture_component_station_end_mm(
                        components[component_index - 1]
                    )
        ]
    )
    fixture_segmentation_plan_spec(
        fixture_name = bend_post_fixture_name(fixture),
        source_path_name = analytical_path_name(path),
        strategy = "sequential_straight_split",
        components = components,
        split_stations_mm = split_stations,
        max_base_width_mm = bend_post_fixture_max_base_width_mm(fixture),
        max_base_depth_mm = bend_post_fixture_max_base_depth_mm(fixture),
        status = "experimental_uncompensated",
        notes = str(
            "Greedy deterministic station partitioning chooses the farthest ",
            "available straight-region split that keeps each component inside ",
            "the configured print envelope. Components are sequential setup ",
            "modules, not butt-jointed tiles; their global coverage may overlap ",
            "because each receives the configured base margin."
        )
    );
