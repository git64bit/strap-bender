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
            "Mutable report-only bend-program scaffold. It validates native ",
            "straight, bend, pose, and shape records before the analytical ",
            "path kernel is introduced."
        )
    )
];
