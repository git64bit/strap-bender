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

wb_strap_material_name = is_undef(strap_material_name_selected)
    ? "ULINE_S_1655_BLACK" : strap_material_name_selected;

wb_program_name = is_undef(program_name_selected)
    ? "OPEN_MIXED_RADIUS_EXAMPLE" : program_name_selected;
wb_polygon_name = is_undef(polygon_name_selected)
    ? "ROUNDED_SQUARE_EXAMPLE" : polygon_name_selected;
wb_regular_polygon_name = is_undef(regular_polygon_name_selected)
    ? "REGULAR_TRIANGLE_SIDE_100_R5"
    : regular_polygon_name_selected;
wb_regular_side_count = is_undef(regular_side_count)
    ? 5 : regular_side_count;
wb_regular_dimension_kind = is_undef(regular_dimension_kind)
    ? "side_length" : regular_dimension_kind;
wb_regular_dimension_value_mm = is_undef(regular_dimension_value_mm)
    ? 100 : regular_dimension_value_mm;
wb_regular_corner_radius_mode = is_undef(regular_corner_radius_mode)
    ? "constant" : regular_corner_radius_mode;
wb_regular_corner_radius_mm = is_undef(regular_corner_radius_mm)
    ? 1.6 : regular_corner_radius_mm;
wb_regular_scheduled_corner_radius_mm =
    is_undef(regular_scheduled_corner_radius_mm)
        ? 5 : regular_scheduled_corner_radius_mm;
wb_regular_schedule_interval = is_undef(regular_schedule_interval)
    ? 3 : regular_schedule_interval;
wb_regular_schedule_first_position =
    is_undef(regular_schedule_first_position)
        ? 3 : regular_schedule_first_position;
wb_regular_first_vertex_angle_degrees =
    is_undef(regular_first_vertex_angle_degrees)
        ? 90 : regular_first_vertex_angle_degrees;
wb_regular_center_x_mm = is_undef(regular_center_x_mm)
    ? 0 : regular_center_x_mm;
wb_regular_center_y_mm = is_undef(regular_center_y_mm)
    ? 0 : regular_center_y_mm;

wb_pattern_instance_name = is_undef(pattern_instance_name_selected)
    ? "THIRTY_WAVE_EVERY_THIRD_R5"
    : pattern_instance_name_selected;
wb_wave_count = is_undef(wave_repeat_count)
    ? 30 : wave_repeat_count;
wb_wave_turn_angle_degrees = is_undef(wave_turn_angle_degrees)
    ? 45 : wave_turn_angle_degrees;
wb_wave_segment_schedule_mode = is_undef(wave_segment_schedule_mode)
    ? "constant" : wave_segment_schedule_mode;
wb_wave_base_segment_lengths_mm =
    is_undef(wave_base_segment_lengths_mm)
        ? [50] : wave_base_segment_lengths_mm;
wb_wave_rising_segment_lengths_mm =
    is_undef(wave_rising_segment_lengths_mm)
        ? [50] : wave_rising_segment_lengths_mm;
wb_wave_falling_segment_lengths_mm =
    is_undef(wave_falling_segment_lengths_mm)
        ? [50] : wave_falling_segment_lengths_mm;
wb_wave_radius_mode = is_undef(wave_radius_mode)
    ? "every_nth" : wave_radius_mode;
wb_wave_default_radius_mm = is_undef(wave_default_radius_mm)
    ? 1.6 : wave_default_radius_mm;
wb_wave_selected_radius_mm = is_undef(wave_selected_radius_mm)
    ? 5 : wave_selected_radius_mm;
wb_wave_radius_cycle_mm = is_undef(wave_radius_cycle_mm)
    ? [1.6, 1.6, 5] : wave_radius_cycle_mm;
wb_wave_radius_interval = is_undef(wave_radius_interval)
    ? 3 : wave_radius_interval;
wb_wave_radius_first_position = is_undef(wave_radius_first_position)
    ? 3 : wave_radius_first_position;


