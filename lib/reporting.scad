//////////////////////////////////////////////////////////////////////
// LibFile: reporting.scad
// Project: Strap Bender
// FileGroup: Reporting
// FileSummary: Reports source records and derived analytical paths.
//////////////////////////////////////////////////////////////////////

module report_project(project, report_level = "full") {
    echo("--- Strap Bender project ---");
    echo(str("Name: ", project_name(project)));
    echo(str("Kind: ", project_kind(project)));
    echo(str("Status: ", project_status(project)));

    if (report_level == "full")
        echo(str("Notes: ", project_notes(project)));
}

module report_start_pose(pose, prefix = "Start pose") {
    echo(str(
        prefix, ": [",
        pose_x(pose), ", ", pose_y(pose),
        "] heading ", pose_heading_degrees(pose), " degrees"
    ));
}

module report_bend_program_command(command) {
    if (command_kind(command) == "straight")
        echo(str(
            "Command ", command_source_index(command),
            ": straight ", command_distance(command), " mm",
            len(command_label(command)) > 0
                ? str(" [", command_label(command), "]") : ""
        ));
    else
        echo(str(
            "Command ", command_source_index(command),
            ": bend ", command_angle_degrees(command),
            " degrees at finished inside radius ",
            command_inside_radius(command), " mm",
            len(command_label(command)) > 0
                ? str(" [", command_label(command), "]") : ""
        ));
}

module report_bend_program_shape(shape, report_level = "full") {
    commands = shape_commands(shape);
    straight_count = len([
        for (command = commands)
            if (command_kind(command) == "straight") command
    ]);
    bend_count = len(commands) - straight_count;

    echo("--- Strap Bender bend program ---");
    echo(str("Shape: ", shape_name(shape)));
    echo(str("Closure: ", shape_closure(shape)));
    echo(str("Commands: ", len(commands),
        " (", straight_count, " straight, ", bend_count, " bend)"));
    report_start_pose(shape_start_pose(shape));

    if (report_level == "full") {
        for (command = commands)
            report_bend_program_command(command);
        echo(str("Notes: ", shape_notes(shape)));
    }
}

module report_analytical_primitive(primitive) {
    start_pose = primitive_start_pose(primitive);
    end_pose = primitive_end_pose(primitive);

    if (primitive_kind(primitive) == "line")
        echo(str(
            "Primitive from command ", primitive_source_index(primitive),
            ": line, station ", primitive_station_start(primitive),
            " to ", primitive_station_end(primitive),
            " mm, [", pose_x(start_pose), ", ", pose_y(start_pose),
            "] to [", pose_x(end_pose), ", ", pose_y(end_pose), "]",
            len(primitive_label(primitive)) > 0
                ? str(" [", primitive_label(primitive), "]") : ""
        ));
    else
        echo(str(
            "Primitive from command ", primitive_source_index(primitive),
            ": arc ", primitive_angle_degrees(primitive),
            " degrees at inside radius ",
            primitive_inside_radius(primitive),
            " mm, center [", sb_point_x(primitive_center(primitive)),
            ", ", sb_point_y(primitive_center(primitive)),
            "], station ", primitive_station_start(primitive),
            " to ", primitive_station_end(primitive), " mm",
            len(primitive_label(primitive)) > 0
                ? str(" [", primitive_label(primitive), "]") : ""
        ));
}

module report_analytical_path(path, report_level = "full") {
    primitives = analytical_path_primitives(path);
    line_count = len([
        for (primitive = primitives)
            if (primitive_kind(primitive) == "line") primitive
    ]);
    arc_count = len(primitives) - line_count;
    bounds = analytical_path_bounds(path);

    echo("--- Strap Bender analytical path ---");
    echo(str("Path: ", analytical_path_name(path)));
    echo(str("Reference axis: ", analytical_path_reference_axis(path)));
    echo(str("Primitives: ", len(primitives),
        " (", line_count, " line, ", arc_count, " arc)"));
    echo(str("Total straight length: ",
        analytical_path_straight_length(path), " mm"));
    echo(str("Total inside-edge arc length: ",
        analytical_path_arc_length(path), " mm"));
    echo(str("Total inside-reference path length: ",
        analytical_path_length(path), " mm"));
    report_start_pose(analytical_path_end_pose(path), "End pose");
    echo(str(
        "Bounds: [", sb_bounds_min_x(bounds), ", ",
        sb_bounds_min_y(bounds), "] to [",
        sb_bounds_max_x(bounds), ", ",
        sb_bounds_max_y(bounds), "] mm"
    ));

    if (analytical_path_closure(path) == "closed") {
        echo(str("Closure position error: ",
            analytical_path_closure_position_error(path), " mm"));
        echo(str("Closure heading error: ",
            analytical_path_closure_angle_error(path), " degrees"));
    }

    echo(str(
        "Length warning: the inside-reference path length is not a ",
        "neutral-axis developed length or a cut length."
    ));

    if (report_level == "full") {
        for (primitive = primitives)
            report_analytical_primitive(primitive);
        echo(str("Notes: ", analytical_path_notes(path)));
    }
}

