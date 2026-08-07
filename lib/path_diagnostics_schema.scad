//////////////////////////////////////////////////////////////////////
// LibFile: path_diagnostics_schema.scad
// Project: Strap Bender
// FileGroup: Analytical Path Diagnostics Data Model
// FileSummary: Constructors for nonlocal line/arc interaction diagnostics.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_PATH_PAIR_DIAGNOSTIC_RECORD =
    "strap_bender_path_pair_diagnostic";
STRAP_BENDER_PATH_DIAGNOSTIC_REPORT_RECORD =
    "strap_bender_path_diagnostic_report";

function path_pair_diagnostic_spec(
    first_primitive_index,
    second_primitive_index,
    first_source_index,
    second_source_index,
    first_label,
    second_label,
    first_kind,
    second_kind,
    minimum_distance_mm,
    classification,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATH_PAIR_DIAGNOSTIC_RECORD,
    schema_version,
    first_primitive_index,
    second_primitive_index,
    first_source_index,
    second_source_index,
    first_label,
    second_label,
    first_kind,
    second_kind,
    minimum_distance_mm,
    classification
];

function path_diagnostic_report_spec(
    path_name,
    near_threshold_mm,
    checked_pair_count,
    bounds_candidate_count,
    interactions,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATH_DIAGNOSTIC_REPORT_RECORD,
    schema_version,
    path_name,
    near_threshold_mm,
    checked_pair_count,
    bounds_candidate_count,
    interactions,
    notes
];
