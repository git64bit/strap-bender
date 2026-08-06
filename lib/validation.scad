//////////////////////////////////////////////////////////////////////
// LibFile: validation.scad
// Project: Strap Bender
// FileGroup: Validation
// FileSummary: Validates source records and derived analytical paths.
//////////////////////////////////////////////////////////////////////

function sb_finite_number(value) =
    is_num(value) && value == value && abs(value) < 1e300;

function sb_nonempty_string(value) = is_string(value) && len(value) > 0;
function sb_schema_version_valid(value) =
    value == STRAP_BENDER_SCHEMA_VERSION;
function sb_project_kind_valid(kind) =
    kind == "bend_program" || kind == "catalog";
function sb_project_status_valid(status) =
    status == "stub" ||
    status == "laboratory" ||
    status == "released" ||
    status == "retired";
function sb_closure_valid(closure) =
    closure == "open" || closure == "closed";
function sb_authoring_kind_valid(kind) = kind == "bend_program";
function sb_command_kind_valid(kind) =
    kind == "straight" || kind == "bend";
function sb_primitive_kind_valid(kind) =
    kind == "line" || kind == "arc";
function sb_reference_axis_valid(axis) = axis == "finished_inside_edge";
function sb_nonnegative_integer(value) =
    sb_finite_number(value) && value >= 0 && floor(value) == value;
function sb_bend_angle_valid(value) =
    sb_finite_number(value) && value != 0 && abs(value) < 360;
function sb_point_valid(point) =
    is_list(point) && len(point) == 2 &&
    sb_finite_number(sb_point_x(point)) &&
    sb_finite_number(sb_point_y(point));
function sb_bounds_valid(bounds) =
    is_list(bounds) && len(bounds) == 4 &&
    sb_finite_number(sb_bounds_min_x(bounds)) &&
    sb_finite_number(sb_bounds_min_y(bounds)) &&
    sb_finite_number(sb_bounds_max_x(bounds)) &&
    sb_finite_number(sb_bounds_max_y(bounds)) &&
    sb_bounds_min_x(bounds) <= sb_bounds_max_x(bounds) &&
    sb_bounds_min_y(bounds) <= sb_bounds_max_y(bounds);
function sb_bounds_near(first, second, tolerance) =
    sb_near(sb_bounds_min_x(first), sb_bounds_min_x(second), tolerance) &&
    sb_near(sb_bounds_min_y(first), sb_bounds_min_y(second), tolerance) &&
    sb_near(sb_bounds_max_x(first), sb_bounds_max_x(second), tolerance) &&
    sb_near(sb_bounds_max_y(first), sb_bounds_max_y(second), tolerance);

function sb_analytical_primitives_continuous(
    primitives,
    index = 1,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM,
    station_tolerance = SB_NUMERIC_STATION_TOLERANCE_MM,
    angle_tolerance = SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
) =
    index >= len(primitives)
        ? true
        : sb_pose_near(
            primitive_end_pose(primitives[index - 1]),
            primitive_start_pose(primitives[index]),
            position_tolerance,
            angle_tolerance
        ) &&
        sb_near(
            primitive_station_end(primitives[index - 1]),
            primitive_station_start(primitives[index]),
            station_tolerance
        ) &&
        sb_analytical_primitives_continuous(
            primitives,
            index + 1,
            position_tolerance,
            station_tolerance,
            angle_tolerance
        );

function analytical_path_closure_position_error(path) =
    sb_pose_position_distance(
        analytical_path_start_pose(path),
        analytical_path_end_pose(path)
    );

function analytical_path_closure_angle_error(path) =
    sb_smallest_angle_delta_degrees(
        pose_heading_degrees(analytical_path_start_pose(path)),
        pose_heading_degrees(analytical_path_end_pose(path))
    );

module validate_project(project) {
    assert(is_list(project) && len(project) == 6,
        "Strap Bender project records must contain six fields.");
    assert(project[PR_RECORD_TYPE] == STRAP_BENDER_PROJECT_RECORD,
        "Invalid Strap Bender project record type.");
    assert(sb_schema_version_valid(project[PR_SCHEMA_VERSION]),
        str("Unsupported Strap Bender project schema version: ",
            project[PR_SCHEMA_VERSION]));
    assert(sb_nonempty_string(project_name(project)),
        "Strap Bender project name must be a non-empty string.");
    assert(sb_project_kind_valid(project_kind(project)),
        str("Unknown Strap Bender project kind: ", project_kind(project)));
    assert(sb_project_status_valid(project_status(project)),
        str("Unknown Strap Bender project status: ", project_status(project)));
    assert(is_string(project_notes(project)),
        "Strap Bender project notes must be a string.");
}

module validate_start_pose(pose) {
    assert(is_list(pose) && len(pose) == 5,
        "Strap Bender start-pose records must contain five fields.");
    assert(pose[PO_RECORD_TYPE] == STRAP_BENDER_POSE_RECORD,
        "Invalid Strap Bender start-pose record type.");
    assert(sb_schema_version_valid(pose[PO_SCHEMA_VERSION]),
        str("Unsupported Strap Bender pose schema version: ",
            pose[PO_SCHEMA_VERSION]));
    assert(sb_finite_number(pose_x(pose)),
        "Start-pose X must be finite.");
    assert(sb_finite_number(pose_y(pose)),
        "Start-pose Y must be finite.");
    assert(sb_finite_number(pose_heading_degrees(pose)),
        "Start-pose heading must be finite.");
}

