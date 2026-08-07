//////////////////////////////////////////////////////////////////////
// LibFile: calibration_coupon_accessors.scad
// Project: Strap Bender
// FileGroup: Calibration Tooling Data Model
// FileSummary: Named accessors for printable radius-calibration coupons.
//////////////////////////////////////////////////////////////////////

function radius_coupon_name(coupon) = coupon[RC_NAME];
function radius_coupon_strap_material_name(coupon) =
    coupon[RC_STRAP_MATERIAL_NAME];
function radius_coupon_tool_inside_radius_mm(coupon) =
    coupon[RC_TOOL_INSIDE_RADIUS_MM];
function radius_coupon_bend_angle_degrees(coupon) =
    coupon[RC_BEND_ANGLE_DEGREES];
function radius_coupon_entry_tangent_mm(coupon) =
    coupon[RC_ENTRY_TANGENT_MM];
function radius_coupon_exit_tangent_mm(coupon) =
    coupon[RC_EXIT_TANGENT_MM];
function radius_coupon_form_depth_mm(coupon) = coupon[RC_FORM_DEPTH_MM];
function radius_coupon_form_height_mm(coupon) = coupon[RC_FORM_HEIGHT_MM];
function radius_coupon_base_thickness_mm(coupon) =
    coupon[RC_BASE_THICKNESS_MM];
function radius_coupon_base_margin_mm(coupon) = coupon[RC_BASE_MARGIN_MM];
function radius_coupon_tool_surface_chord_error_mm(coupon) =
    coupon[RC_TOOL_SURFACE_CHORD_ERROR_MM];
function radius_coupon_tool_surface_max_angle_step_degrees(coupon) =
    coupon[RC_TOOL_SURFACE_MAX_ANGLE_STEP_DEGREES];
function radius_coupon_notes(coupon) = coupon[RC_NOTES];
