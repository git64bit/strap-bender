//////////////////////////////////////////////////////////////////////
// LibFile: fixture_reporting.scad
// Project: Strap Bender
// FileGroup: Fixture Reporting
// FileSummary: Reports bend-post fixture planning, datums, and limitations.
//////////////////////////////////////////////////////////////////////

module report_bend_post_fixture(fixture, level = "summary") {
    echo(str("BEND-POST FIXTURE: ", bend_post_fixture_name(fixture)));
    echo(str("Strap material: ",
        bend_post_fixture_strap_material_name(fixture)));
    echo(str("Radius mode: ", bend_post_fixture_radius_mode(fixture)));
    echo(str("Base thickness / margin: ",
        bend_post_fixture_base_thickness_mm(fixture), " / ",
        bend_post_fixture_base_margin_mm(fixture), " mm"));
    echo(str("Post height: ",
        bend_post_fixture_post_height_mm(fixture), " mm"));
    echo(str("Print envelope: ",
        bend_post_fixture_max_base_width_mm(fixture), " x ",
        bend_post_fixture_max_base_depth_mm(fixture), " mm"));
    echo(str("Retention: ", bend_post_fixture_retention_mode(fixture)));
    if (level == "full") {
        echo(str("Tool-surface chord error: ",
            bend_post_fixture_tool_surface_chord_error_mm(fixture), " mm"));
        echo(str("Tool-surface maximum angle step: ",
            bend_post_fixture_tool_surface_max_angle_step_degrees(fixture),
            " deg"));
        echo(str("Notes: ", bend_post_fixture_notes(fixture)));
    }
}

module report_bend_post_fixture_plan(plan, fixture, level = "summary") {
    stations = bend_post_fixture_plan_stations(plan);
    bounds = bend_post_fixture_plan_base_bounds(plan);
    echo("--- Strap Bender bend-post fixture plan ---");
    echo(str("Source path: ",
        bend_post_fixture_plan_source_path_name(plan)));
    echo(str("Reference axis: ",
        bend_post_fixture_plan_reference_axis(plan)));
    echo(str("Status: ", bend_post_fixture_plan_status(plan)));
    echo(str("Bend stations: ", len(stations)));
    echo(str("Base bounds: [", sb_bounds_min_x(bounds), ", ",
        sb_bounds_min_y(bounds), "] to [", sb_bounds_max_x(bounds), ", ",
        sb_bounds_max_y(bounds), "] mm"));
    echo(str("Base size: ",
        bend_post_fixture_plan_base_width_mm(plan), " x ",
        bend_post_fixture_plan_base_depth_mm(plan), " mm"));

    if (level == "full")
        for (station = stations)
            echo(str(
                "Post from command ",
                bend_post_station_source_index(station),
                ": target/tool center ",
                bend_post_station_target_center(station), " / ",
                bend_post_station_tool_center(station),
                ", turn ", bend_post_station_angle_degrees(station),
                " deg, target R",
                bend_post_station_target_inside_radius_mm(station),
                ", tool R",
                bend_post_station_tool_inside_radius_mm(station),
                " mm, stations ",
                bend_post_station_station_start(station),
                " to ",
                bend_post_station_station_end(station),
                len(bend_post_station_label(station)) > 0
                    ? str(" [", bend_post_station_label(station), "]")
                    : ""
            ));

    echo(str(
        "UNCOMPENSATED FIXTURE: nominal_target mode intentionally sets each ",
        "tool radius equal to the requested finished inside radius. This ",
        "allows complete fixture software development without claiming a ",
        "measured relaxed PET result. Empirical compensation can replace ",
        "this mapping in a later revision."
    ));
    echo(str(
        "RETENTION LIMIT: this first family is open-top and has no integral ",
        "strap clamp or retainer. Closed or concave shapes are removed ",
        "vertically from the posts."
    ));
}
