//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_schema.scad
// Project: Strap Bender
// FileGroup: Fixture Segmentation Data Model
// FileSummary: Constructors for long-form fixture components and datums.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_FIXTURE_ASSEMBLY_DATUM_RECORD =
    "strap_bender_fixture_assembly_datum";
STRAP_BENDER_FIXTURE_COMPONENT_RECORD =
    "strap_bender_fixture_component";
STRAP_BENDER_FIXTURE_SEGMENTATION_PLAN_RECORD =
    "strap_bender_fixture_segmentation_plan";

function fixture_assembly_datum_spec(
    station_mm,
    point,
    heading_degrees,
    role,
    source_index,
    label = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_FIXTURE_ASSEMBLY_DATUM_RECORD,
    schema_version,
    station_mm,
    point,
    heading_degrees,
    role,
    source_index,
    label
];

function fixture_component_spec(
    component_id,
    component_index,
    station_start_mm,
    station_end_mm,
    start_datum,
    end_datum,
    bend_stations,
    base_bounds,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_FIXTURE_COMPONENT_RECORD,
    schema_version,
    component_id,
    component_index,
    station_start_mm,
    station_end_mm,
    start_datum,
    end_datum,
    bend_stations,
    base_bounds,
    notes
];

function fixture_segmentation_plan_spec(
    fixture_name,
    source_path_name,
    strategy,
    components,
    split_stations_mm,
    max_base_width_mm,
    max_base_depth_mm,
    status,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_FIXTURE_SEGMENTATION_PLAN_RECORD,
    schema_version,
    fixture_name,
    source_path_name,
    strategy,
    components,
    split_stations_mm,
    max_base_width_mm,
    max_base_depth_mm,
    status,
    notes
];