module validate_bend_program_command(command) {
    assert(is_list(command) && len(command) == 8,
        "Strap Bender command records must contain eight fields.");
    assert(command[CM_RECORD_TYPE] == STRAP_BENDER_COMMAND_RECORD,
        "Invalid Strap Bender command record type.");
    assert(sb_schema_version_valid(command[CM_SCHEMA_VERSION]),
        str("Unsupported Strap Bender command schema version: ",
            command[CM_SCHEMA_VERSION]));
    assert(sb_command_kind_valid(command_kind(command)),
        str("Unknown bend-program command kind: ", command_kind(command)));
    assert(sb_nonnegative_integer(command_source_index(command)),
        "Command source index must be a nonnegative integer.");
    assert(is_string(command_label(command)),
        "Command label must be a string.");

    if (command_kind(command) == "straight") {
        assert(sb_finite_number(command_distance(command)) &&
            command_distance(command) > 0,
            "Straight distance must be finite and greater than zero.");
        assert(is_undef(command_angle_degrees(command)) &&
            is_undef(command_inside_radius(command)),
            "Straight commands may not carry bend fields.");
    } else {
        assert(is_undef(command_distance(command)),
            "Bend commands may not carry a straight distance.");
        assert(sb_bend_angle_valid(command_angle_degrees(command)),
            "Bend angle must be finite, nonzero, and below 360 degrees.");
        assert(sb_finite_number(command_inside_radius(command)) &&
            command_inside_radius(command) > 0,
            "Finished inside radius must be finite and greater than zero.");
    }
}

module validate_bend_program_commands(commands) {
    assert(is_list(commands) && len(commands) > 0,
        "A bend program must contain at least one command.");

    for (source_index = [0 : len(commands) - 1]) {
        command = commands[source_index];
        validate_bend_program_command(command);
        assert(command_source_index(command) == source_index,
            str("Command at list position ", source_index,
                " must use the same zero-based source index."));
    }
}

module validate_bend_program_shape(shape) {
    assert(is_list(shape) && len(shape) == 8,
        "Strap Bender shape records must contain eight fields.");
    assert(shape[SH_RECORD_TYPE] == STRAP_BENDER_SHAPE_RECORD,
        "Invalid Strap Bender shape record type.");
    assert(sb_schema_version_valid(shape[SH_SCHEMA_VERSION]),
        str("Unsupported Strap Bender shape schema version: ",
            shape[SH_SCHEMA_VERSION]));
    assert(sb_nonempty_string(shape_name(shape)),
        "Strap Bender shape name must be a non-empty string.");
    assert(sb_closure_valid(shape_closure(shape)),
        str("Unknown Strap Bender closure policy: ", shape_closure(shape)));
    assert(sb_authoring_kind_valid(shape_authoring_kind(shape)),
        str("Unknown Strap Bender authoring kind: ",
            shape_authoring_kind(shape)));
    assert(is_string(shape_notes(shape)),
        "Strap Bender shape notes must be a string.");

    validate_start_pose(shape_start_pose(shape));
    validate_bend_program_commands(shape_commands(shape));
}

module validate_analytical_primitive(primitive) {
    assert(is_list(primitive) && len(primitive) == 12,
        "Analytical primitive records must contain twelve fields.");
    assert(primitive[AP_RECORD_TYPE] ==
        STRAP_BENDER_ANALYTICAL_PRIMITIVE_RECORD,
        "Invalid analytical primitive record type.");
    assert(sb_schema_version_valid(primitive[AP_SCHEMA_VERSION]),
        str("Unsupported analytical primitive schema version: ",
            primitive[AP_SCHEMA_VERSION]));
    assert(sb_primitive_kind_valid(primitive_kind(primitive)),
        str("Unknown analytical primitive kind: ",
            primitive_kind(primitive)));
    assert(sb_nonnegative_integer(primitive_source_index(primitive)),
        "Analytical primitive source index must be nonnegative.");
    assert(is_string(primitive_label(primitive)),
        "Analytical primitive label must be a string.");
    validate_start_pose(primitive_start_pose(primitive));
    validate_start_pose(primitive_end_pose(primitive));
    assert(sb_finite_number(primitive_station_start(primitive)) &&
        primitive_station_start(primitive) >= 0,
        "Analytical primitive start station must be nonnegative.");
    assert(sb_finite_number(primitive_station_end(primitive)) &&
        primitive_station_end(primitive) >
            primitive_station_start(primitive),
        "Analytical primitive end station must exceed its start station.");

