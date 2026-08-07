//////////////////////////////////////////////////////////////////////
// LibFile: path_diagnostics_indices.scad
// Project: Strap Bender
// FileGroup: Analytical Path Diagnostics Data Model
// FileSummary: Named indexes for exact nonlocal analytical-path diagnostics.
//////////////////////////////////////////////////////////////////////

// One nonlocal primitive-pair diagnostic.
PDI_RECORD_TYPE = 0;
PDI_SCHEMA_VERSION = 1;
PDI_FIRST_PRIMITIVE_INDEX = 2;
PDI_SECOND_PRIMITIVE_INDEX = 3;
PDI_FIRST_SOURCE_INDEX = 4;
PDI_SECOND_SOURCE_INDEX = 5;
PDI_FIRST_LABEL = 6;
PDI_SECOND_LABEL = 7;
PDI_FIRST_KIND = 8;
PDI_SECOND_KIND = 9;
PDI_MINIMUM_DISTANCE_MM = 10;
PDI_CLASSIFICATION = 11;

// One complete path-level diagnostic report.
PDR_RECORD_TYPE = 0;
PDR_SCHEMA_VERSION = 1;
PDR_PATH_NAME = 2;
PDR_NEAR_THRESHOLD_MM = 3;
PDR_CHECKED_PAIR_COUNT = 4;
PDR_BOUNDS_CANDIDATE_COUNT = 5;
PDR_INTERACTIONS = 6;
PDR_NOTES = 7;
