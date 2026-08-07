//////////////////////////////////////////////////////////////////////
// LibFile: calibration_coupons.scad
// Project: Strap Bender
// FileGroup: Radius Calibration Router
// FileSummary: Builds and exposes the active experimental coupon source.
//////////////////////////////////////////////////////////////////////

WORKBENCH_RADIUS_CALIBRATION_COUPON = radius_calibration_coupon_spec(
    name = wb_radius_coupon_name,
    strap_material_name = wb_radius_coupon_strap_material_name,
    tool_inside_radius_mm = wb_radius_coupon_tool_inside_radius_mm,
    bend_angle_degrees = wb_radius_coupon_bend_angle_degrees,
    entry_tangent_mm = wb_radius_coupon_entry_tangent_mm,
    exit_tangent_mm = wb_radius_coupon_exit_tangent_mm,
    form_depth_mm = wb_radius_coupon_form_depth_mm,
    form_height_mm = wb_radius_coupon_form_height_mm,
    base_thickness_mm = wb_radius_coupon_base_thickness_mm,
    base_margin_mm = wb_radius_coupon_base_margin_mm,
    tool_surface_chord_error_mm =
        wb_radius_coupon_tool_surface_chord_error_mm,
    tool_surface_max_angle_step_degrees =
        wb_radius_coupon_tool_surface_max_angle_step_degrees,
    notes = str(
        "Mutable Customizer calibration coupon. It defines printable tool ",
        "geometry only; it does not predict springback or a finished radius."
    )
);

RADIUS_CALIBRATION_COUPONS =
    wb_workbench_name == "radius_calibration"
        ? [WORKBENCH_RADIUS_CALIBRATION_COUPON]
        : wb_workbench_name == "radius_observation" ||
          wb_workbench_name == "development"
            ? LABORATORY_RADIUS_CALIBRATION_COUPONS
            : [];
