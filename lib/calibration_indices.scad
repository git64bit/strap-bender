//////////////////////////////////////////////////////////////////////
// LibFile: calibration_indices.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Data Model
// FileSummary: Named indexes for individual radius-observation records.
//////////////////////////////////////////////////////////////////////

// One physical bend observation. Values are measured evidence, not a fitted model.
RO_RECORD_TYPE = 0;
RO_SCHEMA_VERSION = 1;
RO_NAME = 2;
RO_STRAP_MATERIAL_NAME = 3;
RO_SPECIMEN_ID = 4;
RO_MEASURED_WIDTH_MM = 5;
RO_MEASURED_THICKNESS_MM = 6;
RO_BEND_ANGLE_DEGREES = 7;
RO_TOOL_INSIDE_RADIUS_MM = 8;
RO_FORMING_METHOD = 9;
RO_FORMING_TEMPERATURE_C = 10;
RO_DWELL_SECONDS = 11;
RO_COOLING_RESTRAINT = 12;
RO_RELEASE_REST_SECONDS = 13;
RO_MEASURED_FINISHED_INSIDE_RADIUS_MM = 14;
RO_MEASUREMENT_METHOD = 15;
RO_MEASURED_DATE = 16;
RO_MEASUREMENT_UNCERTAINTY_MM = 17;
RO_NOTES = 18;
