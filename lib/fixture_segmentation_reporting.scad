//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_reporting.scad
// Project: Strap Bender
// FileGroup: Fixture Segmentation Reporting
// FileSummary: Reports printable long-form components and setup datums.
//////////////////////////////////////////////////////////////////////

module report_fixture_component(component, level = "summary") {
    start_datum = fixture_component_start_datum(component);
    end_datum = fixture_component_end_datum(component);
    echo(str(
        "COMPONENT ", fixture_component_index(component), " / ",
        fixture_component_id(component),
        ": stations ", fixture_component_station_start_mm(component),
        " to ", fixture_component_station_end_mm(component), " mm; base ",
        fixture_component_base_width_mm(component), " x ",
        fixture_component_base_depth_mm(component), " mm; bends ",
        len(fixture_component_bend_stations(component))
    ));
    echo(str(
        "  start datum global/local: ", fixture_datum_point(start_datum),
        " / ", fixture_component_local_start_point(component),
        "; heading ", fixture_datum_heading_degrees(start_datum), " deg"
    ));
    echo(str(
        "  end datum global/local: ", fixture_datum_point(end_datum),
        " / ", fixture_component_local_end_point(component),
        "; heading ", fixture_datum_heading_degrees(end_datum), " deg"
    ));
    if (level == "full") {
        echo(str("  start source: command ",
            fixture_datum_source_index(start_datum), " [",
            fixture_datum_label(start_datum), "]"));
        echo(str("  end source: command ",
            fixture_datum_source_index(end_datum), " [",
            fixture_datum_label(end_datum), "]"));
        echo(str("  global base bounds: ",
            fixture_component_base_bounds(component)));
        echo(str("  notes: ", fixture_component_notes(component)));
    }
}

module report_bend_post_fixture_segmentation(segmentation, level = "summary") {
    components = fixture_segmentation_plan_components(segmentation);
    echo("--- Strap Bender long-form fixture segmentation ---");
    echo(str("Source path: ",
        fixture_segmentation_plan_source_path_name(segmentation)));
    echo(str("Strategy: ", fixture_segmentation_plan_strategy(segmentation)));
    echo(str("Status: ", fixture_segmentation_plan_status(segmentation)));
    echo(str("Printable components: ", len(components)));
    echo(str("Print envelope: ",
        fixture_segmentation_plan_max_base_width_mm(segmentation), " x ",
        fixture_segmentation_plan_max_base_depth_mm(segmentation), " mm"));
    echo(str("Boundary stations: ",
        fixture_segmentation_plan_split_stations_mm(segmentation)));
    for (component = components)
        report_fixture_component(component, level);
    echo(str(
        "SETUP POLICY: components are sequential station modules. Export one ",
        "component at a time. Each STL is translated to a local XY origin, ",
        "while the manifest preserves the exact global station, XY point, ",
        "heading, and source-command identity at both boundaries. Components ",
        "are not butt-jointed tiles in this revision."
    ));
    if (level == "full")
        echo(str("Notes: ", fixture_segmentation_plan_notes(segmentation)));
}
