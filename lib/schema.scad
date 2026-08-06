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
STRAP_BENDER_SAMPLED_PATH_RECORD = "strap_bender_sampled_path";
STRAP_BENDER_VERTEX_POLYGON_RECORD = "strap_bender_vertex_polygon";
STRAP_BENDER_POLYGON_CORNER_RECORD = "strap_bender_polygon_corner";
STRAP_BENDER_POLYGON_EDGE_RECORD = "strap_bender_polygon_edge";
STRAP_BENDER_POLYGON_COMPILATION_RECORD =
    "strap_bender_polygon_compilation";

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

function sampled_path_spec(
    name,
    reference_axis,
    closure,
    points,
    chord_error_mm,
    max_angle_step_degrees,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_SAMPLED_PATH_RECORD,
    schema_version,
    name,
    reference_axis,
    closure,
    points,
    chord_error_mm,
    max_angle_step_degrees,
    notes
];

function vertex_polygon_spec(
    name,
    vertices,
    corner_radii,
    start_vertex_index = 0,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = let(
    resolved_corner_radii =
        is_num(corner_radii) && is_list(vertices) && len(vertices) > 0
            ? [for (vertex_index = [0 : len(vertices) - 1]) corner_radii]
            : corner_radii
) [
    STRAP_BENDER_VERTEX_POLYGON_RECORD,
    schema_version,
    name,
    vertices,
    resolved_corner_radii,
    start_vertex_index,
    notes
];

function polygon_corner_spec(
    source_vertex_index,
    vertex,
    incoming_edge_index,
    outgoing_edge_index,
    turn_angle_degrees,
    classification,
    inside_radius,
    tangent_setback,
    entry_point,
    exit_point,
    bend_command_index,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_POLYGON_CORNER_RECORD,
    schema_version,
    source_vertex_index,
    vertex,
    incoming_edge_index,
    outgoing_edge_index,
    turn_angle_degrees,
    classification,
    inside_radius,
    tangent_setback,
    entry_point,
    exit_point,
    bend_command_index
];

function polygon_edge_spec(
    source_edge_index,
    start_vertex_index,
    end_vertex_index,
    start_point,
    end_point,
    retained_length,
    heading_degrees,
    straight_command_index,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_POLYGON_EDGE_RECORD,
    schema_version,
    source_edge_index,
    start_vertex_index,
    end_vertex_index,
    start_point,
    end_point,
    retained_length,
    heading_degrees,
    straight_command_index
];

function polygon_compilation_spec(
    source_polygon_name,
    corners,
    edges,
    normalized_shape,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_POLYGON_COMPILATION_RECORD,
    schema_version,
    source_polygon_name,
    corners,
    edges,
    normalized_shape,
    notes
];
