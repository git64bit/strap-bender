//////////////////////////////////////////////////////////////////////
// LibFile: public_foundation_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies public versions, constructors, and accessors.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

assert(STRAP_BENDER_API_VERSION == 1,
    "Unexpected Strap Bender API version.");
assert(STRAP_BENDER_SCHEMA_VERSION == 1,
    "Unexpected Strap Bender schema version.");
assert(STRAP_BENDER_BEND_PROGRAM_CONTRACT_VERSION == 1,
    "Unexpected bend-program contract version.");
assert(STRAP_BENDER_ANALYTICAL_PATH_CONTRACT_VERSION == 1,
    "Unexpected analytical-path contract version.");
assert(STRAP_BENDER_SAMPLED_PATH_CONTRACT_VERSION == 1,
    "Unexpected sampled-path contract version.");
assert(STRAP_BENDER_VALUE_SCHEDULE_CONTRACT_VERSION == 1,
    "Unexpected value-schedule contract version.");
assert(STRAP_BENDER_VERTEX_POLYGON_CONTRACT_VERSION == 1,
    "Unexpected vertex-polygon contract version.");
assert(STRAP_BENDER_POLYGON_INTERSECTION_DIAGNOSTIC_VERSION == 1,
    "Unexpected polygon-intersection diagnostic version.");
assert(STRAP_BENDER_REGULAR_POLYGON_CONTRACT_VERSION == 1,
    "Unexpected regular-polygon contract version.");
assert(STRAP_BENDER_PATTERN_CONTRACT_VERSION == 1,
    "Unexpected pattern contract version.");
assert(STRAP_BENDER_STRAP_MATERIAL_CONTRACT_VERSION == 1,
    "Unexpected strap material contract version.");
assert(STRAP_BENDER_RADIUS_OBSERVATION_CONTRACT_VERSION == 1,
    "Unexpected radius observation contract version.");
assert(STRAP_BENDER_RADIUS_CALIBRATION_COUPON_CONTRACT_VERSION == 1,
    "Unexpected radius calibration coupon contract version.");
assert(STRAP_BENDER_CALIBRATION_TRIAL_CONTRACT_VERSION == 1,
    "Unexpected calibration trial contract version.");
assert(STRAP_BENDER_CALIBRATION_EVIDENCE_REGISTRY_CONTRACT_VERSION == 1,
    "Unexpected calibration evidence registry contract version.");
assert(STRAP_BENDER_BEND_POST_FIXTURE_CONTRACT_VERSION == 3,
    "Unexpected bend-post fixture contract version.");
assert(STRAP_BENDER_FIXTURE_SEGMENTATION_CONTRACT_VERSION == 1,
    "Unexpected fixture-segmentation contract version.");

material = strap_material_spec(
    "TEST_STRAP",
    "TEST MAKER",
    "TEST-1",
    "PET polyester",
    15.875,
    0.508,
    sb_pounds_force_to_newtons(750),
    sb_feet_to_mm(2850),
    "black",
    "smooth",
    100,
    "TEST SOURCE",
    "2026-08-06",
    "https://example.invalid/test-strap"
);
observation = radius_observation_spec(
    "TEST_RADIUS_OBSERVATION",
    "TEST_STRAP",
    "TEST-SPECIMEN",
    15.9,
    0.51,
    90,
    4,
    "cold",
    20,
    30,
    "not_applicable",
    60,
    5,
    "synthetic contract method",
    "2099-01-01",
    0.1,
    "Synthetic public-foundation record only."
);
coupon = radius_calibration_coupon_spec(
    "TEST_RADIUS_COUPON",
    "TEST_STRAP",
    2,
    90,
    20,
    20,
    6,
    18,
    3,
    4,
    0.02,
    5,
    "Synthetic public-foundation coupon only."
);
trial_observation = radius_observation_spec(
    "TEST_LINKED_RADIUS_OBSERVATION",
    "TEST_STRAP",
    "TEST-LINKED-SPECIMEN",
    15.9,
    0.51,
    90,
    2,
    "cold",
    20,
    30,
    "not_applicable",
    60,
    2.5,
    "synthetic linked contract method",
    "2099-01-01",
    0.1,
    "Synthetic linked public-foundation record only."
);
trial = calibration_trial_spec(
    "TEST_CALIBRATION_TRIAL",
    "TEST_RADIUS_COUPON",
    trial_observation,
    "Synthetic public-foundation trial only."
);

