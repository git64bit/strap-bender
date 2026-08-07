//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_accessors.scad
// Project: Strap Bender
// FileGroup: Manufacturing Data Model
// FileSummary: Named accessors for Catalog-ready recipes and export manifests.
//////////////////////////////////////////////////////////////////////

function catalog_object_name(object) = object[CO_NAME];
function catalog_object_revision(object) = object[CO_REVISION];
function catalog_object_lifecycle_status(object) = object[CO_LIFECYCLE_STATUS];
function catalog_object_source_authoring_kind(object) =
    object[CO_SOURCE_AUTHORING_KIND];
function catalog_object_source_authoring_name(object) =
    object[CO_SOURCE_AUTHORING_NAME];
function catalog_object_required_api_version(object) =
    object[CO_REQUIRED_API_VERSION];
function catalog_object_normalized_shape(object) = object[CO_NORMALIZED_SHAPE];
function catalog_object_strap_material(object) = object[CO_STRAP_MATERIAL];
function catalog_object_cut_spec(object) = object[CO_CUT_SPEC];
function catalog_object_fixture_spec(object) = object[CO_FIXTURE_SPEC];
function catalog_object_fixture_layout_mode(object) =
    object[CO_FIXTURE_LAYOUT_MODE];
function catalog_object_fixture_setup_aid(object) =
    object[CO_FIXTURE_SETUP_AID];
function catalog_object_source_commit(object) = object[CO_SOURCE_COMMIT];
function catalog_object_accepted_date(object) = object[CO_ACCEPTED_DATE];
function catalog_object_acceptance_notes(object) = object[CO_ACCEPTANCE_NOTES];
function catalog_object_slicer_project_file(object) =
    object[CO_SLICER_PROJECT_FILE];
function catalog_object_notes(object) = object[CO_NOTES];

function manufacturing_export_kind(entry) = entry[ME_KIND];
function manufacturing_export_component_index(entry) = entry[ME_COMPONENT_INDEX];
function manufacturing_export_component_id(entry) = entry[ME_COMPONENT_ID];
function manufacturing_export_recipe_filename(entry) = entry[ME_RECIPE_FILENAME];
function manufacturing_export_stl_filename(entry) = entry[ME_STL_FILENAME];
function manufacturing_export_station_start_mm(entry) = entry[ME_STATION_START_MM];
function manufacturing_export_station_end_mm(entry) = entry[ME_STATION_END_MM];
function manufacturing_export_base_bounds(entry) = entry[ME_BASE_BOUNDS];
function manufacturing_export_base_width_mm(entry) =
    sb_bounds_width(manufacturing_export_base_bounds(entry));
function manufacturing_export_base_depth_mm(entry) =
    sb_bounds_height(manufacturing_export_base_bounds(entry));

function manufacturing_manifest_catalog_object(manifest) =
    manifest[MM_CATALOG_OBJECT];
function manufacturing_manifest_cut_plan(manifest) = manifest[MM_CUT_PLAN];
function manufacturing_manifest_fixture_plan(manifest) = manifest[MM_FIXTURE_PLAN];
function manufacturing_manifest_use_segmentation(manifest) =
    manifest[MM_USE_SEGMENTATION];
function manufacturing_manifest_segmentation_plan(manifest) =
    manifest[MM_SEGMENTATION_PLAN];
function manufacturing_manifest_export_entries(manifest) =
    manifest[MM_EXPORT_ENTRIES];
function manufacturing_manifest_object_recipe_filename(manifest) =
    manifest[MM_OBJECT_RECIPE_FILENAME];
function manufacturing_manifest_filename(manifest) = manifest[MM_MANIFEST_FILENAME];
function manufacturing_manifest_status(manifest) = manifest[MM_STATUS];
function manufacturing_manifest_notes(manifest) = manifest[MM_NOTES];
function manufacturing_manifest_export_count(manifest) =
    len(manufacturing_manifest_export_entries(manifest));
