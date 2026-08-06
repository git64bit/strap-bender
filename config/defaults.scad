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

wb_sample_chord_error_mm = is_undef(sample_chord_error_mm)
    ? SB_DEFAULT_SAMPLE_CHORD_ERROR_MM : sample_chord_error_mm;
wb_sample_max_angle_step_degrees =
    is_undef(sample_max_angle_step_degrees)
        ? SB_DEFAULT_SAMPLE_MAX_ANGLE_STEP_DEGREES
        : sample_max_angle_step_degrees;
wb_diagnostic_path_width_mm = is_undef(diagnostic_path_width_mm)
    ? 0.8 : diagnostic_path_width_mm;
wb_diagnostic_path_height_mm = is_undef(diagnostic_path_height_mm)
    ? 0.4 : diagnostic_path_height_mm;
wb_show_tangent_points = is_undef(show_tangent_points)
    ? true : show_tangent_points;
wb_tangent_marker_diameter_mm =
    is_undef(tangent_marker_diameter_mm)
        ? 1.6 : tangent_marker_diameter_mm;
