//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_indices.scad
// Project: Strap Bender
// FileGroup: Fixture Segmentation Data Model
// FileSummary: Named indexes for long-form fixture component records.
//////////////////////////////////////////////////////////////////////

// Assembly/setup datum at a component boundary.
FD_RECORD_TYPE = 0;
FD_SCHEMA_VERSION = 1;
FD_STATION_MM = 2;
FD_POINT = 3;
FD_HEADING_DEGREES = 4;
FD_ROLE = 5;
FD_SOURCE_INDEX = 6;
FD_LABEL = 7;

// One printable sequential fixture component.
FC_RECORD_TYPE = 0;
FC_SCHEMA_VERSION = 1;
FC_COMPONENT_ID = 2;
FC_COMPONENT_INDEX = 3;
FC_STATION_START_MM = 4;
FC_STATION_END_MM = 5;
FC_START_DATUM = 6;
FC_END_DATUM = 7;
FC_BEND_STATIONS = 8;
FC_BASE_BOUNDS = 9;
FC_NOTES = 10;

// Derived segmentation plan.
FS_RECORD_TYPE = 0;
FS_SCHEMA_VERSION = 1;
FS_FIXTURE_NAME = 2;
FS_SOURCE_PATH_NAME = 3;
FS_STRATEGY = 4;
FS_COMPONENTS = 5;
FS_SPLIT_STATIONS_MM = 6;
FS_MAX_BASE_WIDTH_MM = 7;
FS_MAX_BASE_DEPTH_MM = 8;
FS_STATUS = 9;
FS_NOTES = 10;
