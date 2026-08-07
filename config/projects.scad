//////////////////////////////////////////////////////////////////////
// LibFile: projects.scad
// Project: Strap Bender
// FileGroup: Workbench Project Router
// FileSummary: Exposes only the registry selected by the active workbench.
//////////////////////////////////////////////////////////////////////

DEVELOPMENT_PROJECTS = concat(
    LABORATORY_PROJECTS,
    CATALOG_PROJECTS
);

PROJECTS =
    wb_workbench_name == "bend_program" ? LABORATORY_PROJECTS :
    wb_workbench_name == "vertex_polygon" ? LABORATORY_PROJECTS :
    wb_workbench_name == "regular_polygon" ? LABORATORY_PROJECTS :
    wb_workbench_name == "wave_pattern" ? LABORATORY_PROJECTS :
    wb_workbench_name == "strap_profile" ? LABORATORY_PROJECTS :
    wb_workbench_name == "radius_calibration" ? LABORATORY_PROJECTS :
    wb_workbench_name == "catalog" ? CATALOG_PROJECTS :
    DEVELOPMENT_PROJECTS;
