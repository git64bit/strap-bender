//////////////////////////////////////////////////////////////////////
// LibFile: diagnostic_render_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Renders one closed sampled path with tangent markers.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

shape = bend_program_shape_spec(
    name = "DIAGNOSTIC_RENDER_TEST",
    commands = [
        straight_command(0, 80, "S0"),
        bend_command(1, 90, 8, "B0"),
        straight_command(2, 80, "S1"),
        bend_command(3, 90, 8, "B1"),
        straight_command(4, 80, "S2"),
        bend_command(5, 90, 8, "B2"),
        straight_command(6, 80, "S3"),
        bend_command(7, 90, 8, "B3")
    ],
    closure = "closed",
    start_pose = start_pose_spec(0, 0, 0)
);

validate_bend_program_shape(shape);
analytical_path = compile_bend_program(shape);
validate_analytical_path(analytical_path);
sampled_path = sample_analytical_path(analytical_path, 0.05, 10);
validate_sampled_path(sampled_path, analytical_path);

render_diagnostic_path(
    analytical_path = analytical_path,
    sampled_path = sampled_path,
    path_width_mm = 0.8,
    path_height_mm = 0.4,
    show_tangent_points = true,
    tangent_marker_diameter_mm = 1.8
);

echo("STRAP BENDER DIAGNOSTIC RENDER CONTRACT: PASS");
