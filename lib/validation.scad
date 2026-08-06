//////////////////////////////////////////////////////////////////////
// LibFile: validation.scad
// Project: Strap Bender
// FileGroup: Validation
// FileSummary: Validates project, pose, command, and shape records.
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
function sb_nonnegative_integer(value) =
    sb_finite_number(value) && value >= 0 && floor(value) == value;

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
        assert(sb_finite_number(command_angle_degrees(command)) &&
            command_angle_degrees(command) != 0,
            "Bend angle must be finite and nonzero.");
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
