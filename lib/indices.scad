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