    if (primitive_kind(primitive) == "line") {
        assert(is_undef(primitive_center(primitive)) &&
            is_undef(primitive_angle_degrees(primitive)) &&
            is_undef(primitive_inside_radius(primitive)),
            "Line primitives may not carry arc fields.");
        assert(sb_near(
            primitive_length(primitive),
            sb_pose_position_distance(
                primitive_start_pose(primitive),
                primitive_end_pose(primitive)
            ),
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ), "Line primitive station length must equal endpoint distance.");
        assert(sb_smallest_angle_delta_degrees(
            pose_heading_degrees(primitive_start_pose(primitive)),
            pose_heading_degrees(primitive_end_pose(primitive))
        ) <= SB_NUMERIC_ANGLE_TOLERANCE_DEGREES,
            "Line primitive heading must remain constant.");
    } else {
        assert(sb_point_valid(primitive_center(primitive)),
            "Arc primitive center must be a finite XY point.");
        assert(sb_bend_angle_valid(primitive_angle_degrees(primitive)),
            "Arc primitive angle is outside the supported domain.");
        assert(sb_finite_number(primitive_inside_radius(primitive)) &&
            primitive_inside_radius(primitive) > 0,
            "Arc primitive inside radius must be positive.");
        assert(sb_near(
            sb_point_distance(
                sb_pose_point(primitive_start_pose(primitive)),
                primitive_center(primitive)
            ),
            primitive_inside_radius(primitive),
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ), "Arc start point must lie on the recorded circle.");
        assert(sb_near(
            sb_point_distance(
                sb_pose_point(primitive_end_pose(primitive)),
                primitive_center(primitive)
            ),
            primitive_inside_radius(primitive),
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ), "Arc end point must lie on the recorded circle.");
        assert(sb_near(
            primitive_length(primitive),
            sb_arc_length(
                primitive_inside_radius(primitive),
                primitive_angle_degrees(primitive)
            ),
            SB_NUMERIC_STATION_TOLERANCE_MM
        ), "Arc primitive station length must equal exact arc length.");
        assert(sb_smallest_angle_delta_degrees(
            pose_heading_degrees(primitive_end_pose(primitive)),
            pose_heading_degrees(primitive_start_pose(primitive)) +
                primitive_angle_degrees(primitive)
        ) <= SB_NUMERIC_ANGLE_TOLERANCE_DEGREES,
            "Arc end heading must equal start heading plus signed turn.");
    }
}

module validate_analytical_path(path) {
    assert(is_list(path) && len(path) == 10,
        "Analytical path records must contain ten fields.");
    assert(path[PA_RECORD_TYPE] == STRAP_BENDER_ANALYTICAL_PATH_RECORD,
        "Invalid analytical path record type.");
    assert(sb_schema_version_valid(path[PA_SCHEMA_VERSION]),
        str("Unsupported analytical path schema version: ",
            path[PA_SCHEMA_VERSION]));
    assert(sb_nonempty_string(analytical_path_name(path)),
        "Analytical path name must be a non-empty string.");
    assert(sb_reference_axis_valid(analytical_path_reference_axis(path)),
        str("Unsupported analytical reference axis: ",
            analytical_path_reference_axis(path)));
    assert(sb_closure_valid(analytical_path_closure(path)),
        str("Unknown analytical path closure policy: ",
            analytical_path_closure(path)));
    assert(is_string(analytical_path_notes(path)),
        "Analytical path notes must be a string.");
    validate_start_pose(analytical_path_start_pose(path));
    validate_start_pose(analytical_path_end_pose(path));

    primitives = analytical_path_primitives(path);
    assert(is_list(primitives) && len(primitives) > 0,
        "An analytical path must contain at least one primitive.");
    for (primitive = primitives)
        validate_analytical_primitive(primitive);

    assert(sb_pose_near(
        analytical_path_start_pose(path),
        primitive_start_pose(primitives[0])
    ), "Analytical path start pose must match its first primitive.");
    assert(sb_pose_near(
        analytical_path_end_pose(path),
        primitive_end_pose(primitives[len(primitives) - 1])
    ), "Analytical path end pose must match its last primitive.");
    assert(sb_near(
        primitive_station_start(primitives[0]),
        0,
        SB_NUMERIC_STATION_TOLERANCE_MM
    ), "Analytical path stationing must begin at zero.");
    assert(sb_analytical_primitives_continuous(primitives),
        "Analytical primitives must be pose- and station-continuous.");

    bounds = analytical_path_bounds(path);
    recomputed_bounds =
        sb_analytical_path_bounds_from_primitives(primitives);
    assert(sb_bounds_valid(bounds),
        "Analytical path bounds must be finite and ordered.");
    assert(sb_bounds_near(
        bounds,
        recomputed_bounds,
        SB_NUMERIC_POSITION_TOLERANCE_MM
    ), "Analytical path bounds must match exact primitive extrema.");

    if (analytical_path_closure(path) == "closed") {
        assert(analytical_path_closure_position_error(path) <=
            SB_CLOSURE_POSITION_TOLERANCE_MM,
            "Closed path endpoint exceeds position tolerance.");
        assert(analytical_path_closure_angle_error(path) <=
            SB_CLOSURE_ANGLE_TOLERANCE_DEGREES,
            "Closed path endpoint exceeds heading tolerance.");
    }
}
