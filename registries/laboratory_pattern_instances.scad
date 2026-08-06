//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_pattern_instances.scad
// Project: Strap Bender
// FileGroup: Laboratory Pattern Registry
// FileSummary: Registers mutable repeated-pattern instances.
//////////////////////////////////////////////////////////////////////

LABORATORY_PATTERN_INSTANCES = [
    pattern_instance_spec(
        name = "THIRTY_WAVE_EVERY_THIRD_R5",
        pattern_name = "THREE_SEGMENT_S_WAVE",
        repeat_count = 30,
        parameters = [
            pattern_parameter_spec(
                "base_segment_mm",
                value_schedule_constant(50, "50 mm base segments")
            ),
            pattern_parameter_spec(
                "rising_segment_mm",
                value_schedule_constant(50, "50 mm rising segments")
            ),
            pattern_parameter_spec(
                "falling_segment_mm",
                value_schedule_constant(50, "50 mm falling segments")
            ),
            pattern_parameter_spec(
                "turn_angle_degrees",
                value_schedule_constant(45, "45 degree wave angle")
            ),
            pattern_parameter_spec(
                "inside_radius_mm",
                value_schedule_every_nth(
                    default_value = 1.6,
                    selected_value = 5,
                    interval = 3,
                    first_position = 3,
                    label = "Every third wave uses R5"
                )
            )
        ],
        closure = "open",
        start_pose = start_pose_spec(0, 0, 0),
        notes = str(
            "Thirty complete waves and 180 normalized commands. Every third ",
            "wave assigns 5 mm finished inside radius to all three bends in ",
            "that wave; all other waves use 1.6 mm. The finished-inside-edge ",
            "analytical path is approximately 15.6 feet long."
        )
    ),
    pattern_instance_spec(
        name = "SIX_WAVE_VARIABLE_SEGMENTS",
        pattern_name = "THREE_SEGMENT_S_WAVE",
        repeat_count = 6,
        parameters = [
            pattern_parameter_spec(
                "base_segment_mm",
                value_schedule_explicit([40, 45, 50, 55, 60, 65])
            ),
            pattern_parameter_spec(
                "rising_segment_mm",
                value_schedule_explicit([55, 50, 45, 60, 50, 40])
            ),
            pattern_parameter_spec(
                "falling_segment_mm",
                value_schedule_explicit([45, 55, 60, 40, 50, 65])
            ),
            pattern_parameter_spec(
                "turn_angle_degrees",
                value_schedule_periodic([35, 45, 55])
            ),
            pattern_parameter_spec(
                "inside_radius_mm",
                value_schedule_periodic([1.6, 1.6, 5])
            )
        ],
        closure = "open",
        start_pose = start_pose_spec(0, 0, 0),
        notes = str(
            "Six-wave Laboratory example proving that every straight family, ",
            "wave angle, and wave radius may use an independent compact or ",
            "explicit schedule without exposing one Customizer field per bend."
        )
    )
];
