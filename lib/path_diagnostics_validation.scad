//////////////////////////////////////////////////////////////////////
// LibFile: path_diagnostics_validation.scad
// Project: Strap Bender
// FileGroup: Analytical Path Diagnostics Validation
// FileSummary: Validates exact nonlocal primitive-pair diagnostic reports.
//////////////////////////////////////////////////////////////////////

function sb_path_pair_classification_valid(value) =
    value == "intersection" || value == "near";

module validate_path_pair_diagnostic(pair, primitive_count, threshold_mm) {
    assert(is_list(pair) && len(pair) == 12,
        "Path pair diagnostic records must contain twelve fields.");
    assert(pair[PDI_RECORD_TYPE] == STRAP_BENDER_PATH_PAIR_DIAGNOSTIC_RECORD,
        "Invalid path pair diagnostic record type.");
    assert(sb_schema_version_valid(pair[PDI_SCHEMA_VERSION]),
        "Unsupported path pair diagnostic schema version.");
    assert(sb_nonnegative_integer(path_pair_first_primitive_index(pair)) &&
        path_pair_first_primitive_index(pair) < primitive_count,
        "First diagnostic primitive index is out of range.");
    assert(sb_nonnegative_integer(path_pair_second_primitive_index(pair)) &&
        path_pair_second_primitive_index(pair) < primitive_count,
        "Second diagnostic primitive index is out of range.");
    assert(path_pair_first_primitive_index(pair) <
        path_pair_second_primitive_index(pair),
        "Diagnostic primitive indexes must be ordered and distinct.");
    assert(sb_nonnegative_integer(path_pair_first_source_index(pair)) &&
        sb_nonnegative_integer(path_pair_second_source_index(pair)),
        "Diagnostic source-command indexes must be nonnegative integers.");
    assert(is_string(path_pair_first_label(pair)) &&
        is_string(path_pair_second_label(pair)),
        "Diagnostic primitive labels must be strings.");
    assert((path_pair_first_kind(pair) == "line" ||
            path_pair_first_kind(pair) == "arc") &&
        (path_pair_second_kind(pair) == "line" ||
            path_pair_second_kind(pair) == "arc"),
        "Diagnostic primitive kinds must be line or arc.");
    assert(sb_finite_number(path_pair_minimum_distance_mm(pair)) &&
        path_pair_minimum_distance_mm(pair) >= 0,
        "Diagnostic minimum distance must be nonnegative and finite.");
    assert(path_pair_minimum_distance_mm(pair) <= threshold_mm +
        SB_NUMERIC_POSITION_TOLERANCE_MM,
        "Stored interaction exceeds the configured near threshold.");
    assert(sb_path_pair_classification_valid(path_pair_classification(pair)),
        "Unsupported path-pair diagnostic classification.");
}

module validate_path_diagnostic_report(report, path) {
    assert(is_list(report) && len(report) == 8,
        "Path diagnostic report records must contain eight fields.");
    assert(report[PDR_RECORD_TYPE] ==
        STRAP_BENDER_PATH_DIAGNOSTIC_REPORT_RECORD,
        "Invalid path diagnostic report record type.");
    assert(sb_schema_version_valid(report[PDR_SCHEMA_VERSION]),
        "Unsupported path diagnostic report schema version.");
    assert(path_diagnostic_path_name(report) == analytical_path_name(path),
        "Path diagnostic source name must match the analytical path.");
    assert(sb_finite_number(path_diagnostic_near_threshold_mm(report)) &&
        path_diagnostic_near_threshold_mm(report) >= 0,
        "Path diagnostic near threshold must be nonnegative and finite.");
    assert(sb_nonnegative_integer(path_diagnostic_checked_pair_count(report)),
        "Path diagnostic checked-pair count must be nonnegative.");
    assert(sb_nonnegative_integer(
            path_diagnostic_bounds_candidate_count(report)) &&
        path_diagnostic_bounds_candidate_count(report) <=
            path_diagnostic_checked_pair_count(report),
        "Path diagnostic bounds-candidate count is invalid.");
    assert(is_list(path_diagnostic_interactions(report)),
        "Path diagnostic interactions must be a list.");
    assert(is_string(path_diagnostic_notes(report)),
        "Path diagnostic notes must be a string.");
    for (pair = path_diagnostic_interactions(report))
        validate_path_pair_diagnostic(
            pair,
            len(analytical_path_primitives(path)),
            path_diagnostic_near_threshold_mm(report)
        );
}
