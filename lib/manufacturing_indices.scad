//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_indices.scad
// Project: Strap Bender
// FileGroup: Manufacturing Data Model
// FileSummary: Named indexes for Catalog-ready recipes and export manifests.
//////////////////////////////////////////////////////////////////////

// Immutable-shape recipe payload used for Laboratory candidates and future Catalog objects.
CO_RECORD_TYPE = 0;
CO_SCHEMA_VERSION = 1;
CO_NAME = 2;
CO_REVISION = 3;
CO_LIFECYCLE_STATUS = 4;
CO_SOURCE_AUTHORING_KIND = 5;
CO_SOURCE_AUTHORING_NAME = 6;
CO_REQUIRED_API_VERSION = 7;
CO_NORMALIZED_SHAPE = 8;
CO_STRAP_MATERIAL = 9;
CO_CUT_SPEC = 10;
CO_FIXTURE_SPEC = 11;
CO_FIXTURE_LAYOUT_MODE = 12;
CO_FIXTURE_SETUP_AID = 13;
CO_SOURCE_COMMIT = 14;
CO_ACCEPTED_DATE = 15;
CO_ACCEPTANCE_NOTES = 16;
CO_SLICER_PROJECT_FILE = 17;
CO_NOTES = 18;

// One deterministic printable-component export instruction.
ME_RECORD_TYPE = 0;
ME_SCHEMA_VERSION = 1;
ME_KIND = 2;
ME_COMPONENT_INDEX = 3;
ME_COMPONENT_ID = 4;
ME_RECIPE_FILENAME = 5;
ME_STL_FILENAME = 6;
ME_STATION_START_MM = 7;
ME_STATION_END_MM = 8;
ME_BASE_BOUNDS = 9;

// Derived manufacturing/export manifest.
MM_RECORD_TYPE = 0;
MM_SCHEMA_VERSION = 1;
MM_CATALOG_OBJECT = 2;
MM_CUT_PLAN = 3;
MM_FIXTURE_PLAN = 4;
MM_USE_SEGMENTATION = 5;
MM_SEGMENTATION_PLAN = 6;
MM_EXPORT_ENTRIES = 7;
MM_OBJECT_RECIPE_FILENAME = 8;
MM_MANIFEST_FILENAME = 9;
MM_STATUS = 10;
MM_NOTES = 11;
