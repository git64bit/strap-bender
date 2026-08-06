//////////////////////////////////////////////////////////////////////
// LibFile: programs.scad
// Project: Strap Bender
// FileGroup: Bend-Program Router
// FileSummary: Exposes only bend programs allowed by the active workbench.
//////////////////////////////////////////////////////////////////////

BEND_PROGRAMS =
    wb_workbench_name == "bend_program" ||
    wb_workbench_name == "development"
        ? LABORATORY_BEND_PROGRAMS
        : [];
