//////////////////////////////////////////////////////////////////////
// LibFile: fixture_schema.scad
// Project: Strap Bender
// FileGroup: Fixture Data Model
// FileSummary: Constructors for the first production-shape fixture family.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_BEND_POST_FIXTURE_RECORD =
    "strap_bender_bend_post_fixture";
STRAP_BENDER_BEND_POST_STATION_RECORD =
    "strap_bender_bend_post_station";
STRAP_BENDER_BEND_POST_FIXTURE_PLAN_RECORD =
    "strap_bender_bend_post_fixture_plan";

function bend_post_fixture_spec(
    name,
    strap_material_name,
    radius_mode = "nominal_target",
    base_thickness_mm = 3,
    base_margin_mm = 8,
    post_height_mm = 18,
    max_base_width_mm = 220,
    max_base_depth_mm = 220,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    retention_mode = "none",
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_BEND_POST_FIXTURE_RECORD,
    schema_version,
    name,
    strap_material_name,
    radius_mode,
    base_thickness_mm,
    base_margin_mm,
    post_height_mm,
    max_base_width_mm,
    max_base_depth_mm,
    tool_surface_chord_error_mm,
    tool_surface_max_angle_step_degrees,
    retention_mode,
    notes
];

function bend_post_station_spec(
    source_index,
    label,
    station_start,
    station_end,
    target_center,
    tool_center,
    angle_degrees,
    target_inside_radius_mm,
    tool_inside_radius_mm,
    target_entry_point,
    target_exit_point,
    tool_entry_point,
    tool_exit_point,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_BEND_POST_STATION_RECORD,
    schema_version,
    source_index,
    label,
    station_start,
    station_end,
    target_center,
    tool_center,
    angle_degrees,
    target_inside_radius_mm,
    tool_inside_radius_mm,
    target_entry_point,
    target_exit_point,
    tool_entry_point,
    tool_exit_point
];

function bend_post_fixture_plan_spec(
    fixture_name,
    source_path_name,
    reference_axis,
    status,
    stations,
    base_bounds,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_BEND_POST_FIXTURE_PLAN_RECORD,
    schema_version,
    fixture_name,
    source_path_name,
    reference_axis,
    status,
    stations,
    base_bounds,
    notes
];
