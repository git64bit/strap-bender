//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_fixture.scad
// Project: Strap Bender
// FileGroup: Production Fixture Geometry
// FileSummary: Renders the full-form base, bend posts, and arc followers.
//////////////////////////////////////////////////////////////////////

module render_bend_post_station(station, fixture) {
    center = bend_post_station_tool_center(station);
    radius = bend_post_station_tool_inside_radius_mm(station);
    segments = bend_post_station_surface_segment_count(station, fixture);
    translate([
        sb_point_x(center),
        sb_point_y(center),
        bend_post_fixture_base_thickness_mm(fixture)
    ])
        cylinder(
            h = bend_post_fixture_post_height_mm(fixture),
            r = radius,
            $fn = segments
        );
}

module render_bend_post_arc_follower(station, plan, fixture) {
    strap_thickness_mm =
        bend_post_fixture_plan_nominal_strap_thickness_mm(plan);
    points = sb_bend_post_follower_polygon_points(
        station,
        fixture,
        strap_thickness_mm
    );
    translate([0, 0, bend_post_fixture_base_thickness_mm(fixture)])
        linear_extrude(height = bend_post_fixture_post_height_mm(fixture))
            polygon(points = points);
}

module render_bend_post_fixture(plan, fixture) {
    bounds = bend_post_fixture_plan_base_bounds(plan);
    base_width = bend_post_fixture_plan_base_width_mm(plan);
    base_depth = bend_post_fixture_plan_base_depth_mm(plan);

    union() {
        translate([
            sb_bounds_min_x(bounds),
            sb_bounds_min_y(bounds),
            0
        ])
            cube([
                base_width,
                base_depth,
                bend_post_fixture_base_thickness_mm(fixture)
            ]);
        for (station = bend_post_fixture_plan_stations(plan)) {
            render_bend_post_station(station, fixture);
            if (sb_bend_post_retention_enabled(fixture))
                render_bend_post_arc_follower(station, plan, fixture);
        }
    }
}
