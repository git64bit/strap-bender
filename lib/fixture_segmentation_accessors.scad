//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_accessors.scad
// Project: Strap Bender
// FileGroup: Fixture Segmentation Data Model
// FileSummary: Named accessors for long-form fixture segmentation records.
//////////////////////////////////////////////////////////////////////

function fixture_datum_station_mm(datum) = datum[FD_STATION_MM];
function fixture_datum_point(datum) = datum[FD_POINT];
function fixture_datum_heading_degrees(datum) = datum[FD_HEADING_DEGREES];
function fixture_datum_role(datum) = datum[FD_ROLE];
function fixture_datum_source_index(datum) = datum[FD_SOURCE_INDEX];
function fixture_datum_label(datum) = datum[FD_LABEL];

function fixture_component_id(component) = component[FC_COMPONENT_ID];
function fixture_component_index(component) = component[FC_COMPONENT_INDEX];
function fixture_component_station_start_mm(component) =
    component[FC_STATION_START_MM];
function fixture_component_station_end_mm(component) =
    component[FC_STATION_END_MM];
function fixture_component_start_datum(component) = component[FC_START_DATUM];
function fixture_component_end_datum(component) = component[FC_END_DATUM];
function fixture_component_bend_stations(component) =
    component[FC_BEND_STATIONS];
function fixture_component_base_bounds(component) = component[FC_BASE_BOUNDS];
function fixture_component_notes(component) = component[FC_NOTES];
function fixture_component_base_width_mm(component) =
    sb_bounds_width(fixture_component_base_bounds(component));
function fixture_component_base_depth_mm(component) =
    sb_bounds_height(fixture_component_base_bounds(component));
function fixture_component_station_length_mm(component) =
    fixture_component_station_end_mm(component) -
    fixture_component_station_start_mm(component);
function fixture_component_local_point(component, point) = [
    sb_point_x(point) - sb_bounds_min_x(fixture_component_base_bounds(component)),
    sb_point_y(point) - sb_bounds_min_y(fixture_component_base_bounds(component))
];
function fixture_component_local_start_point(component) =
    fixture_component_local_point(
        component,
        fixture_datum_point(fixture_component_start_datum(component))
    );
function fixture_component_local_end_point(component) =
    fixture_component_local_point(
        component,
        fixture_datum_point(fixture_component_end_datum(component))
    );

function fixture_segmentation_plan_fixture_name(plan) = plan[FS_FIXTURE_NAME];
function fixture_segmentation_plan_source_path_name(plan) =
    plan[FS_SOURCE_PATH_NAME];
function fixture_segmentation_plan_strategy(plan) = plan[FS_STRATEGY];
function fixture_segmentation_plan_components(plan) = plan[FS_COMPONENTS];
function fixture_segmentation_plan_split_stations_mm(plan) =
    plan[FS_SPLIT_STATIONS_MM];
function fixture_segmentation_plan_max_base_width_mm(plan) =
    plan[FS_MAX_BASE_WIDTH_MM];
function fixture_segmentation_plan_max_base_depth_mm(plan) =
    plan[FS_MAX_BASE_DEPTH_MM];
function fixture_segmentation_plan_status(plan) = plan[FS_STATUS];
function fixture_segmentation_plan_notes(plan) = plan[FS_NOTES];
function fixture_segmentation_plan_component_count(plan) =
    len(fixture_segmentation_plan_components(plan));
