//////////////////////////////////////////////////////////////////////
// LibFile: polygon_self_intersection_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies nonadjacent sharp-source polygon intersections.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

square_vertices = [
    [0, 0],
    [100, 0],
    [100, 100],
    [0, 100]
];

concave_vertices = [
    [0, 0],
    [100, 0],
    [100, 40],
    [40, 40],
    [40, 100],
    [0, 100]
];

crossing_vertices = [
    [0, 0],
    [100, 0],
    [20, 80],
    [80, 80]
];

assert(!sb_polygon_has_self_intersections(square_vertices),
    "A simple square must not report self-intersections.");
assert(len(sb_polygon_self_intersection_pairs(square_vertices)) == 0,
    "Adjacent square edges must not be reported at shared endpoints.");
assert(!sb_polygon_has_self_intersections(concave_vertices),
    "A simple concave polygon must remain valid for this diagnostic.");
assert(sb_polygon_has_self_intersections(crossing_vertices),
    "The crossing source polygon must report a self-intersection.");
assert(sb_polygon_self_intersection_pairs(crossing_vertices) == [[1, 3]],
    "The crossing source polygon must identify source edges 1 and 3.");

crossing_polygon = vertex_polygon_spec(
    "TEST_CROSSING_POLYGON",
    crossing_vertices,
    1.6,
    0,
    "Synthetic diagnostic-only crossing polygon."
);

// Batch 014 detects but deliberately does not reject this source record.
// The project-wide crossing-fixture policy remains an open design decision.
validate_vertex_polygon(crossing_polygon);
report_vertex_polygon(crossing_polygon, "full");

echo("STRAP BENDER POLYGON SELF-INTERSECTION CONTRACT: PASS");
