//////////////////////////////////////////////////////////////////////
// LibFile: schema.scad
// Project: Strap Bender
// FileGroup: Data Model
// FileSummary: Constructor functions for native Strap Bender records.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_PROJECT_RECORD = "strap_bender_project";
STRAP_BENDER_POSE_RECORD = "strap_bender_pose";
STRAP_BENDER_COMMAND_RECORD = "strap_bender_command";
STRAP_BENDER_SHAPE_RECORD = "strap_bender_shape";
STRAP_BENDER_ANALYTICAL_PRIMITIVE_RECORD =
    "strap_bender_analytical_primitive";
STRAP_BENDER_ANALYTICAL_PATH_RECORD = "strap_bender_analytical_path";

function project_spec(
    name,
    kind,
    status = "stub",
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PROJECT_RECORD,
    schema_version,
    name,
    kind,
    status,
    notes
];

function start_pose_spec(
    x = 0,
    y = 0,
    heading_degrees = 0,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_POSE_RECORD,
    schema_version,
    x,
    y,
    heading_degrees
];

function straight_command(
    source_index,
    distance,
    label = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_COMMAND_RECORD,
    schema_version,
    "straight",
    source_index,
    distance,
    undef,
    undef,
    label
];

function bend_command(
    source_index,
    angle_degrees,
    inside_radius,
    label = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_COMMAND_RECORD,
    schema_version,
    "bend",
    source_index,
    undef,
    angle_degrees,
    inside_radius,
    label
];

function bend_program_shape_spec(
    name,
    commands,
    closure = "open",
    start_pose = start_pose_spec(),
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_SHAPE_RECORD,
    schema_version,
    name,
    closure,
    start_pose,
    "bend_program",
    commands,
    notes
];

function analytical_line_primitive(
    source_index,
    label,
    start_pose,
    end_pose,
    station_start,
    station_end,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_ANALYTICAL_PRIMITIVE_RECORD,
    schema_version,
    "line",
    source_index,
    label,
    start_pose,
    end_pose,
    station_start,
    station_end,
    undef,
    undef,
    undef
];

function analytical_arc_primitive(
    source_index,
    label,
    start_pose,
    end_pose,
    station_start,
    station_end,
    center,
    angle_degrees,
    inside_radius,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_ANALYTICAL_PRIMITIVE_RECORD,
    schema_version,
    "arc",
    source_index,
    label,
    start_pose,
    end_pose,
    station_start,
    station_end,
    center,
    angle_degrees,
    inside_radius
];

function analytical_path_spec(
    name,
    reference_axis,
    closure,
    start_pose,
    end_pose,
    primitives,
    bounds,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_ANALYTICAL_PATH_RECORD,
    schema_version,
    name,
    reference_axis,
    closure,
    start_pose,
    end_pose,
    primitives,
    bounds,
    notes
];
