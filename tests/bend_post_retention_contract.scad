//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_retention_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies open-top arc-follower retention geometry and policies.
//////////////////////////////////////////////////////////////////////
include <../strap_bender.scad>
include <../registries/laboratory_vertex_polygons.scad>
include <../registries/laboratory_strap_materials.scad>

polygon = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "ROUNDED_SQUARE_EXAMPLE",
    "vertex polygon"
);
compilation = compile_vertex_polygon(polygon);
path = compile_bend_program(
    polygon_compilation_normalized_shape(compilation)
);
fixture = bend_post_fixture_spec(
    name = "ARC_FOLLOWER_RETENTION_TEST",
    strap_material_name = "ULINE_S_1655_BLACK",
    radius_mode = "nominal_target",
    base_thickness_mm = 3,
    base_margin_mm = 8,
    post_height_mm = 18,
    strap_clearance_mm = 0.25,
    minimum_post_gap_mm = 1,
    max_base_width_mm = 220,
    max_base_depth_mm = 220,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    retention_mode = "arc_follower",
    follower_wall_thickness_mm = 2,
    notes = "Synthetic retention geometry contract."
);
plan = plan_bend_post_fixture(
    path,
    fixture,
    LABORATORY_STRAP_MATERIALS
);
validate_bend_post_fixture_plan(
    plan,
    fixture,
    path,
    LABORATORY_STRAP_MATERIALS
);

thickness = bend_post_fixture_plan_nominal_strap_thickness_mm(plan);
stations = bend_post_fixture_plan_stations(plan);
first = stations[0];
tolerance = 0.000001;
assert(sb_bend_post_retention_enabled(fixture),
    "Arc-follower retention mode must be active.");
assert(abs(thickness - 0.508) <= tolerance,
    "Fixture plan did not preserve nominal strap thickness.");
assert(abs(sb_bend_post_follower_slot_width_mm(fixture, thickness) -
        0.758) <= tolerance,
    "Arc-follower nominal slot width failed.");
assert(abs(sb_bend_post_follower_inner_radius_mm(
        first, fixture, thickness
    ) - 10.758) <= tolerance,
    "Arc-follower inner radius failed.");
assert(abs(sb_bend_post_follower_outer_radius_mm(
        first, fixture, thickness
    ) - 12.758) <= tolerance,
    "Arc-follower outer radius failed.");
assert(abs(sb_bend_post_follower_outer_extension_mm(
        fixture, thickness
    ) - 2.758) <= tolerance,
    "Arc-follower radial extension failed.");
assert(sb_bounds_near(
    bend_post_fixture_plan_base_bounds(plan),
    [-10.758, -10.758, 110.758, 110.758],
    tolerance
), "Arc followers were not included in exact base bounds.");
assert(len(sb_bend_post_follower_polygon_points(
        first, fixture, thickness
    )) == 2 * (
        sb_bend_post_follower_segment_count(first, fixture, thickness) + 1
    ),
    "Arc-follower polygon point count failed.");
assert(sb_bend_post_follower_actual_surface_sagitta_mm(
        first, fixture, thickness
    ) <= bend_post_fixture_tool_surface_chord_error_mm(fixture) + 1e-9,
    "Arc-follower tessellation exceeded configured chord error.");

clearance = analyze_bend_post_fixture_clearance(
    plan,
    fixture,
    path,
    LABORATORY_STRAP_MATERIALS
);
assert(fixture_clearance_report_issue_count(clearance) == 0,
    "Rounded-square arc-follower fixture must pass clearance analysis.");
assert(abs(fixture_clearance_report_required_nonlocal_path_gap_mm(
        clearance
    ) - 3.516) <= tolerance,
    "Arc-follower nonlocal path envelope failed.");
assert(abs(fixture_clearance_report_required_post_gap_mm(clearance) -
        6.516) <= tolerance,
    "Arc-follower post-pair envelope failed.");
validate_bend_post_fixture_clearance(
    clearance,
    plan,
    fixture,
    path,
    LABORATORY_STRAP_MATERIALS
);

concave = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "CONCAVE_L_EXAMPLE",
    "vertex polygon"
);
concave_path = compile_bend_program(
    polygon_compilation_normalized_shape(compile_vertex_polygon(concave))
);
concave_plan = plan_bend_post_fixture(
    concave_path,
    fixture,
    LABORATORY_STRAP_MATERIALS
);
negative_stations = [
    for (station = bend_post_fixture_plan_stations(concave_plan))
        if (bend_post_station_angle_degrees(station) < 0) station
];
assert(len(negative_stations) == 1,
    "Concave L source must expose one right-turn follower station.");
assert(len(sb_bend_post_follower_polygon_points(
        negative_stations[0], fixture, thickness
    )) >= 4,
    "Right-turn arc follower must produce a valid polygon.");

report_bend_post_fixture(fixture, "summary");
report_bend_post_fixture_plan(plan, fixture, "summary");
report_bend_post_fixture_clearance(clearance, "summary");
render_bend_post_fixture(plan, fixture);
echo("STRAP BENDER BEND-POST RETENTION CONTRACT: PASS");
