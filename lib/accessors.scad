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
