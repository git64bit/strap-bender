//////////////////////////////////////////////////////////////////////
// LibFile: calibration_coupon_validation.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Validation
// FileSummary: Validates experimental radius-coupon source records.
//////////////////////////////////////////////////////////////////////

module validate_radius_calibration_coupon(coupon, material_registry) {
    assert(is_list(coupon) && len(coupon) == 15,
        "Radius calibration coupon records must contain fifteen fields.");
    assert(coupon[RC_RECORD_TYPE] ==
        STRAP_BENDER_RADIUS_CALIBRATION_COUPON_RECORD,
        "Invalid radius calibration coupon record type.");
    assert(sb_schema_version_valid(coupon[RC_SCHEMA_VERSION]),
        str("Unsupported radius coupon schema version: ",
            coupon[RC_SCHEMA_VERSION]));
    assert(sb_nonempty_string(radius_coupon_name(coupon)),
        "Radius calibration coupon name must be non-empty.");
    assert(sb_nonempty_string(radius_coupon_strap_material_name(coupon)),
        "Radius coupon strap-material name must be non-empty.");
    assert(len(records_named(
            material_registry,
            radius_coupon_strap_material_name(coupon)
        )) == 1,
        str("Radius coupon must reference exactly one strap material: ",
            radius_coupon_strap_material_name(coupon)));
    assert(sb_finite_number(radius_coupon_tool_inside_radius_mm(coupon)) &&
        radius_coupon_tool_inside_radius_mm(coupon) > 0,
        "Radius coupon tool inside radius must be finite and positive.");
    assert(sb_finite_number(radius_coupon_bend_angle_degrees(coupon)) &&
        radius_coupon_bend_angle_degrees(coupon) != 0 &&
        abs(radius_coupon_bend_angle_degrees(coupon)) <= 180,
        "Radius coupon bend angle must be within [-180, 180] and nonzero.");
    assert(sb_finite_number(radius_coupon_entry_tangent_mm(coupon)) &&
        radius_coupon_entry_tangent_mm(coupon) > 0,
        "Radius coupon entry tangent must be finite and positive.");
    assert(sb_finite_number(radius_coupon_exit_tangent_mm(coupon)) &&
        radius_coupon_exit_tangent_mm(coupon) > 0,
        "Radius coupon exit tangent must be finite and positive.");
    assert(sb_finite_number(radius_coupon_form_depth_mm(coupon)) &&
        radius_coupon_form_depth_mm(coupon) > 0,
        "Radius coupon form depth must be finite and positive.");
    assert(sb_finite_number(radius_coupon_form_height_mm(coupon)) &&
        radius_coupon_form_height_mm(coupon) > 0,
        "Radius coupon form height must be finite and positive.");
    assert(sb_finite_number(radius_coupon_base_thickness_mm(coupon)) &&
        radius_coupon_base_thickness_mm(coupon) > 0,
        "Radius coupon base thickness must be finite and positive.");
    assert(sb_finite_number(radius_coupon_base_margin_mm(coupon)) &&
        radius_coupon_base_margin_mm(coupon) > 0,
        "Radius coupon base margin must be finite and positive.");
    assert(sb_sampling_chord_error_valid(
            radius_coupon_tool_surface_chord_error_mm(coupon)) &&
        radius_coupon_tool_surface_chord_error_mm(coupon) <
            radius_coupon_tool_inside_radius_mm(coupon),
        "Tool-surface chord error must be positive and smaller than radius.");
    assert(sb_sampling_max_angle_step_valid(
            radius_coupon_tool_surface_max_angle_step_degrees(coupon)),
        "Tool-surface maximum angular step must be within (0, 180].");
    assert(is_string(radius_coupon_notes(coupon)),
        "Radius calibration coupon notes must be a string.");

    material = named_record(
        material_registry,
        radius_coupon_strap_material_name(coupon),
        "strap material"
    );
    assert(radius_coupon_form_height_mm(coupon) >=
        strap_material_nominal_width_mm(material),
        str("Radius coupon form height must be at least the nominal strap ",
            "width of ", strap_material_nominal_width_mm(material), " mm."));
    assert(radius_coupon_actual_surface_sagitta_mm(coupon) <=
        radius_coupon_tool_surface_chord_error_mm(coupon) + 1e-9,
        "Resolved tool-surface tessellation exceeds requested chord error.");
}