wb_radius_coupon_name = is_undef(radius_coupon_name_selected)
    ? "CUSTOM_RADIUS_CALIBRATION_COUPON" : radius_coupon_name_selected;
wb_radius_coupon_strap_material_name = is_undef(strap_material_name_selected)
    ? "ULINE_S_1655_BLACK" : strap_material_name_selected;
wb_radius_coupon_tool_inside_radius_mm = is_undef(tool_inside_radius_mm)
    ? 1.6 : tool_inside_radius_mm;
wb_radius_coupon_bend_angle_degrees = is_undef(bend_angle_degrees)
    ? 90 : bend_angle_degrees;
wb_radius_coupon_entry_tangent_mm = is_undef(entry_tangent_mm)
    ? 30 : entry_tangent_mm;
wb_radius_coupon_exit_tangent_mm = is_undef(exit_tangent_mm)
    ? 30 : exit_tangent_mm;
wb_radius_coupon_form_depth_mm = is_undef(form_depth_mm)
    ? 8 : form_depth_mm;
wb_radius_coupon_form_height_mm = is_undef(form_height_mm)
    ? 18 : form_height_mm;
wb_radius_coupon_base_thickness_mm = is_undef(base_thickness_mm)
    ? 3 : base_thickness_mm;
wb_radius_coupon_base_margin_mm = is_undef(base_margin_mm)
    ? 5 : base_margin_mm;
wb_radius_coupon_tool_surface_chord_error_mm =
    is_undef(tool_surface_chord_error_mm)
        ? 0.02 : tool_surface_chord_error_mm;
wb_radius_coupon_tool_surface_max_angle_step_degrees =
    is_undef(tool_surface_max_angle_step_degrees)
        ? 5 : tool_surface_max_angle_step_degrees;

wb_calibration_trial_ready = is_undef(observation_ready)
    ? false : observation_ready;
wb_calibration_trial_coupon_name = is_undef(radius_coupon_name_selected)
    ? "ULINE_R90_TOOL_R1_6_EXPERIMENTAL" : radius_coupon_name_selected;
wb_calibration_trial_name = is_undef(calibration_trial_name_selected)
    ? "CUSTOM_CALIBRATION_TRIAL" : calibration_trial_name_selected;
wb_radius_observation_name = is_undef(radius_observation_name_selected)
    ? "CUSTOM_RADIUS_OBSERVATION" : radius_observation_name_selected;
wb_radius_observation_specimen_id = is_undef(specimen_id)
    ? "" : specimen_id;
wb_radius_observation_measured_width_mm = is_undef(measured_width_mm)
    ? 0 : measured_width_mm;
wb_radius_observation_measured_thickness_mm = is_undef(measured_thickness_mm)
    ? 0 : measured_thickness_mm;
wb_radius_observation_forming_method = is_undef(forming_method)
    ? "unset" : forming_method;
wb_radius_observation_forming_temperature_c = is_undef(forming_temperature_c)
    ? 0 : forming_temperature_c;
wb_radius_observation_dwell_seconds = is_undef(dwell_seconds)
    ? 0 : dwell_seconds;
wb_radius_observation_cooling_restraint = is_undef(cooling_restraint)
    ? "unset" : cooling_restraint;
wb_radius_observation_release_rest_seconds = is_undef(release_rest_seconds)
    ? 0 : release_rest_seconds;
wb_radius_observation_finished_radius_mm =
    is_undef(measured_finished_inside_radius_mm)
        ? 0 : measured_finished_inside_radius_mm;
wb_radius_observation_measurement_method = is_undef(measurement_method)
    ? "" : measurement_method;
wb_radius_observation_measured_date = is_undef(measured_date)
    ? "" : measured_date;
wb_radius_observation_measurement_uncertainty_mm =
    is_undef(measurement_uncertainty_mm)
        ? 0 : measurement_uncertainty_mm;
wb_radius_observation_notes = is_undef(observation_notes)
    ? "" : observation_notes;

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
