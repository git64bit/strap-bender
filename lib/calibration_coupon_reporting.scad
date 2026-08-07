//////////////////////////////////////////////////////////////////////
// LibFile: calibration_coupon_reporting.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Reporting
// FileSummary: Reports experimental radius-coupon geometry and limitations.
//////////////////////////////////////////////////////////////////////

module report_radius_calibration_coupon(coupon, level = "summary") {
    echo(str("RADIUS CALIBRATION COUPON: ", radius_coupon_name(coupon)));
    echo(str("Strap material: ", radius_coupon_strap_material_name(coupon)));
    echo(str("Designed tool inside radius: ",
        radius_coupon_tool_inside_radius_mm(coupon), " mm"));
    echo(str("Tool bend angle: ",
        radius_coupon_bend_angle_degrees(coupon), " deg"));
    echo(str("Entry / exit tangent: ",
        radius_coupon_entry_tangent_mm(coupon), " / ",
        radius_coupon_exit_tangent_mm(coupon), " mm"));
    echo(str("Form depth / height: ",
        radius_coupon_form_depth_mm(coupon), " / ",
        radius_coupon_form_height_mm(coupon), " mm"));
    echo(str("Base thickness / margin: ",
        radius_coupon_base_thickness_mm(coupon), " / ",
        radius_coupon_base_margin_mm(coupon), " mm"));
    echo(str("Tool arc facets across bend: ",
        radius_coupon_arc_segment_count(coupon)));
    echo(str("Resolved maximum ideal-circle sagitta: ",
        radius_coupon_actual_surface_sagitta_mm(coupon), " mm"));
    echo(str("Entry tangent datum: ",
        radius_coupon_entry_tangent_point(coupon)));
    echo(str("Exit tangent datum: ",
        radius_coupon_exit_tangent_point(coupon)));

    if (level == "full") {
        echo(str("Arc center: ", radius_coupon_arc_center(coupon)));
        echo(str("Entry leg start: ", radius_coupon_entry_leg_start(coupon)));
        echo(str("Exit leg end: ", radius_coupon_exit_leg_end(coupon)));
        echo(str("Requested tool-surface chord error: ",
            radius_coupon_tool_surface_chord_error_mm(coupon), " mm"));
        echo(str("Requested tool-surface maximum angle step: ",
            radius_coupon_tool_surface_max_angle_step_degrees(coupon),
            " deg"));
        echo(str("Notes: ", radius_coupon_notes(coupon)));
    }

    echo(str(
        "EXPERIMENTAL CALIBRATION TOOL: designed tool radius is not a ",
        "predicted relaxed PET radius. Record actual forming conditions and ",
        "measured finished radius as a separate observation."
    ));
}
