//////////////////////////////////////////////////////////////////////
// LibFile: strap_solid_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies open and closed nominal strap-body rendering.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

material = strap_material_spec(
    "TEST_STRAP_SOLID_MATERIAL",
    "TEST MAKER",
    "TEST-SOLID-1",
    "PET polyester",
    15.875,
    0.508,
    sb_pounds_force_to_newtons(750),
    sb_feet_to_mm(2850),
    "black",
    "smooth",
    100,
    "TEST SOURCE",
    "2099-01-01",
    "https://example.invalid/test-strap-solid",
    "Synthetic dimensions for strap-solid contract only."
);

open_shape = bend_program_shape_spec(
    name = "STRAP_SOLID_OPEN_TEST",
    commands = [
        straight_command(0, 40, "S0"),
        bend_command(1, 90, 5, "B0"),
        straight_command(2, 30, "S1"),
        bend_command(3, -45, 2, "B1"),
        straight_command(4, 25, "S2")
    ],
    closure = "open",
    start_pose = start_pose_spec(0, 0, 0)
);

closed_shape = bend_program_shape_spec(
    name = "STRAP_SOLID_CLOSED_TEST",
    commands = [
        straight_command(0, 80, "E0"),
        bend_command(1, 90, 10, "V1"),
        straight_command(2, 80, "E1"),
        bend_command(3, 90, 10, "V2"),
        straight_command(4, 80, "E2"),
        bend_command(5, 90, 10, "V3"),
        straight_command(6, 80, "E3"),
        bend_command(7, 90, 10, "V0")
    ],
    closure = "closed",
    start_pose = start_pose_spec(10, 0, 0)
);

open_path = compile_bend_program(open_shape);
closed_path = compile_bend_program(closed_shape);
open_sampled = sample_analytical_path(open_path, 0.02, 5);
closed_sampled = sample_analytical_path(closed_path, 0.02, 5);

validate_strap_solid_render(open_path, open_sampled, material);
validate_strap_solid_render(closed_path, closed_sampled, material);

assert(strap_material_nominal_width_mm(material) == 15.875,
    "Strap-solid width contract failed.");
assert(strap_material_nominal_thickness_mm(material) == 0.508,
    "Strap-solid thickness contract failed.");
assert(analytical_path_closure(open_path) == "open" &&
    analytical_path_closure(closed_path) == "closed",
    "Strap-solid open/closed source contract failed.");

render_strap_solid(open_path, open_sampled, material);
translate([140, 0, 0])
    render_strap_solid(closed_path, closed_sampled, material);

echo("STRAP BENDER STRAP SOLID CONTRACT: PASS");
