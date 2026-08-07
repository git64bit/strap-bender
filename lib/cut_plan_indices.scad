//////////////////////////////////////////////////////////////////////
// LibFile: cut_plan_indices.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Data Model
// FileSummary: Named indexes for nominal developed-length and cutting records.
//////////////////////////////////////////////////////////////////////

// User/source cutting policy applied to one analytical path.
SC_RECORD_TYPE = 0;
SC_SCHEMA_VERSION = 1;
SC_NAME = 2;
SC_STRAP_MATERIAL_NAME = 3;
SC_DEVELOPMENT_MODE = 4;
SC_NEUTRAL_AXIS_FRACTION = 5;
SC_START_ALLOWANCE_MM = 6;
SC_END_ALLOWANCE_MM = 7;
SC_CLOSURE_MODE = 8;
SC_CLOSURE_OVERLAP_MM = 9;
SC_JOINING_ALLOWANCE_MM = 10;
SC_NOTES = 11;

// Derived nominal cutting plan.
CP_RECORD_TYPE = 0;
CP_SCHEMA_VERSION = 1;
CP_SOURCE_NAME = 2;
CP_PATH_NAME = 3;
CP_PATH_CLOSURE = 4;
CP_STRAP_MATERIAL_NAME = 5;
CP_NOMINAL_THICKNESS_MM = 6;
CP_NEUTRAL_AXIS_FRACTION = 7;
CP_INSIDE_REFERENCE_LENGTH_MM = 8;
CP_STRAIGHT_LENGTH_MM = 9;
CP_INSIDE_ARC_LENGTH_MM = 10;
CP_DEVELOPED_ARC_LENGTH_MM = 11;
CP_NOMINAL_DEVELOPED_LENGTH_MM = 12;
CP_ALLOWANCE_TOTAL_MM = 13;
CP_CUT_LENGTH_MM = 14;
CP_STATUS = 15;
CP_NOTES = 16;
