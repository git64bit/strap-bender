//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_clearance_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies fixture post/post and nonlocal-path clearance analysis.
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
shape = polygon_compilation_normalized_shape(compilation);
path = compile_bend_program(shape);
fixture = bend_post_fixture_spec(
    name = "CLEARANCE_SAFE_TEST",
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
    retention_mode = "none",
    follower_wall_thickness_mm = 2
);
plan = plan_bend_post_fixture(path, fixture, LABORATORY_STRAP_MATERIALS);
report = analyze_bend_post_fixture_clearance(
    plan, fixture, path, LABORATORY_STRAP_MATERIALS
);
assert(fixture_clearance_report_issue_count(report) == 0,
    "Rounded-square fixture should have no clearance issues.");
validate_bend_post_fixture_clearance(
    report, plan, fixture, path, LABORATORY_STRAP_MATERIALS
);
strict_fixture = bend_post_fixture_spec(
    name = "CLEARANCE_STRICT_TEST",
    strap_material_name = "ULINE_S_1655_BLACK",
    radius_mode = "nominal_target",
    base_thickness_mm = 3,
    base_margin_mm = 8,
    post_height_mm = 18,
    strap_clearance_mm = 0.25,
    minimum_post_gap_mm = 70,
    max_base_width_mm = 220,
    max_base_depth_mm = 220,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    retention_mode = "none",
    follower_wall_thickness_mm = 2
);
strict_plan = plan_bend_post_fixture(path, strict_fixture, LABORATORY_STRAP_MATERIALS);
strict_report = analyze_bend_post_fixture_clearance(
    strict_plan, strict_fixture, path, LABORATORY_STRAP_MATERIALS
);
assert(len(fixture_clearance_report_post_pair_issues(strict_report)) == 4,
    "R10 rounded square should expose four adjacent post-pair gaps below 70 mm.");
assert(abs(sb_fixture_point_to_segment_distance(
        [0, 0], [-5, 1.5], [5, 1.5]
    ) - 1.5) < 1e-9,
    "Point-to-segment clearance math failed.");
report_bend_post_fixture_clearance(report, "full");
echo("STRAP BENDER BEND-POST CLEARANCE CONTRACT: PASS");