fixture = bend_post_fixture_spec(
    "TEST_BEND_POST_FIXTURE",
    "TEST_STRAP",
    "nominal_target",
    3,
    8,
    18,
    0.25,
    1,
    220,
    220,
    0.02,
    5,
    "arc_follower",
    2,
    "Synthetic public-foundation fixture only."
);
fixture_datum = fixture_assembly_datum_spec(
    25,
    [30, 40],
    15,
    "component_split",
    2,
    "TEST_SPLIT"
);
fixture_component = fixture_component_spec(
    "TEST_BEND_POST_FIXTURE__C001",
    0,
    0,
    25,
    fixture_assembly_datum_spec(0, [0, 0], 0, "path_start", 0, "START"),
    fixture_datum,
    [],
    [-5, -5, 35, 45],
    "Synthetic component record."
);
fixture_segmentation = fixture_segmentation_plan_spec(
    "TEST_BEND_POST_FIXTURE",
    "TEST_PATH",
    "sequential_straight_split",
    [fixture_component],
    [0, 25],
    220,
    220,
    "experimental_uncompensated",
    "Synthetic segmentation record."
);
project = project_spec("TEST_PROJECT", "bend_program", "laboratory");
pose = start_pose_spec(10, -5, 30);
straight = straight_command(0, 25, "TEST_STRAIGHT");
bend = bend_command(1, -90, 5, "TEST_BEND");
shape = bend_program_shape_spec(
    "TEST_SHAPE",
    [straight, bend],
    "open",
    pose
);
sampled = sampled_path_spec(
    "TEST_SHAPE",
    "finished_inside_edge",
    "open",
    [[10, -5], [20, 0]],
    0.05,
    10
);
schedule = value_schedule_every_nth(
    default_value = 1.6,
    selected_value = 5,
    interval = 3,
    first_position = 3,
    label = "foundation schedule"
);
polygon = vertex_polygon_spec(
    "TEST_POLYGON",
    [[0, 0], [20, 0], [20, 20], [0, 20]],
    2
);
regular_polygon = regular_polygon_spec(
    "TEST_REGULAR_POLYGON",
    5,
    "side_length",
    40,
    2,
    [10, -10],
    90,
    0
);
regular_compilation = compile_regular_polygon(regular_polygon);
pattern = pattern_block_spec(
    "TEST_PATTERN",
    [
        pattern_straight_element("length_mm", "STRAIGHT"),
        pattern_bend_element("angle_degrees", "radius_mm", 1, "BEND")
    ]
);
pattern_instance = pattern_instance_spec(
    "TEST_PATTERN_INSTANCE",
    "TEST_PATTERN",
    2,
    [
        pattern_parameter_spec("length_mm", 25),
        pattern_parameter_spec("angle_degrees", 30),
        pattern_parameter_spec("radius_mm", 2)
    ]
);
pattern_compilation = compile_pattern_instance(
    pattern_instance,
    pattern
);

validate_strap_material(material);
validate_radius_observation(observation, [material]);
validate_radius_calibration_coupon(coupon, [material]);
validate_radius_observation(trial_observation, [material]);
validate_calibration_trial(trial, [material], [coupon]);
validate_bend_post_fixture(fixture, [material]);
assert(radius_observation_name(observation) == "TEST_RADIUS_OBSERVATION" &&
    radius_observation_specimen_id(observation) == "TEST-SPECIMEN" &&
    abs(radius_observation_springback_delta_mm(observation) - 1) < 1e-9,
    "Radius observation constructor or accessor contract failed.");
assert(radius_coupon_name(coupon) == "TEST_RADIUS_COUPON" &&
    radius_coupon_strap_material_name(coupon) == "TEST_STRAP" &&
    abs(radius_coupon_tool_inside_radius_mm(coupon) - 2) < 1e-9 &&
    sb_point_distance(radius_coupon_exit_tangent_point(coupon), [2, 2]) < 1e-9,
    "Radius calibration coupon constructor or accessor contract failed.");
