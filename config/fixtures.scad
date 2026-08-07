//////////////////////////////////////////////////////////////////////
// LibFile: fixtures.scad
// Project: Strap Bender
// FileGroup: Workbench Fixture Configuration
// FileSummary: Constructs the transient bend-post fixture specification.
//////////////////////////////////////////////////////////////////////

WORKBENCH_BEND_POST_FIXTURE = bend_post_fixture_spec(
    name = str(wb_project_name, "_BEND_POST_FIXTURE"),
    strap_material_name = wb_strap_material_name,
    radius_mode = "nominal_target",
    base_thickness_mm = wb_fixture_base_thickness_mm,
    base_margin_mm = wb_fixture_base_margin_mm,
    post_height_mm = wb_fixture_post_height_mm,
    strap_clearance_mm = wb_fixture_strap_clearance_mm,
    minimum_post_gap_mm = wb_fixture_minimum_post_gap_mm,
    max_base_width_mm = wb_fixture_max_base_width_mm,
    max_base_depth_mm = wb_fixture_max_base_depth_mm,
    tool_surface_chord_error_mm =
        wb_fixture_tool_surface_chord_error_mm,
    tool_surface_max_angle_step_degrees =
        wb_fixture_tool_surface_max_angle_step_degrees,
    retention_mode = "none",
    notes = str(
        "Mutable first production-shape fixture family. Full-form base with ",
        "one open-top circular inside-form post per analytical bend. ",
        "Nonlocal strap and post/post clearances are validated before render. ",
        "Radius mode is deliberately nominal and uncompensated."
    )
);
