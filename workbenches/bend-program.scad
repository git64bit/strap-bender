//////////////////////////////////////////////////////////////////////
// LibFile: bend-program.scad
// Project: Strap Bender
// FileGroup: Executable Workbench
// FileSummary: Selects and reports one arbitrary-length bend program.
//////////////////////////////////////////////////////////////////////

/* [Bend program] */
program_name_selected = "OPEN_MIXED_RADIUS_EXAMPLE"; // [OPEN_MIXED_RADIUS_EXAMPLE,THIRTY_SIX_BEND_SCALE_EXAMPLE]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
project_name_selected = "BEND_PROGRAM_LAB";
workbench_name = "bend_program";
render_mode = "report_only";
include <../main.scad>
