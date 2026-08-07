//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup_reporting.scad
// Project: Strap Bender
// FileGroup: Fixture Setup Aid Reporting
// FileSummary: Reports registration-hole and physical component-mark policy.
//////////////////////////////////////////////////////////////////////

module report_fixture_setup_aid(
    setup,
    segmentation,
    level = "summary"
) {
    echo("--- Strap Bender segmented fixture setup aids ---");
    echo(str("Registration mode: ",
        fixture_setup_aid_registration_mode(setup)));
    if (sb_fixture_setup_registration_enabled(setup)) {
        echo(str("Registration pin / hole diameter: ",
            fixture_setup_aid_pin_nominal_diameter_mm(setup), " / ",
            fixture_setup_aid_hole_diameter_mm(setup), " mm"));
        echo(str("Registration pair spacing / left-normal offset: ",
            fixture_setup_aid_tangent_spacing_mm(setup), " / ",
            fixture_setup_aid_normal_offset_mm(setup), " mm"));
        echo(str(
            "SETUP REGISTRATION: matching end/start hole pairs share exact ",
            "global coordinates at every interior split. Use a common setup ",
            "surface or transfer pins; these holes do not make the overlapping ",
            "sequential bases into butt-jointed tiles."
        ));
    }
    echo(str("Physical component mark: ",
        fixture_setup_aid_label_mode(setup)));
    if (sb_fixture_setup_label_enabled(setup))
        echo(str("Component index mark size/depth: ",
            fixture_setup_aid_label_size_mm(setup), " / ",
            fixture_setup_aid_label_depth_mm(setup), " mm"));
    if (level == "full") {
        for (component = fixture_segmentation_plan_components(segmentation)) {
            echo(str("  ", fixture_component_id(component),
                " physical mark ", sb_fixture_component_short_label(component),
                "; registration global/local ",
                sb_fixture_component_registration_points(component, setup),
                " / ",
                sb_fixture_component_local_registration_points(
                    component, setup
                )));
        }
        echo(str("Notes: ", fixture_setup_aid_notes(setup)));
    }
}
