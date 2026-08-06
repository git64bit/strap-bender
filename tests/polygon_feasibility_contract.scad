//////////////////////////////////////////////////////////////////////
// LibFile: polygon_feasibility_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies detection of overlapping tangent setbacks.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

feasible_polygon = vertex_polygon_spec(
    "FEASIBLE_RADIUS_TEST",
    [[0, 0], [20, 0], [20, 20], [0, 20]],
    5
);

infeasible_polygon = vertex_polygon_spec(
    "INFEASIBLE_RADIUS_TEST",
    [[0, 0], [20, 0], [20, 20], [0, 20]],
    11
);

assert(sb_vertex_polygon_radius_feasible(feasible_polygon),
    "Feasible polygon radii were rejected.");
assert(!sb_vertex_polygon_radius_feasible(infeasible_polygon),
    "Overlapping polygon tangent setbacks must be detected.");

validate_vertex_polygon(feasible_polygon);
echo("STRAP BENDER POLYGON FEASIBILITY CONTRACT: PASS");
