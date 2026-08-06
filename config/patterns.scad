//////////////////////////////////////////////////////////////////////
// LibFile: patterns.scad
// Project: Strap Bender
// FileGroup: Pattern Router
// FileSummary: Builds and exposes the active repeated-wave source.
//////////////////////////////////////////////////////////////////////

function sb_workbench_sequence_source(mode, values, label) =
    assert(is_list(values) && len(values) > 0,
        str(label, " requires at least one numeric value."))
    mode == "constant"
        ? value_schedule_constant(values[0], label)
        : mode == "periodic"
            ? value_schedule_periodic(values, label)
            : mode == "explicit"
                ? value_schedule_explicit(values, label)
                : assert(false, str(
                    "Unsupported pattern sequence mode: ", mode
                )) undef;

function sb_workbench_wave_radius_source() =
    wb_wave_radius_mode == "constant"
        ? value_schedule_constant(
            wb_wave_default_radius_mm,
            "Customizer constant wave radius"
        )
        : wb_wave_radius_mode == "periodic"
            ? value_schedule_periodic(
                wb_wave_radius_cycle_mm,
                "Customizer periodic wave radii"
            )
            : wb_wave_radius_mode == "every_nth"
                ? value_schedule_every_nth(
                    default_value = wb_wave_default_radius_mm,
                    selected_value = wb_wave_selected_radius_mm,
                    interval = wb_wave_radius_interval,
                    first_position = wb_wave_radius_first_position,
                    label = "Customizer every-nth wave radius"
                )
                : assert(false, str(
                    "Unsupported wave radius mode: ",
                    wb_wave_radius_mode
                )) undef;

WORKBENCH_PATTERN_INSTANCE = pattern_instance_spec(
    name = wb_pattern_instance_name,
    pattern_name = "THREE_SEGMENT_S_WAVE",
    repeat_count = wb_wave_count,
    parameters = [
        pattern_parameter_spec(
            "base_segment_mm",
            sb_workbench_sequence_source(
                wb_wave_segment_schedule_mode,
                wb_wave_base_segment_lengths_mm,
                "Base-segment schedule"
            )
        ),
        pattern_parameter_spec(
            "rising_segment_mm",
            sb_workbench_sequence_source(
                wb_wave_segment_schedule_mode,
                wb_wave_rising_segment_lengths_mm,
                "Rising-segment schedule"
            )
        ),
        pattern_parameter_spec(
            "falling_segment_mm",
            sb_workbench_sequence_source(
                wb_wave_segment_schedule_mode,
                wb_wave_falling_segment_lengths_mm,
                "Falling-segment schedule"
            )
        ),
        pattern_parameter_spec(
            "turn_angle_degrees",
            value_schedule_constant(
                wb_wave_turn_angle_degrees,
                "Customizer wave turn angle"
            )
        ),
        pattern_parameter_spec(
            "inside_radius_mm",
            sb_workbench_wave_radius_source()
        )
    ],
    closure = "open",
    start_pose = start_pose_spec(0, 0, 0),
    notes = str(
        "Mutable Customizer S-wave instance. Segment mode is ",
        wb_wave_segment_schedule_mode,
        "; radius mode is ", wb_wave_radius_mode,
        ". Schedules resolve once per wave, not once per bend."
    )
);

PATTERN_BLOCKS = STANDARD_PATTERN_BLOCKS;
PATTERN_INSTANCES =
    wb_workbench_name == "wave_pattern"
        ? [WORKBENCH_PATTERN_INSTANCE]
        : wb_workbench_name == "development"
            ? LABORATORY_PATTERN_INSTANCES
            : [];
