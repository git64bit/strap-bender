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

echo("STRAP BENDER PUBLIC FOUNDATION CONTRACT: PASS");
