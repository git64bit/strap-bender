//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_fixture_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies the first full-form bend-post fixture plan and solid.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_vertex_polygons.scad>
include <../registries/laboratory_strap_materials.scad>

polygon = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "ROUNDED_SQUARE_EXAMPLE",
    "vertex polygon"
);
validate_vertex_polygon(polygon);
polygon_compilation = compile_vertex_polygon(polygon);
validate_polygon_compilation(polygon_compilation, polygon);
shape = polygon_compilation_normalized_shape(polygon_compilation);
validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);

fixture = bend_post_fixture_spec(
    name = "ROUNDED_SQUARE_POST_FIXTURE_TEST",
    strap_material_name = "ULINE_S_1655_BLACK",
    radius_mode = "nominal_target",
    base_thickness_mm = 3,
    base_margin_mm = 8,
    post_height_mm = 18,
    max_base_width_mm = 220,
    max_base_depth_mm = 220,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    retention_mode = "none",
    notes = "Synthetic CAD contract; no PET compensation claim."
);
validate_bend_post_fixture(fixture, LABORATORY_STRAP_MATERIALS);
plan = plan_bend_post_fixture(path, fixture);
validate_bend_post_fixture_plan(
    plan,
    fixture,
    path,
    LABORATORY_STRAP_MATERIALS
);

stations = bend_post_fixture_plan_stations(plan);
tolerance = 0.000001;
assert(len(stations) == 4,
    "Rounded-square fixture must create one post per bend.");
assert(sb_bounds_near(
    bend_post_fixture_plan_base_bounds(plan),
    [-8, -8, 108, 108],
    tolerance
), "Rounded-square fixture base bounds failed.");
assert(abs(bend_post_fixture_plan_base_width_mm(plan) - 116) <= tolerance &&
    abs(bend_post_fixture_plan_base_depth_mm(plan) - 116) <= tolerance,
    "Rounded-square fixture base size failed.");
assert(len([
    for (station = stations)
        if (abs(bend_post_station_target_inside_radius_mm(station) - 10) <=
                tolerance &&
            abs(bend_post_station_tool_inside_radius_mm(station) - 10) <=
                tolerance)
            station
]) == 4,
    "Nominal fixture mode must preserve all four R10 targets.");
assert(len([
    for (station = stations)
        if (bend_post_station_actual_surface_sagitta_mm(station, fixture) <=
            bend_post_fixture_tool_surface_chord_error_mm(fixture) + 1e-9)
            station
]) == 4,
    "Every post surface must satisfy the configured chord-error bound.");
assert(bend_post_fixture_plan_status(plan) ==
    "experimental_uncompensated",
    "Nominal fixture plan must be explicitly experimental.");

report_bend_post_fixture(fixture, "summary");
report_bend_post_fixture_plan(plan, fixture, "full");
render_bend_post_fixture(plan, fixture);

echo("STRAP BENDER BEND-POST FIXTURE CONTRACT: PASS");
