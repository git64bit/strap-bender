//////////////////////////////////////////////////////////////////////
// LibFile: accessors.scad
// Project: Strap Bender
// FileGroup: Data Model
// FileSummary: Named accessors for native Strap Bender records.
//////////////////////////////////////////////////////////////////////

function project_name(project) = project[PR_NAME];
function project_kind(project) = project[PR_KIND];
function project_status(project) = project[PR_STATUS];
function project_notes(project) = project[PR_NOTES];

function pose_x(pose) = pose[PO_X];
function pose_y(pose) = pose[PO_Y];
function pose_heading_degrees(pose) = pose[PO_HEADING_DEGREES];

function command_kind(command) = command[CM_KIND];
function command_source_index(command) = command[CM_SOURCE_INDEX];
function command_distance(command) = command[CM_DISTANCE];
function command_angle_degrees(command) = command[CM_ANGLE_DEGREES];
function command_inside_radius(command) = command[CM_INSIDE_RADIUS];
function command_label(command) = command[CM_LABEL];

function shape_name(shape) = shape[SH_NAME];
function shape_closure(shape) = shape[SH_CLOSURE];
function shape_start_pose(shape) = shape[SH_START_POSE];
function shape_authoring_kind(shape) = shape[SH_AUTHORING_KIND];
function shape_commands(shape) = shape[SH_COMMANDS];
function shape_notes(shape) = shape[SH_NOTES];

function primitive_kind(primitive) = primitive[AP_KIND];
function primitive_source_index(primitive) = primitive[AP_SOURCE_INDEX];
function primitive_label(primitive) = primitive[AP_LABEL];
function primitive_start_pose(primitive) = primitive[AP_START_POSE];
function primitive_end_pose(primitive) = primitive[AP_END_POSE];
function primitive_station_start(primitive) = primitive[AP_STATION_START];
function primitive_station_end(primitive) = primitive[AP_STATION_END];
function primitive_center(primitive) = primitive[AP_CENTER];
function primitive_angle_degrees(primitive) =
    primitive[AP_ANGLE_DEGREES];
function primitive_inside_radius(primitive) = primitive[AP_INSIDE_RADIUS];
function primitive_length(primitive) =
    primitive_station_end(primitive) - primitive_station_start(primitive);

function analytical_path_name(path) = path[PA_NAME];
function analytical_path_reference_axis(path) = path[PA_REFERENCE_AXIS];
function analytical_path_closure(path) = path[PA_CLOSURE];
function analytical_path_start_pose(path) = path[PA_START_POSE];
function analytical_path_end_pose(path) = path[PA_END_POSE];
function analytical_path_primitives(path) = path[PA_PRIMITIVES];
function analytical_path_bounds(path) = path[PA_BOUNDS];
function analytical_path_notes(path) = path[PA_NOTES];
function analytical_path_length(path) =
    len(analytical_path_primitives(path)) == 0
        ? 0
        : primitive_station_end(
            analytical_path_primitives(path)[
                len(analytical_path_primitives(path)) - 1
            ]
        );
