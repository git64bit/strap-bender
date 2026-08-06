//////////////////////////////////////////////////////////////////////
// LibFile: indices.scad
// Project: Strap Bender
// FileGroup: Data Model
// FileSummary: Named indexes for native Strap Bender record vectors.
//////////////////////////////////////////////////////////////////////

// Project specification
PR_RECORD_TYPE = 0;
PR_SCHEMA_VERSION = 1;
PR_NAME = 2;
PR_KIND = 3;
PR_STATUS = 4;
PR_NOTES = 5;

// Start pose specification
PO_RECORD_TYPE = 0;
PO_SCHEMA_VERSION = 1;
PO_X = 2;
PO_Y = 3;
PO_HEADING_DEGREES = 4;

// Bend-program command
CM_RECORD_TYPE = 0;
CM_SCHEMA_VERSION = 1;
CM_KIND = 2;
CM_SOURCE_INDEX = 3;
CM_DISTANCE = 4;
CM_ANGLE_DEGREES = 5;
CM_INSIDE_RADIUS = 6;
CM_LABEL = 7;

// Shape specification
SH_RECORD_TYPE = 0;
SH_SCHEMA_VERSION = 1;
SH_NAME = 2;
SH_CLOSURE = 3;
SH_START_POSE = 4;
SH_AUTHORING_KIND = 5;
SH_COMMANDS = 6;
SH_NOTES = 7;

// Derived analytical primitive
AP_RECORD_TYPE = 0;
AP_SCHEMA_VERSION = 1;
AP_KIND = 2;
AP_SOURCE_INDEX = 3;
AP_LABEL = 4;
AP_START_POSE = 5;
AP_END_POSE = 6;
AP_STATION_START = 7;
AP_STATION_END = 8;
AP_CENTER = 9;
AP_ANGLE_DEGREES = 10;
AP_INSIDE_RADIUS = 11;

// Derived analytical path
PA_RECORD_TYPE = 0;
PA_SCHEMA_VERSION = 1;
PA_NAME = 2;
PA_REFERENCE_AXIS = 3;
PA_CLOSURE = 4;
PA_START_POSE = 5;
PA_END_POSE = 6;
PA_PRIMITIVES = 7;
PA_BOUNDS = 8;
PA_NOTES = 9;

// Derived sampled display path
SP_RECORD_TYPE = 0;
SP_SCHEMA_VERSION = 1;
SP_NAME = 2;
SP_REFERENCE_AXIS = 3;
SP_CLOSURE = 4;
SP_POINTS = 5;
SP_CHORD_ERROR_MM = 6;
SP_MAX_ANGLE_STEP_DEGREES = 7;
SP_NOTES = 8;
