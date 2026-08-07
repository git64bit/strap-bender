//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_schema.scad
// Project: Strap Bender
// FileGroup: Manufacturing Data Model
// FileSummary: Constructors for Catalog-ready recipes and export manifests.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_CATALOG_OBJECT_RECORD = "strap_bender_catalog_object";
STRAP_BENDER_MANUFACTURING_EXPORT_RECORD =
    "strap_bender_manufacturing_export";
STRAP_BENDER_MANUFACTURING_MANIFEST_RECORD =
    "strap_bender_manufacturing_manifest";

function catalog_object_spec(
    name,
    revision,
    lifecycle_status,
    source_authoring_kind,
    source_authoring_name,
    required_api_version,
    normalized_shape,
    strap_material,
    cut_spec,
    fixture_spec,
    fixture_layout_mode,
    fixture_setup_aid,
    source_commit = "",
    accepted_date = "",
    acceptance_notes = "",
    slicer_project_file = "",
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_CATALOG_OBJECT_RECORD,
    schema_version,
    name,
    revision,
    lifecycle_status,
    source_authoring_kind,
    source_authoring_name,
    required_api_version,
    normalized_shape,
    strap_material,
    cut_spec,
    fixture_spec,
    fixture_layout_mode,
    fixture_setup_aid,
    source_commit,
    accepted_date,
    acceptance_notes,
    slicer_project_file,
    notes
];

function manufacturing_export_spec(
    kind,
    component_index,
    component_id,
    recipe_filename,
    stl_filename,
    station_start_mm,
    station_end_mm,
    base_bounds,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_MANUFACTURING_EXPORT_RECORD,
    schema_version,
    kind,
    component_index,
    component_id,
    recipe_filename,
    stl_filename,
    station_start_mm,
    station_end_mm,
    base_bounds
];

function manufacturing_manifest_spec(
    catalog_object,
    cut_plan,
    fixture_plan,
    use_segmentation,
    segmentation_plan,
    export_entries,
    object_recipe_filename,
    manifest_filename,
    status,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_MANUFACTURING_MANIFEST_RECORD,
    schema_version,
    catalog_object,
    cut_plan,
    fixture_plan,
    use_segmentation,
    segmentation_plan,
    export_entries,
    object_recipe_filename,
    manifest_filename,
    status,
    notes
];
