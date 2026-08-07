//////////////////////////////////////////////////////////////////////
// LibFile: radius_calibration_coupon_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies printable radius-coupon records, datums, and resolution.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>
include <../registries/laboratory_radius_coupons.scad>

coupon_r1_6 = named_record(
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "radius calibration coupon"
);
coupon_r5 = named_record(
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "ULINE_R90_TOOL_R5_EXPERIMENTAL",
    "radius calibration coupon"
);

validate_radius_calibration_coupon(
    coupon_r1_6,
    LABORATORY_STRAP_MATERIALS
);
validate_radius_calibration_coupon(
    coupon_r5,
    LABORATORY_STRAP_MATERIALS
);
report_radius_calibration_coupon(coupon_r1_6, "full");

assert(radius_coupon_name(coupon_r1_6) ==
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "Radius-coupon name accessor failed.");
assert(radius_coupon_strap_material_name(coupon_r1_6) ==
    "ULINE_S_1655_BLACK",
    "Radius-coupon material provenance failed.");
assert(abs(radius_coupon_tool_inside_radius_mm(coupon_r1_6) - 1.6) < 1e-9,
    "R1.6 reference coupon must preserve designed tool radius.");
assert(abs(radius_coupon_tool_inside_radius_mm(coupon_r5) - 5) < 1e-9,
    "R5 reference coupon must preserve designed tool radius.");
assert(radius_coupon_entry_tangent_point(coupon_r1_6) == [0, 0],
    "Radius-coupon entry tangent datum failed.");
assert(sb_point_distance(
        radius_coupon_exit_tangent_point(coupon_r1_6),
        [1.6, 1.6]
    ) < 0.000001,
    "R1.6 90-degree exit tangent datum failed.");
assert(sb_point_distance(
        radius_coupon_exit_leg_end(coupon_r1_6),
        [1.6, 31.6]
    ) < 0.000001,
    "R1.6 90-degree exit-leg endpoint failed.");
assert(radius_coupon_arc_segment_count(coupon_r1_6) >= 18,
    "R1.6 coupon must honor the five-degree maximum surface step.");
assert(radius_coupon_actual_surface_sagitta_mm(coupon_r1_6) <=
    radius_coupon_tool_surface_chord_error_mm(coupon_r1_6) + 1e-9,
    "R1.6 coupon surface must honor requested chord-error bound.");
assert(len(radius_coupon_outer_arc_points(coupon_r1_6)) ==
    radius_coupon_arc_segment_count(coupon_r1_6) + 1,
    "Radius-coupon outer arc must retain both tangent endpoints.");

right_turn = radius_calibration_coupon_spec(
    name = "SYNTHETIC_RIGHT_TURN_COUPON",
    strap_material_name = "ULINE_S_1655_BLACK",
    tool_inside_radius_mm = 2,
    bend_angle_degrees = -90,
    entry_tangent_mm = 20,
    exit_tangent_mm = 20,
    form_depth_mm = 6,
    form_height_mm = 18,
    base_thickness_mm = 3,
    base_margin_mm = 4,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    notes = "Synthetic geometry contract only."
);
validate_radius_calibration_coupon(
    right_turn,
    LABORATORY_STRAP_MATERIALS
);
assert(sb_point_distance(
        radius_coupon_exit_tangent_point(right_turn),
        [2, -2]
    ) < 0.000001,
    "Negative-angle coupon must mirror the exit tangent datum.");
assert(sb_point_distance(
        radius_coupon_exit_leg_end(right_turn),
        [2, -22]
    ) < 0.000001,
    "Negative-angle coupon must mirror the exit tangent leg.");

// Render one reference coupon so F5 exercises the actual printable geometry.
render_radius_calibration_coupon(coupon_r1_6);

echo("STRAP BENDER RADIUS CALIBRATION COUPON CONTRACT: PASS");
