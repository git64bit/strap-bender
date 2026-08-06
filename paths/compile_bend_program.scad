//////////////////////////////////////////////////////////////////////
// LibFile: compile_bend_program.scad
// Project: Strap Bender
// FileGroup: Analytical Path Kernel
// FileSummary: Compiles explicit bend commands to exact line and arc records.
//////////////////////////////////////////////////////////////////////

function sb_compile_command(command, start_pose, station_start) =
    command_kind(command) == "straight"
        ? let(
            end_pose = sb_advance_straight_pose(
                start_pose,
                command_distance(command)
            ),
            station_end = station_start + command_distance(command)
        )
        analytical_line_primitive(
            source_index = command_source_index(command),
            label = command_label(command),
            start_pose = start_pose,
            end_pose = end_pose,
            station_start = station_start,
            station_end = station_end
        )
        : let(
            center = sb_bend_center(
                start_pose,
                command_angle_degrees(command),
                command_inside_radius(command)
            ),
            end_pose = sb_advance_bend_pose(
                start_pose,
                command_angle_degrees(command),
                command_inside_radius(command)
            ),
            station_end = station_start + sb_arc_length(
                command_inside_radius(command),
                command_angle_degrees(command)
            )
        )
        analytical_arc_primitive(
            source_index = command_source_index(command),
            label = command_label(command),
            start_pose = start_pose,
            end_pose = end_pose,
            station_start = station_start,
            station_end = station_end,
            center = center,
            angle_degrees = command_angle_degrees(command),
            inside_radius = command_inside_radius(command)
        );

function sb_compile_command_sequence(
    commands,
    command_index,
    current_pose,
    current_station
) =
    command_index >= len(commands)
        ? []
        : let(
            primitive = sb_compile_command(
                commands[command_index],
                current_pose,
                current_station
            ),
            remaining = sb_compile_command_sequence(
                commands,
                command_index + 1,
                primitive_end_pose(primitive),
                primitive_station_end(primitive)
            )
        )
        concat([primitive], remaining);

function compile_bend_program(shape) =
    let(
        primitives = sb_compile_command_sequence(
            shape_commands(shape),
            0,
            shape_start_pose(shape),
            0
        ),
        end_pose = primitive_end_pose(primitives[len(primitives) - 1]),
        bounds = sb_analytical_path_bounds_from_primitives(primitives)
    )
    analytical_path_spec(
        name = shape_name(shape),
        reference_axis = "finished_inside_edge",
        closure = shape_closure(shape),
        start_pose = shape_start_pose(shape),
        end_pose = end_pose,
        primitives = primitives,
        bounds = bounds,
        notes = str(
            "Derived from explicit bend-program commands. Stations and arc ",
            "lengths use the finished inside edge. This is not a neutral-axis ",
            "developed length or a cut length."
        )
    );

function analytical_path_straight_length(path) =
    sb_list_sum([
        for (primitive = analytical_path_primitives(path))
            if (primitive_kind(primitive) == "line")
                primitive_length(primitive)
    ]);

function analytical_path_arc_length(path) =
    sb_list_sum([
        for (primitive = analytical_path_primitives(path))
            if (primitive_kind(primitive) == "arc")
                primitive_length(primitive)
    ]);
