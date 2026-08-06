//////////////////////////////////////////////////////////////////////
// LibFile: standard_patterns.scad
// Project: Strap Bender
// FileGroup: Reusable Pattern Definitions
// FileSummary: Defines compact command topologies shared by pattern instances.
//////////////////////////////////////////////////////////////////////

STANDARD_PATTERN_BLOCKS = [
    pattern_block_spec(
        name = "THREE_SEGMENT_S_WAVE",
        elements = [
            pattern_straight_element(
                "base_segment_mm",
                "BASE_STRAIGHT"
            ),
            pattern_bend_element(
                "turn_angle_degrees",
                "inside_radius_mm",
                1,
                "RISE_BEND"
            ),
            pattern_straight_element(
                "rising_segment_mm",
                "RISING_STRAIGHT"
            ),
            pattern_bend_element(
                "turn_angle_degrees",
                "inside_radius_mm",
                -2,
                "REVERSING_BEND"
            ),
            pattern_straight_element(
                "falling_segment_mm",
                "FALLING_STRAIGHT"
            ),
            pattern_bend_element(
                "turn_angle_degrees",
                "inside_radius_mm",
                1,
                "LEVELING_BEND"
            )
        ],
        notes = str(
            "One complete S-wave period. The three bend angles are +A, -2A, ",
            "and +A, so every repetition ends at its starting heading. ",
            "All three bends in one repetition consume the same per-wave ",
            "inside-radius parameter. The three straight parameters are ",
            "independent and may use different schedules."
        )
    )
];
