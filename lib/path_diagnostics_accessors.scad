//////////////////////////////////////////////////////////////////////
// LibFile: path_diagnostics_accessors.scad
// Project: Strap Bender
// FileGroup: Analytical Path Diagnostics Data Model
// FileSummary: Named accessors for nonlocal line/arc diagnostics.
//////////////////////////////////////////////////////////////////////

function path_pair_first_primitive_index(pair) =
    pair[PDI_FIRST_PRIMITIVE_INDEX];
function path_pair_second_primitive_index(pair) =
    pair[PDI_SECOND_PRIMITIVE_INDEX];
function path_pair_first_source_index(pair) = pair[PDI_FIRST_SOURCE_INDEX];
function path_pair_second_source_index(pair) = pair[PDI_SECOND_SOURCE_INDEX];
function path_pair_first_label(pair) = pair[PDI_FIRST_LABEL];
function path_pair_second_label(pair) = pair[PDI_SECOND_LABEL];
function path_pair_first_kind(pair) = pair[PDI_FIRST_KIND];
function path_pair_second_kind(pair) = pair[PDI_SECOND_KIND];
function path_pair_minimum_distance_mm(pair) = pair[PDI_MINIMUM_DISTANCE_MM];
function path_pair_classification(pair) = pair[PDI_CLASSIFICATION];

function path_diagnostic_path_name(report) = report[PDR_PATH_NAME];
function path_diagnostic_near_threshold_mm(report) =
    report[PDR_NEAR_THRESHOLD_MM];
function path_diagnostic_checked_pair_count(report) =
    report[PDR_CHECKED_PAIR_COUNT];
function path_diagnostic_bounds_candidate_count(report) =
    report[PDR_BOUNDS_CANDIDATE_COUNT];
function path_diagnostic_interactions(report) = report[PDR_INTERACTIONS];
function path_diagnostic_notes(report) = report[PDR_NOTES];
function path_diagnostic_intersection_count(report) = len([
    for (pair = path_diagnostic_interactions(report))
        if (path_pair_classification(pair) == "intersection") pair
]);
function path_diagnostic_near_count(report) = len([
    for (pair = path_diagnostic_interactions(report))
        if (path_pair_classification(pair) == "near") pair
]);
function path_diagnostic_has_intersections(report) =
    path_diagnostic_intersection_count(report) > 0;
