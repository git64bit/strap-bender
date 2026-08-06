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
    ),
    project_spec(
        name = "VERTEX_POLYGON_LAB",
        kind = "vertex_polygon",
        status = "laboratory",
        notes = str(
            "Mutable ordered-vertex polygon laboratory. It derives circular ",
            "tangent corners and retained straight lengths, then normalizes ",
            "the result to the shared bend-program and analytical-path route."
        )
    )
];
