//////////////////////////////////////////////////////////////////////
// LibFile: materials.scad
// Project: Strap Bender
// FileGroup: Strap Material Router
// FileSummary: Exposes strap products required by the active workbench route.
//////////////////////////////////////////////////////////////////////

STRAP_MATERIALS =
    wb_workbench_name == "strap_profile" ||
    wb_workbench_name == "radius_calibration" ||
    wb_workbench_name == "radius_observation" ||
    wb_workbench_name == "calibration_evidence" ||
    wb_workbench_name == "development" ||
    wb_render_mode == "bend_post_fixture"
        ? LABORATORY_STRAP_MATERIALS
        : [];
