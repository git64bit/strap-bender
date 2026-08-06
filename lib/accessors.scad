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

function sampled_path_name(path) = path[SP_NAME];
function sampled_path_reference_axis(path) = path[SP_REFERENCE_AXIS];
function sampled_path_closure(path) = path[SP_CLOSURE];
function sampled_path_points(path) = path[SP_POINTS];
function sampled_path_chord_error_mm(path) = path[SP_CHORD_ERROR_MM];
function sampled_path_max_angle_step_degrees(path) =
    path[SP_MAX_ANGLE_STEP_DEGREES];
function sampled_path_notes(path) = path[SP_NOTES];

function value_schedule_kind(schedule) = schedule[VS_KIND];
function value_schedule_values(schedule) = schedule[VS_VALUES];
function value_schedule_default_value(schedule) = schedule[VS_DEFAULT_VALUE];
function value_schedule_selected_value(schedule) = schedule[VS_SELECTED_VALUE];
function value_schedule_interval(schedule) = schedule[VS_INTERVAL];
function value_schedule_first_position(schedule) =
    schedule[VS_FIRST_POSITION];
function value_schedule_label(schedule) = schedule[VS_LABEL];

function vertex_polygon_name(polygon) = polygon[VP_NAME];
function vertex_polygon_vertices(polygon) = polygon[VP_VERTICES];
function vertex_polygon_corner_radii(polygon) = polygon[VP_CORNER_RADII];
function vertex_polygon_start_vertex_index(polygon) =
    polygon[VP_START_VERTEX_INDEX];
function vertex_polygon_notes(polygon) = polygon[VP_NOTES];

function polygon_corner_source_vertex_index(corner) =
    corner[PC_SOURCE_VERTEX_INDEX];
function polygon_corner_vertex(corner) = corner[PC_VERTEX];
function polygon_corner_incoming_edge_index(corner) =
    corner[PC_INCOMING_EDGE_INDEX];
function polygon_corner_outgoing_edge_index(corner) =
    corner[PC_OUTGOING_EDGE_INDEX];
function polygon_corner_turn_angle_degrees(corner) =
    corner[PC_TURN_ANGLE_DEGREES];
function polygon_corner_classification(corner) =
    corner[PC_CLASSIFICATION];
function polygon_corner_inside_radius(corner) = corner[PC_INSIDE_RADIUS];
function polygon_corner_tangent_setback(corner) =
    corner[PC_TANGENT_SETBACK];
function polygon_corner_entry_point(corner) = corner[PC_ENTRY_POINT];
function polygon_corner_exit_point(corner) = corner[PC_EXIT_POINT];
function polygon_corner_bend_command_index(corner) =
    corner[PC_BEND_COMMAND_INDEX];

function polygon_edge_source_index(edge) = edge[PE_SOURCE_EDGE_INDEX];
function polygon_edge_start_vertex_index(edge) =
    edge[PE_START_VERTEX_INDEX];
function polygon_edge_end_vertex_index(edge) = edge[PE_END_VERTEX_INDEX];
function polygon_edge_start_point(edge) = edge[PE_START_POINT];
function polygon_edge_end_point(edge) = edge[PE_END_POINT];
function polygon_edge_retained_length(edge) = edge[PE_RETAINED_LENGTH];
function polygon_edge_heading_degrees(edge) = edge[PE_HEADING_DEGREES];
function polygon_edge_straight_command_index(edge) =
    edge[PE_STRAIGHT_COMMAND_INDEX];

function polygon_compilation_source_name(compilation) =
    compilation[PX_SOURCE_POLYGON_NAME];
function polygon_compilation_corners(compilation) = compilation[PX_CORNERS];
function polygon_compilation_edges(compilation) = compilation[PX_EDGES];
function polygon_compilation_normalized_shape(compilation) =
    compilation[PX_NORMALIZED_SHAPE];
function polygon_compilation_notes(compilation) = compilation[PX_NOTES];


function regular_polygon_name(polygon) = polygon[RP_NAME];
function regular_polygon_side_count(polygon) = polygon[RP_SIDE_COUNT];
function regular_polygon_dimension_kind(polygon) =
    polygon[RP_DIMENSION_KIND];
