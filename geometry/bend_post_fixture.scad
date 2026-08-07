//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_fixture.scad
// Project: Strap Bender
// FileGroup: Production Fixture Geometry
// FileSummary: Renders full-form and segmented bend-post fixture components.
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

module render_bend_post_fixture_component_positive(component, plan, fixture) {
    bounds = fixture_component_base_bounds(component);
    base_width = fixture_component_base_width_mm(component);
    base_depth = fixture_component_base_depth_mm(component);

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
        for (station = fixture_component_bend_stations(component)) {
            render_bend_post_station(station, fixture);
            if (sb_bend_post_retention_enabled(fixture))
                render_bend_post_arc_follower(station, plan, fixture);
        }
    }
}

module cut_fixture_component_registration_holes(component, fixture, setup) {
    if (sb_fixture_setup_registration_enabled(setup))
        for (point = sb_fixture_component_registration_points(component, setup))
            translate([
                sb_point_x(point),
                sb_point_y(point),
                -0.01
            ])
                cylinder(
                    h = bend_post_fixture_base_thickness_mm(fixture) + 0.02,
                    r = fixture_setup_aid_hole_radius_mm(setup),
                    $fn = 32
                );
}

module cut_fixture_component_index_mark(component, fixture, setup) {
    if (sb_fixture_setup_label_enabled(setup)) {
        bounds = fixture_component_base_bounds(component);
        margin = bend_post_fixture_base_margin_mm(fixture);
        translate([
            sb_bounds_min_x(bounds) + margin / 2,
            sb_bounds_min_y(bounds) + margin / 2,
            bend_post_fixture_base_thickness_mm(fixture) -
                fixture_setup_aid_label_depth_mm(setup)
        ])
            linear_extrude(
                height = fixture_setup_aid_label_depth_mm(setup) + 0.01
            )
                text(
                    sb_fixture_component_short_label(component),
                    size = fixture_setup_aid_label_size_mm(setup),
                    halign = "center",
                    valign = "center"
                );
    }
}

module render_bend_post_fixture_component(
    component,
    plan,
    fixture,
    setup = undef
) {
    bounds = fixture_component_base_bounds(component);
    translate([
        -sb_bounds_min_x(bounds),
        -sb_bounds_min_y(bounds),
        0
    ])
        if (is_undef(setup))
            render_bend_post_fixture_component_positive(
                component, plan, fixture
            );
        else
            difference() {
                render_bend_post_fixture_component_positive(
                    component, plan, fixture
                );
                cut_fixture_component_registration_holes(
                    component, fixture, setup
                );
                cut_fixture_component_index_mark(
                    component, fixture, setup
                );
            }
}
