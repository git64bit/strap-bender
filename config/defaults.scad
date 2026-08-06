//////////////////////////////////////////////////////////////////////
// LibFile: defaults.scad
// Project: Strap Bender
// FileGroup: Workbench Configuration
// FileSummary: Resolves wrapper inputs into stable internal values.
//////////////////////////////////////////////////////////////////////

wb_workbench_name = is_undef(workbench_name)
    ? "development" : workbench_name;
wb_project_name = is_undef(project_name_selected)
    ? "BEND_PROGRAM_LAB" : project_name_selected;
wb_render_mode = is_undef(render_mode)
    ? "report_only" : render_mode;
wb_report_level = is_undef(report_level)
    ? "full" : report_level;

wb_program_name = is_undef(program_name_selected)
    ? "OPEN_MIXED_RADIUS_EXAMPLE" : program_name_selected;
