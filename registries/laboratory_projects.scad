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
    ),
    project_spec(
        name = "REGULAR_POLYGON_LAB",
        kind = "regular_polygon",
        status = "laboratory",
        notes = str(
            "Mutable regular-polygon laboratory. It resolves one governing ",
            "sharp dimension, generates ordered vertices, then enters the ",
            "shared vertex-polygon and analytical-path pipeline."
        )
    ),
    project_spec(
        name = "STRAP_PROFILE_LAB",
        kind = "strap_material",
        status = "laboratory",
        notes = str(
            "Mutable physical-strap identity laboratory. It validates ",
            "and reports exact vendor nominal product data without ",
            "claiming measured dimensions or forming calibration."
        )
    ),
    project_spec(
        name = "WAVE_PATTERN_LAB",
        kind = "pattern",
        status = "laboratory",
        notes = str(
            "Mutable repeated-wave laboratory. It resolves one value per ",
            "repetition for independent straight, angle, and radius ",
            "parameters, expands the named topology, and enters the shared ",
            "bend-program and analytical-path pipeline."
        )
    ),
    project_spec(
        name = "RADIUS_CALIBRATION_LAB",
        kind = "radius_calibration",
        status = "laboratory",
        notes = str(
            "Mutable experimental calibration-tool laboratory. It renders ",
            "one open inside-form coupon with a known designed tool radius ",
            "and bend angle so physical observations can be collected ",
            "without asserting a springback compensation law."
        )
    ),
    project_spec(
        name = "RADIUS_OBSERVATION_LAB",
        kind = "calibration_trial",
        status = "laboratory",
        notes = str(
            "Guarded physical-observation worksheet. A ready trial links ",
            "one measured radius observation to one exact named calibration ",
            "coupon and verifies material, tool radius, and bend angle."
        )
    )
];
