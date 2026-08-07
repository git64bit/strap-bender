//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies deterministic long-wave fixture segmentation.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../patterns/standard_patterns.scad>
include <../registries/laboratory_pattern_instances.scad>
include <../registries/laboratory_strap_materials.scad>

pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
instance = named_record(
    LABORATORY_PATTERN_INSTANCES,
    "THIRTY_WAVE_EVERY_THIRD_R5",
    "pattern instance"
);
validate_pattern_instance(instance, pattern);
compilation = compile_pattern_instance(instance, pattern);
validate_pattern_compilation(compilation, instance, pattern);
shape = pattern_compilation_normalized_shape(compilation);
validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);

fixture = bend_post_fixture_spec(
    name = "LONG_WAVE_SEGMENTATION_TEST",
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
    notes = "Synthetic long-form segmentation contract."
);
validate_bend_post_fixture(fixture, LABORATORY_STRAP_MATERIALS);
full_plan = plan_bend_post_fixture(
    path, fixture, LABORATORY_STRAP_MATERIALS
);
assert(!sb_fixture_plan_fits_print_envelope(full_plan, fixture),
    "The 30-wave reference must exceed one 220 x 220 mm full-form base.");
validate_bend_post_fixture_plan(
    full_plan,
    fixture,
    path,
    LABORATORY_STRAP_MATERIALS,
    enforce_print_envelope = false
);

segmentation = plan_bend_post_fixture_segmentation(path, full_plan, fixture);
validate_bend_post_fixture_segmentation(
    segmentation, full_plan, fixture, path
);
components = fixture_segmentation_plan_components(segmentation);
assert(len(components) == 23,
    "The reference 30-wave fixture must partition deterministically into 23 components.");
assert(fixture_component_id(components[0]) ==
    "LONG_WAVE_SEGMENTATION_TEST__C001",
    "First component ID must be deterministic and zero-padded.");
assert(fixture_component_id(components[len(components) - 1]) ==
    sb_fixture_component_id(fixture, len(components) - 1),
    "Final component ID must derive deterministically from its index.");
assert(len([
    for (component = components)
        if (fixture_component_base_width_mm(component) <= 220 + 1e-7 &&
            fixture_component_base_depth_mm(component) <= 220 + 1e-7)
            component
]) == len(components),
    "Every segmented component must fit the configured print envelope.");
assert(sb_near(
        fixture_component_station_start_mm(components[0]),
        0,
        SB_NUMERIC_STATION_TOLERANCE_MM
    ),
    "First component must begin at analytical station zero.");
assert(sb_near(
        fixture_component_station_end_mm(components[len(components) - 1]),
        analytical_path_length(path),
        SB_NUMERIC_STATION_TOLERANCE_MM
    ),
    "Final component must end at the analytical path length.");
assert(sb_list_sum([
    for (component = components)
        len(fixture_component_bend_stations(component))
]) == len(bend_post_fixture_plan_stations(full_plan)),
    "Segmentation must assign every bend station exactly once.");
for (index = [1 : len(components) - 1]) {
    previous = components[index - 1];
    current = components[index];
    assert(fixture_datum_role(fixture_component_end_datum(previous)) ==
        "component_split" &&
        fixture_datum_role(fixture_component_start_datum(current)) ==
        "component_split",
        "Interior component boundaries must be straight-region split datums.");
}

report_bend_post_fixture_segmentation(segmentation, "summary");
render_bend_post_fixture_component(components[0], full_plan, fixture);

echo("STRAP BENDER FIXTURE SEGMENTATION CONTRACT: PASS");
