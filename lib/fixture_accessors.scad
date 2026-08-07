//////////////////////////////////////////////////////////////////////
// LibFile: fixture_accessors.scad
// Project: Strap Bender
// FileGroup: Fixture Data Model
// FileSummary: Named accessors for bend-post fixture source and plan records.
//////////////////////////////////////////////////////////////////////

function bend_post_fixture_name(fixture) = fixture[BF_NAME];
function bend_post_fixture_strap_material_name(fixture) =
    fixture[BF_STRAP_MATERIAL_NAME];
function bend_post_fixture_radius_mode(fixture) = fixture[BF_RADIUS_MODE];
function bend_post_fixture_base_thickness_mm(fixture) =
    fixture[BF_BASE_THICKNESS_MM];
function bend_post_fixture_base_margin_mm(fixture) =
    fixture[BF_BASE_MARGIN_MM];
function bend_post_fixture_post_height_mm(fixture) =
    fixture[BF_POST_HEIGHT_MM];
function bend_post_fixture_max_base_width_mm(fixture) =
    fixture[BF_MAX_BASE_WIDTH_MM];
function bend_post_fixture_max_base_depth_mm(fixture) =
    fixture[BF_MAX_BASE_DEPTH_MM];
function bend_post_fixture_tool_surface_chord_error_mm(fixture) =
    fixture[BF_TOOL_SURFACE_CHORD_ERROR_MM];
function bend_post_fixture_tool_surface_max_angle_step_degrees(fixture) =
    fixture[BF_TOOL_SURFACE_MAX_ANGLE_STEP_DEGREES];
function bend_post_fixture_retention_mode(fixture) =
    fixture[BF_RETENTION_MODE];
function bend_post_fixture_notes(fixture) = fixture[BF_NOTES];

function bend_post_station_source_index(station) = station[BS_SOURCE_INDEX];
function bend_post_station_label(station) = station[BS_LABEL];
function bend_post_station_station_start(station) = station[BS_STATION_START];
function bend_post_station_station_end(station) = station[BS_STATION_END];
function bend_post_station_target_center(station) = station[BS_TARGET_CENTER];
function bend_post_station_tool_center(station) = station[BS_TOOL_CENTER];
function bend_post_station_angle_degrees(station) = station[BS_ANGLE_DEGREES];
function bend_post_station_target_inside_radius_mm(station) =
    station[BS_TARGET_INSIDE_RADIUS_MM];
function bend_post_station_tool_inside_radius_mm(station) =
    station[BS_TOOL_INSIDE_RADIUS_MM];
function bend_post_station_target_entry_point(station) =
    station[BS_TARGET_ENTRY_POINT];
function bend_post_station_target_exit_point(station) =
    station[BS_TARGET_EXIT_POINT];
function bend_post_station_tool_entry_point(station) =
    station[BS_TOOL_ENTRY_POINT];
function bend_post_station_tool_exit_point(station) =
    station[BS_TOOL_EXIT_POINT];

function bend_post_fixture_plan_fixture_name(plan) = plan[BP_FIXTURE_NAME];
function bend_post_fixture_plan_source_path_name(plan) =
    plan[BP_SOURCE_PATH_NAME];
function bend_post_fixture_plan_reference_axis(plan) =
    plan[BP_REFERENCE_AXIS];
function bend_post_fixture_plan_status(plan) = plan[BP_STATUS];
function bend_post_fixture_plan_stations(plan) = plan[BP_STATIONS];
function bend_post_fixture_plan_base_bounds(plan) = plan[BP_BASE_BOUNDS];
function bend_post_fixture_plan_notes(plan) = plan[BP_NOTES];

function bend_post_fixture_plan_base_width_mm(plan) =
    sb_bounds_max_x(bend_post_fixture_plan_base_bounds(plan)) -
    sb_bounds_min_x(bend_post_fixture_plan_base_bounds(plan));
function bend_post_fixture_plan_base_depth_mm(plan) =
    sb_bounds_max_y(bend_post_fixture_plan_base_bounds(plan)) -
    sb_bounds_min_y(bend_post_fixture_plan_base_bounds(plan));
