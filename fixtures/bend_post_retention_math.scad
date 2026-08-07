//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_retention_math.scad
// Project: Strap Bender
// FileGroup: Fixture Planning
// FileSummary: Derives open-top arc-follower retention geometry at each bend.
//////////////////////////////////////////////////////////////////////
function sb_bend_post_retention_enabled(fixture) =
    bend_post_fixture_retention_mode(fixture) == "arc_follower";
function sb_bend_post_follower_slot_width_mm(fixture, strap_thickness_mm) =
    strap_thickness_mm + bend_post_fixture_strap_clearance_mm(fixture);
function sb_bend_post_follower_inner_radius_mm(
    station,
    fixture,
    strap_thickness_mm
) =
    bend_post_station_tool_inside_radius_mm(station) +
    sb_bend_post_follower_slot_width_mm(fixture, strap_thickness_mm);
function sb_bend_post_follower_outer_radius_mm(
    station,
    fixture,
    strap_thickness_mm
) =
    sb_bend_post_follower_inner_radius_mm(
        station, fixture, strap_thickness_mm
    ) + bend_post_fixture_follower_wall_thickness_mm(fixture);
function sb_bend_post_follower_outer_extension_mm(fixture, strap_thickness_mm) =
    sb_bend_post_follower_slot_width_mm(fixture, strap_thickness_mm) +
    bend_post_fixture_follower_wall_thickness_mm(fixture);
function sb_fixture_radial_point_at_radius(center, reference_point, radius) =
    let(
        source_radius = sb_point_distance(center, reference_point),
        scale = radius / source_radius
    )
    [
        sb_point_x(center) +
            (sb_point_x(reference_point) - sb_point_x(center)) * scale,
        sb_point_y(center) +
            (sb_point_y(reference_point) - sb_point_y(center)) * scale
    ];
function sb_retention_point_angle_degrees(center, point) =
    atan2(
        sb_point_y(point) - sb_point_y(center),
        sb_point_x(point) - sb_point_x(center)
    );
function sb_fixture_arc_cardinal_points(
    center,
    start_point,
    sweep_degrees,
    radius
) =
    let(start_angle = sb_retention_point_angle_degrees(center, start_point))
    [
        for (candidate = [0, 90, 180, 270])
            if (sb_angle_is_on_sweep(
                    candidate, start_angle, sweep_degrees
                ))
                [
                    sb_point_x(center) + radius * cos(candidate),
                    sb_point_y(center) + radius * sin(candidate)
                ]
    ];
function sb_fixture_arc_bounds(center, start_point, sweep_degrees, radius) =
    let(
        radial_start = sb_fixture_radial_point_at_radius(
            center, start_point, radius
        ),
        radial_end = sb_rotate_point_about(
            radial_start, center, sweep_degrees
        )
    )
    sb_bounds_from_points(concat(
        [radial_start, radial_end],
        sb_fixture_arc_cardinal_points(
            center, radial_start, sweep_degrees, radius
        )
    ));
function sb_bend_post_follower_bounds(station, fixture, strap_thickness_mm) =
    let(
        center = bend_post_station_tool_center(station),
        start_point = bend_post_station_tool_entry_point(station),
        sweep = bend_post_station_angle_degrees(station),
        inner_radius = sb_bend_post_follower_inner_radius_mm(
            station, fixture, strap_thickness_mm
        ),
        outer_radius = sb_bend_post_follower_outer_radius_mm(
            station, fixture, strap_thickness_mm
        )
    )
    sb_bounds_union([
        sb_fixture_arc_bounds(center, start_point, sweep, inner_radius),
        sb_fixture_arc_bounds(center, start_point, sweep, outer_radius)
    ]);
function sb_bend_post_follower_segment_count(
    station,
    fixture,
    strap_thickness_mm
) =
    let(
        radius = sb_bend_post_follower_outer_radius_mm(
            station, fixture, strap_thickness_mm
        ),
        chord_error = bend_post_fixture_tool_surface_chord_error_mm(fixture),
        sagitta_angle_step = chord_error >= radius
            ? 180
            : 2 * acos(1 - chord_error / radius),
        requested_angle_step =
            bend_post_fixture_tool_surface_max_angle_step_degrees(fixture),
        resolved_angle_step = min(requested_angle_step, sagitta_angle_step)
    )
    max(1, ceil(abs(bend_post_station_angle_degrees(station)) /
        resolved_angle_step));
function sb_bend_post_follower_actual_surface_sagitta_mm(
    station,
    fixture,
    strap_thickness_mm
) =
    let(
        radius = sb_bend_post_follower_outer_radius_mm(
            station, fixture, strap_thickness_mm
        ),
        segment_count = sb_bend_post_follower_segment_count(
            station, fixture, strap_thickness_mm
        )
    )
    radius * (1 - cos(
        abs(bend_post_station_angle_degrees(station)) /
        (2 * segment_count)
    ));
function sb_bend_post_follower_arc_points(
    station,
    fixture,
    strap_thickness_mm,
    radius
) =
    let(
        center = bend_post_station_tool_center(station),
        start_point = sb_fixture_radial_point_at_radius(
            center,
            bend_post_station_tool_entry_point(station),
            radius
        ),
        sweep = bend_post_station_angle_degrees(station),
        segment_count = sb_bend_post_follower_segment_count(
            station, fixture, strap_thickness_mm
        )
    )
    [
        for (sample_index = [0 : segment_count])
            sample_index == 0
                ? start_point
                : sb_rotate_point_about(
                    start_point,
                    center,
                    sweep * sample_index / segment_count
                )
    ];
function sb_bend_post_follower_polygon_points(
    station,
    fixture,
    strap_thickness_mm
) =
    let(
        outer = sb_bend_post_follower_arc_points(
            station,
            fixture,
            strap_thickness_mm,
            sb_bend_post_follower_outer_radius_mm(
                station, fixture, strap_thickness_mm
            )
        ),
        inner = sb_bend_post_follower_arc_points(
            station,
            fixture,
            strap_thickness_mm,
            sb_bend_post_follower_inner_radius_mm(
                station, fixture, strap_thickness_mm
            )
        )
    )
    concat(
        outer,
        [for (index = [len(inner) - 1 : -1 : 0]) inner[index]]
    );
