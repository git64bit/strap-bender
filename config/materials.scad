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
    wb_cut_plan_enabled ||
    wb_manufacturing_manifest_enabled ||
    wb_strap_solid_enabled ||
    wb_render_mode == "bend_post_fixture"
        ? LABORATORY_STRAP_MATERIALS
        : [];