assert(calibration_trial_name(trial) == "TEST_CALIBRATION_TRIAL" &&
    calibration_trial_coupon_name(trial) == "TEST_RADIUS_COUPON" &&
    calibration_trial_observation(trial) == trial_observation,
    "Calibration trial constructor or accessor contract failed.");
assert(bend_post_fixture_name(fixture) == "TEST_BEND_POST_FIXTURE" &&
    bend_post_fixture_strap_material_name(fixture) == "TEST_STRAP" &&
    bend_post_fixture_radius_mode(fixture) == "nominal_target" &&
    bend_post_fixture_strap_clearance_mm(fixture) == 0.25 &&
    bend_post_fixture_minimum_post_gap_mm(fixture) == 1 &&
    bend_post_fixture_retention_mode(fixture) == "arc_follower" &&
    bend_post_fixture_follower_wall_thickness_mm(fixture) == 2,
    "Bend-post fixture constructor or accessor contract failed.");
assert(fixture_datum_station_mm(fixture_datum) == 25 &&
    fixture_datum_point(fixture_datum) == [30, 40] &&
    fixture_component_id(fixture_component) ==
        "TEST_BEND_POST_FIXTURE__C001" &&
    fixture_segmentation_plan_component_count(fixture_segmentation) == 1,
    "Fixture segmentation constructor or accessor contract failed.");
assert(strap_material_name(material) == "TEST_STRAP" &&
    abs(strap_material_nominal_width_in(material) - 0.625) < 1e-9 &&
    abs(strap_material_nominal_thickness_in(material) - 0.020) < 1e-9,
    "Strap material constructor or accessor contract failed.");
assert(project_name(project) == "TEST_PROJECT",
    "Project accessor contract failed.");
assert(pose_x(pose) == 10 && pose_y(pose) == -5,
    "Pose accessor contract failed.");
assert(command_distance(straight) == 25,
    "Straight accessor contract failed.");
assert(command_angle_degrees(bend) == -90 &&
    command_inside_radius(bend) == 5,
    "Bend accessor contract failed.");
assert(shape_name(shape) == "TEST_SHAPE" &&
    len(shape_commands(shape)) == 2,
    "Shape accessor contract failed.");
assert(sampled_path_name(sampled) == "TEST_SHAPE" &&
    len(sampled_path_points(sampled)) == 2 &&
    sampled_path_chord_error_mm(sampled) == 0.05,
    "Sampled path constructor or accessor contract failed.");
assert(value_schedule_kind(schedule) == "every_nth" &&
    value_schedule_interval(schedule) == 3 &&
    value_schedule_first_position(schedule) == 3 &&
    sb_resolve_numeric_value_source(schedule, 5) ==
        [1.6, 1.6, 5, 1.6, 1.6],
    "Value-schedule constructor, accessors, or resolution failed.");
assert(vertex_polygon_name(polygon) == "TEST_POLYGON" &&
    len(vertex_polygon_vertices(polygon)) == 4 &&
    len(vertex_polygon_corner_radii(polygon)) == 4 &&
    vertex_polygon_corner_radii(polygon)[2] == 2,
    "Vertex-polygon constructor or accessor contract failed.");
assert(regular_polygon_name(regular_polygon) ==
    "TEST_REGULAR_POLYGON" &&
    regular_polygon_side_count(regular_polygon) == 5 &&
    regular_polygon_dimension_kind(regular_polygon) == "side_length" &&
    regular_polygon_dimension_value(regular_polygon) == 40 &&
    regular_polygon_center(regular_polygon) == [10, -10],
    "Regular-polygon constructor or accessor contract failed.");
assert(len(regular_polygon_compilation_vertices(
    regular_compilation
)) == 5 && regular_polygon_compilation_source_name(
    regular_compilation
) == "TEST_REGULAR_POLYGON",
    "Regular-polygon compilation accessor contract failed.");
assert(pattern_block_name(pattern) == "TEST_PATTERN" &&
    len(pattern_block_elements(pattern)) == 2,
    "Pattern-block constructor or accessors failed.");
assert(pattern_instance_repeat_count(pattern_instance) == 2 &&
    len(shape_commands(pattern_compilation_normalized_shape(
        pattern_compilation
    ))) == 4,
    "Pattern-instance compilation accessor contract failed.");

echo("STRAP BENDER PUBLIC FOUNDATION CONTRACT: PASS");
