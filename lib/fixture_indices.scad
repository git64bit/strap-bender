//////////////////////////////////////////////////////////////////////
// LibFile: fixture_indices.scad
// Project: Strap Bender
// FileGroup: Fixture Data Model
// FileSummary: Named indexes for bend-post fixture and clearance records.
//////////////////////////////////////////////////////////////////////
// Bend-post fixture source specification
BF_RECORD_TYPE = 0;
BF_SCHEMA_VERSION = 1;
BF_NAME = 2;
BF_STRAP_MATERIAL_NAME = 3;
BF_RADIUS_MODE = 4;
BF_BASE_THICKNESS_MM = 5;
BF_BASE_MARGIN_MM = 6;
BF_POST_HEIGHT_MM = 7;
BF_STRAP_CLEARANCE_MM = 8;
BF_MINIMUM_POST_GAP_MM = 9;
BF_MAX_BASE_WIDTH_MM = 10;
BF_MAX_BASE_DEPTH_MM = 11;
BF_TOOL_SURFACE_CHORD_ERROR_MM = 12;
BF_TOOL_SURFACE_MAX_ANGLE_STEP_DEGREES = 13;
BF_RETENTION_MODE = 14;
BF_NOTES = 15;
// Derived bend-post station. Target and tool datums are separate so a later
// compensated planner can move tool geometry without rewriting target intent.
BS_RECORD_TYPE = 0;
BS_SCHEMA_VERSION = 1;
BS_SOURCE_INDEX = 2;
BS_LABEL = 3;
BS_STATION_START = 4;
BS_STATION_END = 5;
BS_TARGET_CENTER = 6;
BS_TOOL_CENTER = 7;
BS_ANGLE_DEGREES = 8;
BS_TARGET_INSIDE_RADIUS_MM = 9;
BS_TOOL_INSIDE_RADIUS_MM = 10;
BS_TARGET_ENTRY_POINT = 11;
BS_TARGET_EXIT_POINT = 12;
BS_TOOL_ENTRY_POINT = 13;
BS_TOOL_EXIT_POINT = 14;
// Derived bend-post fixture plan
BP_RECORD_TYPE = 0;
BP_SCHEMA_VERSION = 1;
BP_FIXTURE_NAME = 2;
BP_SOURCE_PATH_NAME = 3;
BP_REFERENCE_AXIS = 4;
BP_STATUS = 5;
BP_STATIONS = 6;
BP_BASE_BOUNDS = 7;
BP_NOTES = 8;
// Derived clearance issue
CI_RECORD_TYPE = 0;
CI_SCHEMA_VERSION = 1;
CI_KIND = 2;
CI_PRIMARY_SOURCE_INDEX = 3;
CI_SECONDARY_SOURCE_INDEX = 4;
CI_MEASURED_GAP_MM = 5;
CI_REQUIRED_GAP_MM = 6;
CI_LABEL = 7;
// Derived clearance report
CR_RECORD_TYPE = 0;
CR_SCHEMA_VERSION = 1;
CR_FIXTURE_NAME = 2;
CR_SOURCE_PATH_NAME = 3;
CR_NOMINAL_STRAP_THICKNESS_MM = 4;
CR_REQUIRED_NONLOCAL_PATH_GAP_MM = 5;
CR_REQUIRED_POST_GAP_MM = 6;
CR_POST_PAIR_ISSUES = 7;
CR_POST_PATH_ISSUES = 8;
CR_MINIMUM_POST_PAIR_GAP_MM = 9;
CR_MINIMUM_POST_PATH_GAP_MM = 10;
CR_NOTES = 11;
