//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_projects.scad
// Project: Strap Bender
// FileGroup: Laboratory Registry
// FileSummary: Registers mutable Strap Bender development projects.
//////////////////////////////////////////////////////////////////////

LABORATORY_PROJECTS = [
    project_spec(
        name = "BEND_PROGRAM_LAB",
        kind = "bend_program",
        status = "laboratory",
        notes = str(
            "Mutable explicit bend-program laboratory. It validates source ",
            "records and compiles them to exact finished-inside-edge line and ",
            "circular-arc analytical primitives."
        )
    )
];
