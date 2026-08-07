//////////////////////////////////////////////////////////////////////
// LibFile: analytical_path_diagnostics_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies exact nonlocal line/arc intersection and near-pass math.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

tolerance = 0.000001;

line_horizontal = analytical_line_primitive(
    0, "LH",
    start_pose_spec(0, 0, 0),
    start_pose_spec(10, 0, 0),
    0, 10
);
line_vertical = analytical_line_primitive(
    1, "LV",
    start_pose_spec(5, -5, 90),
    start_pose_spec(5, 5, 90),
    20, 30
);
line_near = analytical_line_primitive(
    2, "LN",
    start_pose_spec(0, 0.75, 0),
    start_pose_spec(10, 0.75, 0),
    40, 50
);
upper_arc = analytical_arc_primitive(
    3, "A0",
    start_pose_spec(5, 0, 90),
    start_pose_spec(-5, 0, 270),
    60, 60 + 5 * SB_PI,
    [0, 0], 180, 5
);
shifted_upper_arc = analytical_arc_primitive(
    4, "A1",
    start_pose_spec(11, 0, 90),
    start_pose_spec(1, 0, 270),
    80, 80 + 5 * SB_PI,
    [6, 0], 180, 5
);
tangent_line = analytical_line_primitive(
    5, "LT",
    start_pose_spec(-2, 5, 0),
    start_pose_spec(2, 5, 0),
    100, 104
);
near_arc_line = analytical_line_primitive(
    6, "LNA",
    start_pose_spec(-2, 6, 0),
    start_pose_spec(2, 6, 0),
    110, 114
);

assert(sb_analytical_primitive_pair_distance(
        line_horizontal, line_vertical) <= tolerance,
    "Exact line/line crossing detection failed.");
assert(abs(sb_analytical_primitive_pair_distance(
        line_horizontal, line_near) - 0.75) <= tolerance,
    "Exact line/line near-distance calculation failed.");
assert(sb_analytical_primitive_pair_distance(
        tangent_line, upper_arc) <= tolerance,
    "Exact line/arc tangent intersection detection failed.");
assert(abs(sb_analytical_primitive_pair_distance(
        near_arc_line, upper_arc) - 1) <= tolerance,
    "Exact line/arc near-distance calculation failed.");
assert(sb_analytical_primitive_pair_distance(
        upper_arc, shifted_upper_arc) <= tolerance,
    "Exact arc/arc intersection detection failed.");

path = analytical_path_spec(
    "DIAGNOSTIC_PAIR_TEST",
    "finished_inside_edge",
    "open",
    start_pose_spec(0, 0, 0),
    start_pose_spec(5, 5, 90),
    [
        line_horizontal,
        analytical_line_primitive(
            7, "SEPARATOR",
            start_pose_spec(20, 20, 0),
            start_pose_spec(30, 20, 0),
            120, 130
        ),
        line_vertical
    ],
    [0, -5, 30, 20],
    "Synthetic pair-selection test; continuity is not under test here."
);
report = analyze_analytical_path_interactions(path, 1);
validate_path_diagnostic_report(report, path);
assert(path_diagnostic_checked_pair_count(report) == 1,
    "Open three-primitive path must check only the nonadjacent 0/2 pair.");
assert(path_diagnostic_bounds_candidate_count(report) == 1,
    "Crossing pair must survive the bounding-box prefilter.");
assert(path_diagnostic_intersection_count(report) == 1 &&
    path_diagnostic_near_count(report) == 0,
    "Crossing pair must classify as an intersection.");
assert(path_pair_first_primitive_index(
        path_diagnostic_interactions(report)[0]) == 0 &&
    path_pair_second_primitive_index(
        path_diagnostic_interactions(report)[0]) == 2,
    "Diagnostic primitive provenance failed.");

closed_three = analytical_path_spec(
    "CLOSED_ADJACENCY_TEST",
    "finished_inside_edge",
    "closed",
    start_pose_spec(0, 0, 0),
    start_pose_spec(0, 0, 360),
    [line_horizontal, line_vertical, line_near],
    [0, -5, 10, 5],
    "Synthetic adjacency-only test; geometry continuity is not under test."
);
assert(len(sb_analytical_nonlocal_index_pairs(closed_three)) == 0,
    "A closed three-primitive path has no nonlocal pairs; first/last must be adjacency neighbors.");

report_path_diagnostic_report(report, "full");
echo("STRAP BENDER ANALYTICAL PATH DIAGNOSTICS CONTRACT: PASS");