function regular_polygon_dimension_value(polygon) =
    polygon[RP_DIMENSION_VALUE];
function regular_polygon_corner_radii(polygon) = polygon[RP_CORNER_RADII];
function regular_polygon_center(polygon) = polygon[RP_CENTER];
function regular_polygon_first_vertex_angle_degrees(polygon) =
    polygon[RP_FIRST_VERTEX_ANGLE_DEGREES];
function regular_polygon_start_vertex_index(polygon) =
    polygon[RP_START_VERTEX_INDEX];
function regular_polygon_notes(polygon) = polygon[RP_NOTES];

function regular_polygon_compilation_source_name(compilation) =
    compilation[RX_SOURCE_POLYGON_NAME];
function regular_polygon_compilation_circumradius(compilation) =
    compilation[RX_RESOLVED_CIRCUMRADIUS];
function regular_polygon_compilation_apothem(compilation) =
    compilation[RX_RESOLVED_APOTHEM];
function regular_polygon_compilation_side_length(compilation) =
    compilation[RX_RESOLVED_SIDE_LENGTH];
function regular_polygon_compilation_vertices(compilation) =
    compilation[RX_VERTICES];
function regular_polygon_compilation_vertex_polygon(compilation) =
    compilation[RX_GENERATED_VERTEX_POLYGON];
function regular_polygon_compilation_notes(compilation) =
    compilation[RX_NOTES];

function pattern_element_kind(element) = element[PT_KIND];
function pattern_element_distance_parameter(element) =
    element[PT_DISTANCE_PARAMETER];
function pattern_element_angle_parameter(element) =
    element[PT_ANGLE_PARAMETER];
function pattern_element_radius_parameter(element) =
    element[PT_RADIUS_PARAMETER];
function pattern_element_angle_multiplier(element) =
    element[PT_ANGLE_MULTIPLIER];
function pattern_element_label(element) = element[PT_LABEL];

function pattern_block_name(pattern) = pattern[PB_NAME];
function pattern_block_elements(pattern) = pattern[PB_ELEMENTS];
function pattern_block_notes(pattern) = pattern[PB_NOTES];

function pattern_parameter_name(parameter) = parameter[PP_NAME];
function pattern_parameter_value_source(parameter) =
    parameter[PP_VALUE_SOURCE];
function pattern_parameter_label(parameter) = parameter[PP_LABEL];

function pattern_instance_name(instance) = instance[PI_NAME];
function pattern_instance_pattern_name(instance) = instance[PI_PATTERN_NAME];
function pattern_instance_repeat_count(instance) = instance[PI_REPEAT_COUNT];
function pattern_instance_parameters(instance) = instance[PI_PARAMETERS];
function pattern_instance_closure(instance) = instance[PI_CLOSURE];
function pattern_instance_start_pose(instance) = instance[PI_START_POSE];
function pattern_instance_notes(instance) = instance[PI_NOTES];

function pattern_provenance_command_index(trace) =
    trace[PV_COMMAND_INDEX];
function pattern_provenance_repetition_index(trace) =
    trace[PV_REPETITION_INDEX];
function pattern_provenance_local_element_index(trace) =
    trace[PV_LOCAL_ELEMENT_INDEX];
function pattern_provenance_local_label(trace) = trace[PV_LOCAL_LABEL];

function pattern_compilation_source_instance_name(compilation) =
    compilation[PCX_SOURCE_INSTANCE_NAME];
function pattern_compilation_source_pattern_name(compilation) =
    compilation[PCX_SOURCE_PATTERN_NAME];
function pattern_compilation_resolved_parameters(compilation) =
    compilation[PCX_RESOLVED_PARAMETERS];
function pattern_compilation_provenance(compilation) =
    compilation[PCX_PROVENANCE];
function pattern_compilation_normalized_shape(compilation) =
    compilation[PCX_NORMALIZED_SHAPE];
function pattern_compilation_notes(compilation) = compilation[PCX_NOTES];
