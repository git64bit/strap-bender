//////////////////////////////////////////////////////////////////////
// LibFile: path_diagnostics_reporting.scad
// Project: Strap Bender
// FileGroup: Analytical Path Diagnostics Reporting
// FileSummary: Reports exact nonlocal line/arc intersections and near passes.
//////////////////////////////////////////////////////////////////////

module report_path_diagnostic_report(report, level = "summary") {
    echo("--- Strap Bender analytical path diagnostics ---");
    echo(str("Path: ", path_diagnostic_path_name(report)));
    echo(str("Near threshold: ",
        path_diagnostic_near_threshold_mm(report), " mm"));
    echo(str("Nonlocal primitive pairs checked: ",
        path_diagnostic_checked_pair_count(report)));
    echo(str("Bounds candidates requiring exact distance: ",
        path_diagnostic_bounds_candidate_count(report)));
    echo(str("Intersections: ", path_diagnostic_intersection_count(report),
        "; near passes: ", path_diagnostic_near_count(report)));
    if (level == "full")
        for (pair = path_diagnostic_interactions(report))
            echo(str(
                "  primitives ", path_pair_first_primitive_index(pair),
                " / ", path_pair_second_primitive_index(pair),
                " [source ", path_pair_first_source_index(pair),
                " / ", path_pair_second_source_index(pair), "] ",
                path_pair_first_kind(pair), "/",
                path_pair_second_kind(pair), " ",
                path_pair_classification(pair), " at ",
                path_pair_minimum_distance_mm(pair), " mm; labels [",
                path_pair_first_label(pair), "] / [",
                path_pair_second_label(pair), "]"
            ));
    if (level == "full")
        echo(str("Notes: ", path_diagnostic_notes(report)));
}
