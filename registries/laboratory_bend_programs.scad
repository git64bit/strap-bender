//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_bend_programs.scad
// Project: Strap Bender
// FileGroup: Laboratory Bend-Program Registry
// FileSummary: Registers mutable arbitrary-length bend-program records.
//////////////////////////////////////////////////////////////////////

function sb_scale_example_commands(bend_count = 36) = [
    for (source_index = [0 : bend_count * 2])
        source_index % 2 == 0
            ? straight_command(
                source_index = source_index,
                distance = 50 +
                    (floor(source_index / 2) % 4) * 10,
                label = str("S", floor(source_index / 2))
            )
            : bend_command(
                source_index = source_index,
                angle_degrees =
                    floor(source_index / 2) % 2 == 0
                        ? 45 : -45,
                inside_radius =
                    (floor(source_index / 2) + 1) % 3 == 0
                        ? 5 : 1.6,
                label = str("B", floor(source_index / 2))
            )
];

LABORATORY_BEND_PROGRAMS = [
    bend_program_shape_spec(
        name = "OPEN_MIXED_RADIUS_EXAMPLE",
        commands = [
            straight_command(0, 120, "S0"),
            bend_command(1, 90, 1.6, "B0"),
            straight_command(2, 75, "S1"),
            bend_command(3, -45, 5, "B1"),
            straight_command(4, 40, "S2")
        ],
        closure = "open",
        start_pose = start_pose_spec(0, 0, 0),
        notes = str(
            "Small mutable Laboratory example. The executable workbench ",
            "selects this complete record instead of exposing one Customizer ",
            "section per bend."
        )
    ),
    bend_program_shape_spec(
        name = "THIRTY_SIX_BEND_SCALE_EXAMPLE",
        commands = sb_scale_example_commands(36),
        closure = "open",
        start_pose = start_pose_spec(0, 0, 0),
        notes = str(
            "Synthetic arbitrary-length record containing 36 bends and 37 ",
            "straights. Every third bend uses a 5 mm finished inside radius; ",
            "the others use 1.6 mm. This proves record and routing scale only. ",
            "The compact pattern front end remains future work."
        )
    )
];
