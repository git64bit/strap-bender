//////////////////////////////////////////////////////////////////////
// LibFile: reporting.scad
// Project: Strap Bender
// FileGroup: Reporting
// FileSummary: Reports resolved projects and bend-program records.
//////////////////////////////////////////////////////////////////////

module report_project(project, report_level = "full") {
    echo("--- Strap Bender project ---");
    echo(str("Name: ", project_name(project)));
    echo(str("Kind: ", project_kind(project)));
    echo(str("Status: ", project_status(project)));

    if (report_level == "full")
        echo(str("Notes: ", project_notes(project)));
}

module report_start_pose(pose) {
    echo(str(
        "Start pose: [",
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
