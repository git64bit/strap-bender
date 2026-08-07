//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_radius_coupons.scad
// Project: Strap Bender
// FileGroup: Laboratory Registry
// FileSummary: Registers experimental reference radius-coupon geometries.
//////////////////////////////////////////////////////////////////////

LABORATORY_RADIUS_CALIBRATION_COUPONS = [
    radius_calibration_coupon_spec(
        name = "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
        strap_material_name = "ULINE_S_1655_BLACK",
        tool_inside_radius_mm = 1.6,
        bend_angle_degrees = 90,
        entry_tangent_mm = 30,
        exit_tangent_mm = 30,
        form_depth_mm = 8,
        form_height_mm = 18,
        base_thickness_mm = 3,
        base_margin_mm = 5,
        tool_surface_chord_error_mm = 0.02,
        tool_surface_max_angle_step_degrees = 5,
        notes = str(
            "Experimental inside-form coupon for collecting physical data. ",
            "The 1.6 mm value is the designed tool radius, not a claim that ",
            "the relaxed PET strap will finish at 1.6 mm."
        )
    ),
    radius_calibration_coupon_spec(
        name = "ULINE_R90_TOOL_R5_EXPERIMENTAL",
        strap_material_name = "ULINE_S_1655_BLACK",
        tool_inside_radius_mm = 5,
        bend_angle_degrees = 90,
        entry_tangent_mm = 30,
        exit_tangent_mm = 30,
        form_depth_mm = 8,
        form_height_mm = 18,
        base_thickness_mm = 3,
        base_margin_mm = 5,
        tool_surface_chord_error_mm = 0.02,
        tool_surface_max_angle_step_degrees = 5,
        notes = str(
            "Experimental inside-form coupon for collecting physical data. ",
            "The 5 mm value is the designed tool radius, not a claim that ",
            "the relaxed PET strap will finish at 5 mm."
        )
    )
];
