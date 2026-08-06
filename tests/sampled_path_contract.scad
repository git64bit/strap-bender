//////////////////////////////////////////////////////////////////////
// LibFile: sampled_path_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies bounded chordal sampling without analytical drift.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

shape = bend_program_shape_spec(
    name = "SAMPLED_PATH_TEST",
    commands = [
        straight_command(0, 100, "S0"),
        bend_command(1, 90, 10, "B0"),
        straight_command(2, 50, "S1")
    ],
    closure = "open",
    start_pose = start_pose_spec(0, 0, 0)
);

validate_bend_program_shape(shape);
analytical_path = compile_bend_program(shape);
validate_analytical_path(analytical_path);
arc = analytical_path_primitives(analytical_path)[1];

coarse_path = sample_analytical_path(analytical_path, 0.5, 45);
fine_path = sample_analytical_path(analytical_path, 0.01, 10);
validate_sampled_path(coarse_path, analytical_path);
validate_sampled_path(fine_path, analytical_path);

coarse_count = sb_arc_sample_count(arc, 0.5, 45);
fine_count = sb_arc_sample_count(arc, 0.01, 10);
coarse_points = sampled_path_points(coarse_path);
fine_points = sampled_path_points(fine_path);
tolerance = 0.000001;
expected_analytical_length = 150 + 10 * SB_PI / 2;

assert(coarse_count == 3,
    "Coarse arc sampling count contract failed.");
assert(fine_count == 18,
    "Fine arc sampling count contract failed.");
assert(len(coarse_points) == coarse_count + 3,
    "Coarse path must retain line endpoints without duplicates.");
assert(len(fine_points) == fine_count + 3,
    "Fine path must retain line endpoints without duplicates.");
assert(sb_arc_sample_sagitta_mm(arc, fine_count) <= 0.01 + tolerance,
    "Fine arc chord error exceeds the requested maximum.");
assert(sb_point_distance(
    fine_points[0],
    sb_pose_point(analytical_path_start_pose(analytical_path))
) <= tolerance,
    "Sampled path start point drifted from the analytical path.");
assert(sb_point_distance(
    fine_points[1],
    sb_pose_point(primitive_end_pose(
        analytical_path_primitives(analytical_path)[0]
    ))
) <= tolerance,
    "Straight-to-arc tangent point was not retained exactly.");
assert(sb_point_distance(
    fine_points[fine_count + 1],
    sb_pose_point(primitive_end_pose(arc))
) <= tolerance,
    "Arc-to-straight tangent point was not retained exactly.");
assert(sb_point_distance(
    fine_points[len(fine_points) - 1],
    sb_pose_point(analytical_path_end_pose(analytical_path))
) <= tolerance,
    "Sampled path end point drifted from the analytical path.");
assert(abs(analytical_path_length(analytical_path) -
    expected_analytical_length) <= tolerance,
    "Sampling may not alter exact analytical path length.");
assert(sampled_path_polyline_length(fine_path) >
    sampled_path_polyline_length(coarse_path),
    "Finer arc sampling should converge upward toward exact arc length.");
assert(sampled_path_polyline_length(fine_path) <
    analytical_path_length(analytical_path),
    "Chordal display length must remain below exact curved length.");

report_sampled_path(fine_path, analytical_path, "summary");
echo("STRAP BENDER SAMPLED PATH CONTRACT: PASS");
