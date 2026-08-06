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

echo("STRAP BENDER PUBLIC FOUNDATION CONTRACT: PASS");
