//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup_aid_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies shared split registration and component index marks.
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
shape = pattern_compilation_normalized_shape(compilation);
validate_bend_program_shape(shape);
path = compile_bend_program(shape);
validate_analytical_path(path);

fixture = bend_post_fixture_spec(
    name = "LONG_WAVE_SETUP_TEST",
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
    notes = "Synthetic segmented setup-aid contract."
);
validate_bend_post_fixture(fixture, LABORATORY_STRAP_MATERIALS);
full_plan = plan_bend_post_fixture(
    path, fixture, LABORATORY_STRAP_MATERIALS
);
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

setup = fixture_setup_aid_spec(
    name = "LONG_WAVE_SETUP_AID",
    registration_mode = "pin_pair",
    pin_nominal_diameter_mm = 3,
    hole_diametral_clearance_mm = 0.3,
    tangent_spacing_mm = 8,
    normal_offset_mm = 3,
    label_mode = "recessed_corner",
    label_size_mm = 2.5,
    label_depth_mm = 0.4,
    notes = "Synthetic shared-datum registration contract."
);
validate_fixture_setup_aid(
    setup, segmentation, full_plan, fixture, path
);

components = fixture_segmentation_plan_components(segmentation);
assert(len(components) == 23,
    "Reference setup-aid contract expects 23 segmented components.");
assert(sb_near(fixture_setup_aid_hole_diameter_mm(setup), 3.3, 1e-9),
    "Registration hole diameter must include diametral clearance.");
assert(sb_fixture_component_short_label(components[0]) == "001" &&
    sb_fixture_component_short_label(components[len(components) - 1]) == "023",
    "Physical component marks must be deterministic and zero-padded.");
assert(len(sb_fixture_component_registration_points(components[0], setup)) == 2,
    "First component must contain one end registration pair.");
assert(len(sb_fixture_component_registration_points(components[1], setup)) == 4,
    "Interior components must contain matching start and end registration pairs.");
assert(len(sb_fixture_component_registration_points(
        components[len(components) - 1], setup)) == 2,
    "Final component must contain one start registration pair.");

for (index = [1 : len(components) - 1]) {
    previous_points = sb_fixture_datum_registration_points(
        fixture_component_end_datum(components[index - 1]), setup
    );
    current_points = sb_fixture_datum_registration_points(
        fixture_component_start_datum(components[index]), setup
    );
    assert(sb_fixture_setup_points_near(
            previous_points,
            current_points,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Adjacent component registration pairs must coincide exactly.");
    assert(sb_near(
            sb_point_distance(previous_points[0], previous_points[1]),
            8,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Registration-hole pair spacing must preserve the source setting.");
}

report_fixture_setup_aid(setup, segmentation, "summary");
render_bend_post_fixture_component(
    components[0], full_plan, fixture, setup
);

echo("STRAP BENDER FIXTURE SETUP-AID CONTRACT: PASS");
