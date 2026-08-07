//////////////////////////////////////////////////////////////////////
// LibFile: calibration_coupon_schema.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Data Model
// FileSummary: Constructor for experimental printable radius coupons.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_RADIUS_CALIBRATION_COUPON_RECORD =
    "strap_bender_radius_calibration_coupon";

function radius_calibration_coupon_spec(
    name,
    strap_material_name,
    tool_inside_radius_mm,
    bend_angle_degrees,
    entry_tangent_mm,
    exit_tangent_mm,
    form_depth_mm,
    form_height_mm,
    base_thickness_mm,
    base_margin_mm,
    tool_surface_chord_error_mm = 0.02,
    tool_surface_max_angle_step_degrees = 5,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_RADIUS_CALIBRATION_COUPON_RECORD,
    schema_version,
    name,
    strap_material_name,
    tool_inside_radius_mm,
    bend_angle_degrees,
    entry_tangent_mm,
    exit_tangent_mm,
    form_depth_mm,
    form_height_mm,
    base_thickness_mm,
    base_margin_mm,
    tool_surface_chord_error_mm,
    tool_surface_max_angle_step_degrees,
    notes
];
