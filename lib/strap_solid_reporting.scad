//////////////////////////////////////////////////////////////////////
// LibFile: strap_solid_reporting.scad
// Project: Strap Bender
// FileGroup: Strap Solid Reporting
// FileSummary: Reports nominal physical dimensions and preview placement policy.
//////////////////////////////////////////////////////////////////////

module report_strap_solid_render(
    analytical_path,
    sampled_path,
    material,
    xy_offset = [0, 0],
    clip_bounds = undef,
    z_offset_mm = 0,
    report_level = "summary"
) {
    echo("--- Strap Bender strap solid preview ---");
    echo(str("Material: ", strap_material_name(material)));
    echo(str("Nominal width: ",
        strap_material_nominal_width_mm(material), " mm"));
    echo(str("Nominal thickness: ",
        strap_material_nominal_thickness_mm(material), " mm"));
    echo(str("Reference path: ", analytical_path_name(analytical_path),
        " [", analytical_path_reference_axis(analytical_path), "]"));
    echo(str("Placement: reference_centered; XY offset: ",
        xy_offset, "; Z offset: ", z_offset_mm, " mm"));
    if (!is_undef(clip_bounds))
        echo(str("Component clip bounds: ", clip_bounds));
    echo(str("Sampled points: ", len(sampled_path_points(sampled_path)),
        "; chord error <= ", sampled_path_chord_error_mm(sampled_path),
        " mm; max angular step ",
        sampled_path_max_angle_step_degrees(sampled_path), " deg"));
    if (report_level == "full")
        echo(str(
            "Preview note: the analytical finished-inside-edge reference is ",
            "centered within nominal strap thickness for one continuous display ",
            "solid. This visualization does not redefine target radii, cut ",
            "length, neutral-axis position, or fixture clearance."
        ));
}
