//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup.scad
// Project: Strap Bender
// FileGroup: Workbench Fixture Configuration
// FileSummary: Constructs transient segmented-fixture setup-aid settings.
//////////////////////////////////////////////////////////////////////

WORKBENCH_FIXTURE_SETUP_AID = fixture_setup_aid_spec(
    name = str(wb_project_name, "_FIXTURE_SETUP_AID"),
    registration_mode = wb_fixture_registration_mode,
    pin_nominal_diameter_mm = wb_fixture_registration_pin_diameter_mm,
    hole_diametral_clearance_mm =
        wb_fixture_registration_hole_clearance_mm,
    tangent_spacing_mm = wb_fixture_registration_tangent_spacing_mm,
    normal_offset_mm = wb_fixture_registration_normal_offset_mm,
    label_mode = wb_fixture_component_label_mode,
    label_size_mm = wb_fixture_component_label_size_mm,
    label_depth_mm = wb_fixture_component_label_depth_mm,
    notes = str(
        "Physical setup aids for sequential segmented fixtures. Matching ",
        "registration-hole pairs preserve one exact split datum across adjacent ",
        "components; recessed corner marks preserve component index identity."
    )
);