module report_sampled_path(
    sampled_path,
    analytical_path,
    report_level = "summary"
) {
    points = sampled_path_points(sampled_path);
    polyline_length = sampled_path_polyline_length(sampled_path);
    analytical_length = analytical_path_length(analytical_path);

    echo("--- Strap Bender sampled display path ---");
    echo(str("Path: ", sampled_path_name(sampled_path)));
    echo(str("Reference axis: ",
        sampled_path_reference_axis(sampled_path)));
    echo(str("Sample points: ", len(points)));
    echo(str("Requested maximum chord error: ",
        sampled_path_chord_error_mm(sampled_path), " mm"));
    echo(str("Maximum angular step: ",
        sampled_path_max_angle_step_degrees(sampled_path), " degrees"));
    echo(str("Display polyline length: ", polyline_length, " mm"));
    echo(str("Exact analytical reference length: ",
        analytical_length, " mm"));
    echo(str("Chordal length shortfall: ",
        analytical_length - polyline_length, " mm"));
    echo(str(
        "Sampling warning: sampled points are display data only and may not ",
        "replace exact analytical measurements, bounds, stations, or datums."
    ));

    if (report_level == "full")
        echo(str("Notes: ", sampled_path_notes(sampled_path)));
}

module report_vertex_polygon(polygon, report_level = "full") {
    vertices = vertex_polygon_vertices(polygon);
    compilation = compile_vertex_polygon(polygon);
    corners = polygon_compilation_corners(compilation);
    edges = polygon_compilation_edges(compilation);
    convex_count = len([
        for (corner = corners)
            if (polygon_corner_classification(corner) == "convex") corner
    ]);
    concave_count = len(corners) - convex_count;
    radii = vertex_polygon_corner_radii(polygon);

    echo("--- Strap Bender vertex polygon ---");
    echo(str("Polygon: ", vertex_polygon_name(polygon)));
    echo(str("Vertices: ", len(vertices)));
    echo(str("Orientation: ", sb_polygon_orientation_name(vertices)));
    echo(str("Corners: ", convex_count, " convex, ",
        concave_count, " concave"));
    echo(str("Corner-radius range: ", min(radii), " to ",
        max(radii), " mm"));
    echo(str("Start vertex: ",
        vertex_polygon_start_vertex_index(polygon)));
    echo(str("Shortest retained straight: ", min([
        for (edge = edges) polygon_edge_retained_length(edge)
    ]), " mm"));

    if (report_level == "full") {
        for (corner = corners)
            echo(str(
                "Vertex ", polygon_corner_source_vertex_index(corner),
                ": ", polygon_corner_classification(corner),
                " turn ", polygon_corner_turn_angle_degrees(corner),
                " degrees, radius ",
                polygon_corner_inside_radius(corner),
                " mm, setback ",
                polygon_corner_tangent_setback(corner),
                " mm, bend command ",
                polygon_corner_bend_command_index(corner)
            ));
        echo(str("Notes: ", vertex_polygon_notes(polygon)));
    }
}

module report_polygon_compilation(
    compilation,
    report_level = "full"
) {
    corners = polygon_compilation_corners(compilation);
    edges = polygon_compilation_edges(compilation);

    echo("--- Strap Bender polygon compilation ---");
    echo(str("Source polygon: ",
        polygon_compilation_source_name(compilation)));
    echo(str("Derived corners: ", len(corners)));
    echo(str("Derived retained straights: ", len(edges)));
    echo(str("Normalized commands: ", len(shape_commands(
        polygon_compilation_normalized_shape(compilation)
    ))));

    if (report_level == "full") {
        for (edge = edges)
            echo(str(
                "Edge ", polygon_edge_source_index(edge),
                ": retained ", polygon_edge_retained_length(edge),
                " mm, straight command ",
                polygon_edge_straight_command_index(edge)
            ));
        echo(str("Notes: ", polygon_compilation_notes(compilation)));
    }
}


module report_regular_polygon(polygon, report_level = "full") {
    radii = regular_polygon_corner_radii(polygon);

    echo("--- Strap Bender regular polygon ---");
    echo(str("Source: ", regular_polygon_name(polygon)));
    echo(str("Sides: ", regular_polygon_side_count(polygon)));
    echo(str(
        "Governing dimension: ",
        regular_polygon_dimension_kind(polygon),
        " = ", regular_polygon_dimension_value(polygon), " mm"
    ));
    echo(str(
        "Corner radii: ",
        is_num(radii)
            ? str("common ", radii, " mm")
            : str(len(radii), " explicit values")
    ));
    echo(str(
        "Center: [", sb_point_x(regular_polygon_center(polygon)),
        ", ", sb_point_y(regular_polygon_center(polygon)), "] mm"
    ));
    echo(str(
        "First sharp vertex angle: ",
        regular_polygon_first_vertex_angle_degrees(polygon),
        " degrees"
    ));

    if (report_level == "full") {
        if (is_list(radii))
            echo(str("Resolved source radius list: ", radii));
        echo(str("Start vertex index: ",
            regular_polygon_start_vertex_index(polygon)));
        echo(str("Notes: ", regular_polygon_notes(polygon)));
    }
}

module report_regular_polygon_compilation(
    compilation,
    report_level = "full"
) {
    vertices = regular_polygon_compilation_vertices(compilation);

    echo("--- Strap Bender regular-polygon compilation ---");
    echo(str("Source: ",
        regular_polygon_compilation_source_name(compilation)));
    echo(str("Resolved sharp circumradius: ",
        regular_polygon_compilation_circumradius(compilation), " mm"));
    echo(str("Resolved sharp apothem: ",
        regular_polygon_compilation_apothem(compilation), " mm"));
    echo(str("Resolved sharp side length: ",
        regular_polygon_compilation_side_length(compilation), " mm"));
    echo(str("Generated sharp vertices: ", len(vertices)));

    if (report_level == "full") {
        for (vertex_index = [0 : len(vertices) - 1])
            echo(str(
                "Vertex ", vertex_index, ": [",
                sb_point_x(vertices[vertex_index]), ", ",
                sb_point_y(vertices[vertex_index]), "]"
            ));
        echo(str("Notes: ",
            regular_polygon_compilation_notes(compilation)));
    }
}
