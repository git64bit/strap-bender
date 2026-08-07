//////////////////////////////////////////////////////////////////////
// LibFile: strap_cut_plan_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies nominal developed length and explicit cutting allowances.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>

tolerance = 0.000001;
material = named_record(
    LABORATORY_STRAP_MATERIALS,
    "ULINE_S_1655_BLACK",
    "strap material"
);
thickness_mm = strap_material_nominal_thickness_mm(material);

open_shape = bend_program_shape_spec(
    "CUT_OPEN_TEST",
    [
        straight_command(0, 100, "S0"),
        bend_command(1, 90, 10, "B0")
    ],
    "open",
    start_pose_spec(0, 0, 0)
);
open_path = compile_bend_program(open_shape);
open_spec = strap_cut_spec(
    "CUT_OPEN_TEST_SPEC",
    "ULINE_S_1655_BLACK",
    "nominal_mid_thickness",
    0.5,
    5,
    7,
    "none",
    0,
    0,
    "Synthetic nominal cut-plan contract."
);
validate_strap_cut_spec(open_spec, open_path, LABORATORY_STRAP_MATERIALS);
open_plan = plan_strap_cut(open_path, open_spec, LABORATORY_STRAP_MATERIALS);
validate_strap_cut_plan(
    open_plan, open_spec, open_path, LABORATORY_STRAP_MATERIALS
);
expected_open_arc = (10 + thickness_mm / 2) * SB_PI / 2;
expected_open_developed = 100 + expected_open_arc;
assert(abs(strap_cut_plan_developed_arc_length_mm(open_plan) -
        expected_open_arc) <= tolerance,
    "Nominal mid-thickness developed arc calculation failed.");
assert(abs(strap_cut_plan_nominal_developed_length_mm(open_plan) -
        expected_open_developed) <= tolerance,
    "Nominal open developed-length total failed.");
assert(abs(strap_cut_plan_cut_length_mm(open_plan) -
        (expected_open_developed + 12)) <= tolerance,
    "Open-path start/end allowance calculation failed.");
assert(strap_cut_plan_status(open_plan) == "nominal_uncalibrated",
    "Open nominal cut-plan status failed.");

closed_polygon = vertex_polygon_spec(
    "CUT_CLOSED_SQUARE",
    [[0, 0], [100, 0], [100, 100], [0, 100]],
    10
);
closed_path = compile_bend_program(
    polygon_compilation_normalized_shape(
        compile_vertex_polygon(closed_polygon)
    )
);
closed_spec = strap_cut_spec(
    "CUT_CLOSED_OVERLAP_SPEC",
    "ULINE_S_1655_BLACK",
    "custom_fraction",
    0.4,
    2,
    3,
    "overlap",
    15,
    1,
    "Synthetic closed overlap contract."
);
validate_strap_cut_spec(closed_spec, closed_path, LABORATORY_STRAP_MATERIALS);
closed_plan = plan_strap_cut(
    closed_path, closed_spec, LABORATORY_STRAP_MATERIALS
);
validate_strap_cut_plan(
    closed_plan, closed_spec, closed_path, LABORATORY_STRAP_MATERIALS
);
assert(abs(strap_cut_plan_allowance_total_mm(closed_plan) - 21) <= tolerance,
    "Closed-path explicit allowance total failed.");
assert(abs(strap_cut_plan_cut_length_mm(closed_plan) -
        (strap_cut_plan_nominal_developed_length_mm(closed_plan) + 21)) <=
        tolerance,
    "Closed overlap cut-length calculation failed.");
assert(strap_cut_plan_status(closed_plan) == "nominal_uncalibrated",
    "Closed overlap cut-plan status failed.");

unassigned_spec = strap_cut_spec(
    "CUT_CLOSED_UNASSIGNED_SPEC",
    "ULINE_S_1655_BLACK",
    "nominal_mid_thickness",
    0.5,
    0,
    0,
    "none",
    0,
    0
);
unassigned_plan = plan_strap_cut(
    closed_path, unassigned_spec, LABORATORY_STRAP_MATERIALS
);
validate_strap_cut_spec(
    unassigned_spec, closed_path, LABORATORY_STRAP_MATERIALS
);
validate_strap_cut_plan(
    unassigned_plan, unassigned_spec, closed_path,
    LABORATORY_STRAP_MATERIALS
);
assert(strap_cut_plan_status(unassigned_plan) ==
        "nominal_uncalibrated_closure_unassigned",
    "Closed path without a physical seam policy must be marked unassigned.");

report_strap_cut_plan(open_plan, open_spec, open_path, "full");
report_strap_cut_plan(closed_plan, closed_spec, closed_path, "summary");
echo("STRAP BENDER STRAP CUT PLAN CONTRACT: PASS");
