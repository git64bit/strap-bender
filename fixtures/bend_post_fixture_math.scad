//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_fixture_math.scad
// Project: Strap Bender
// FileGroup: Fixture Planning
// FileSummary: Plans nominal full-form bend posts and optional arc followers.
//////////////////////////////////////////////////////////////////////

function sb_bend_post_tool_radius_mm(target_inside_radius_mm, fixture) =
    bend_post_fixture_radius_mode(fixture) == "nominal_target"
        ? target_inside_radius_mm
        : undef;

function sb_bend_post_station_from_primitive(primitive, fixture) =
    bend_post_station_spec(
        source_index = primitive_source_index(primitive),
        label = primitive_label(primitive),
        station_start = primitive_station_start(primitive),
        station_end = primitive_station_end(primitive),
        target_center = primitive_center(primitive),
        tool_center = primitive_center(primitive),
        angle_degrees = primitive_angle_degrees(primitive),
        target_inside_radius_mm = primitive_inside_radius(primitive),
        tool_inside_radius_mm = sb_bend_post_tool_radius_mm(
            primitive_inside_radius(primitive),
            fixture
        ),
        target_entry_point = sb_pose_point(primitive_start_pose(primitive)),
        target_exit_point = sb_pose_point(primitive_end_pose(primitive)),
        tool_entry_point = sb_pose_point(primitive_start_pose(primitive)),
        tool_exit_point = sb_pose_point(primitive_end_pose(primitive))
    );

function sb_bend_post_stations(path, fixture) = [
    for (primitive = analytical_path_primitives(path))
        if (primitive_kind(primitive) == "arc")
            sb_bend_post_station_from_primitive(primitive, fixture)
];

function sb_bend_post_station_circle_bounds(station) =
    let(
        center = bend_post_station_tool_center(station),
        radius = bend_post_station_tool_inside_radius_mm(station)
    )
    [
        sb_point_x(center) - radius,
        sb_point_y(center) - radius,
        sb_point_x(center) + radius,
        sb_point_y(center) + radius
    ];

function sb_bend_post_contact_bounds(
    path,
    stations,
    fixture,
    strap_thickness_mm
) =
    let(
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
        [analytical_path_bounds(path)],
        post_bounds,
        follower_bounds
    ));

function sb_bounds_expand_by_margin(bounds, margin_mm) = [
    sb_bounds_min_x(bounds) - margin_mm,
    sb_bounds_min_y(bounds) - margin_mm,
    sb_bounds_max_x(bounds) + margin_mm,
    sb_bounds_max_y(bounds) + margin_mm
];

function plan_bend_post_fixture(path, fixture, material_registry) =
    let(
        material = named_record(
            material_registry,
            bend_post_fixture_strap_material_name(fixture),
            "strap material"
        ),
        strap_thickness_mm = strap_material_nominal_thickness_mm(material),
        stations = sb_bend_post_stations(path, fixture),
        base_bounds = sb_bounds_expand_by_margin(
            sb_bend_post_contact_bounds(
                path,
                stations,
                fixture,
                strap_thickness_mm
            ),
            bend_post_fixture_base_margin_mm(fixture)
        )
    )
    bend_post_fixture_plan_spec(
        fixture_name = bend_post_fixture_name(fixture),
        source_path_name = analytical_path_name(path),
        reference_axis = analytical_path_reference_axis(path),
        status = bend_post_fixture_radius_mode(fixture) == "nominal_target"
            ? "experimental_uncompensated"
            : "unknown",
        stations = stations,
        base_bounds = base_bounds,
        nominal_strap_thickness_mm = strap_thickness_mm,
        notes = str(
            "Full-form open-top bend-post plan. In nominal_target mode each ",
            "tool center and tangent datum equals its analytical target ",
            "counterpart, and the printed post radius equals the desired ",
            "finished inside radius. arc_follower retention creates an ",
            "open-top annular wall only across each bend sweep, with nominal ",
            "slot width equal to strap thickness plus configured clearance."
        )
    );

function bend_post_station_surface_segment_count(station, fixture) =
    let(
        radius = bend_post_station_tool_inside_radius_mm(station),
        chord_error =
            bend_post_fixture_tool_surface_chord_error_mm(fixture),
        sagitta_angle_step = 2 * acos(1 - chord_error / radius),
        requested_angle_step =
            bend_post_fixture_tool_surface_max_angle_step_degrees(fixture),
        resolved_angle_step = min(
            requested_angle_step,
            sagitta_angle_step
        )
    )
    max(3, ceil(360 / resolved_angle_step));

function bend_post_station_actual_surface_sagitta_mm(station, fixture) =
    let(
        radius = bend_post_station_tool_inside_radius_mm(station),
        segment_count = bend_post_station_surface_segment_count(
            station,
            fixture
        )
    )
    radius * (1 - cos(180 / segment_count));
