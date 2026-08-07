//////////////////////////////////////////////////////////////////////
// LibFile: radius_calibration_coupon.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Geometry
// FileSummary: Renders a printable open inside-form radius coupon.
//////////////////////////////////////////////////////////////////////

module radius_coupon_entry_strip_2d(coupon) {
    polygon(points = radius_coupon_entry_strip_polygon(coupon));
}

module radius_coupon_exit_strip_2d(coupon) {
    polygon(points = radius_coupon_exit_strip_polygon(coupon));
}

module radius_coupon_arc_band_2d(coupon) {
    polygon(points = radius_coupon_arc_band_polygon(coupon));
}

module radius_coupon_contact_body_2d(coupon) {
    union() {
        radius_coupon_entry_strip_2d(coupon);
        radius_coupon_arc_band_2d(coupon);
        radius_coupon_exit_strip_2d(coupon);
    }
}

module render_radius_calibration_coupon(coupon) {
    angle_step = radius_coupon_tool_surface_max_angle_step_degrees(coupon);
    $fa = min(angle_step, 10);
    $fs = max(0.1, radius_coupon_tool_surface_chord_error_mm(coupon));

    union() {
        linear_extrude(
            height = radius_coupon_base_thickness_mm(coupon),
            convexity = 10
        )
            offset(r = radius_coupon_base_margin_mm(coupon))
                radius_coupon_contact_body_2d(coupon);

        translate([0, 0, radius_coupon_base_thickness_mm(coupon)])
            linear_extrude(
                height = radius_coupon_form_height_mm(coupon),
                convexity = 10
            )
                radius_coupon_contact_body_2d(coupon);
    }
}
