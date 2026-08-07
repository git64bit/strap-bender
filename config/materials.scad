
//////////////////////////////////////////////////////////////////////
// LibFile: materials.scad
// Project: Strap Bender
// FileGroup: Strap Material Router
// FileSummary: Exposes strap products allowed by the active workbench.
//////////////////////////////////////////////////////////////////////

STRAP_MATERIALS =
    wb_workbench_name == "strap_profile" ||
    wb_workbench_name == "development"
        ? LABORATORY_STRAP_MATERIALS
        : [];
