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
