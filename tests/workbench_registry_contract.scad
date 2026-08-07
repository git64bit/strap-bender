//////////////////////////////////////////////////////////////////////
// LibFile: workbench_registry_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies exact-name project, source, and workbench routing.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_projects.scad>
include <../registries/catalog_projects.scad>
include <../registries/laboratory_bend_programs.scad>
include <../registries/laboratory_vertex_polygons.scad>
include <../registries/laboratory_regular_polygons.scad>
include <../patterns/standard_patterns.scad>
include <../registries/laboratory_pattern_instances.scad>
include <../registries/laboratory_strap_materials.scad>
include <../registries/laboratory_radius_coupons.scad>
include <../config/workbenches.scad>

all_projects = concat(LABORATORY_PROJECTS, CATALOG_PROJECTS);
lab_project = named_record(all_projects, "BEND_PROGRAM_LAB", "project");
polygon_project = named_record(
    all_projects,
    "VERTEX_POLYGON_LAB",
    "project"
);
regular_project = named_record(
    all_projects,
    "REGULAR_POLYGON_LAB",
    "project"
);
pattern_project = named_record(
    all_projects,
    "WAVE_PATTERN_LAB",
    "project"
);
strap_project = named_record(
    all_projects,
    "STRAP_PROFILE_LAB",
    "project"
);
radius_calibration_project = named_record(
    all_projects,
    "RADIUS_CALIBRATION_LAB",
    "project"
);
radius_observation_project = named_record(
    all_projects,
    "RADIUS_OBSERVATION_LAB",
    "project"
);
calibration_evidence_project = named_record(
    all_projects,
    "CALIBRATION_EVIDENCE_LAB",
    "project"
);
catalog_project = named_record(
    all_projects,
    "CATALOG_WORKBENCH_STUB",
    "project"
);
small_program = named_record(
    LABORATORY_BEND_PROGRAMS,
    "OPEN_MIXED_RADIUS_EXAMPLE",
    "bend program"
);
scale_program = named_record(
    LABORATORY_BEND_PROGRAMS,
    "THIRTY_SIX_BEND_SCALE_EXAMPLE",
    "bend program"
);
rounded_square = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "ROUNDED_SQUARE_EXAMPLE",
    "vertex polygon"
);
concave_l = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "CONCAVE_L_EXAMPLE",
    "vertex polygon"
);
regular_triangle = named_record(
    LABORATORY_REGULAR_POLYGONS,
    "REGULAR_TRIANGLE_SIDE_100_R5",
    "regular polygon"
);
regular_square = named_record(
    LABORATORY_REGULAR_POLYGONS,
    "REGULAR_SQUARE_APOTHEM_50_R10",
    "regular polygon"
);
regular_pentagon = named_record(
    LABORATORY_REGULAR_POLYGONS,
    "REGULAR_PENTAGON_CIRCUMRADIUS_60_MIXED",
    "regular polygon"
);
regular_nonagon = named_record(
    LABORATORY_REGULAR_POLYGONS,
    "REGULAR_NONAGON_EVERY_THIRD_R5",
    "regular polygon"
);
wave_pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
long_wave = named_record(
    LABORATORY_PATTERN_INSTANCES,
    "THIRTY_WAVE_EVERY_THIRD_R5",
    "pattern instance"
);
variable_wave = named_record(
    LABORATORY_PATTERN_INSTANCES,
    "SIX_WAVE_VARIABLE_SEGMENTS",
    "pattern instance"
);
strap_material = named_record(
    LABORATORY_STRAP_MATERIALS,
    "ULINE_S_1655_BLACK",
    "strap material"
);
radius_coupon = named_record(
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "radius calibration coupon"
);

validate_project(lab_project);
validate_project(polygon_project);
validate_project(regular_project);
validate_project(pattern_project);
validate_project(strap_project);
validate_project(radius_calibration_project);
validate_project(radius_observation_project);
validate_project(calibration_evidence_project);
validate_project(catalog_project);
validate_bend_program_shape(small_program);
validate_bend_program_shape(scale_program);
validate_vertex_polygon(rounded_square);
validate_vertex_polygon(concave_l);
validate_regular_polygon(regular_triangle);
validate_regular_polygon(regular_square);
validate_regular_polygon(regular_pentagon);
validate_regular_polygon(regular_nonagon);
validate_pattern_block(wave_pattern);
validate_pattern_instance(long_wave, wave_pattern);
validate_pattern_instance(variable_wave, wave_pattern);
validate_strap_material(strap_material);
validate_radius_calibration_coupon(
    radius_coupon,
    LABORATORY_STRAP_MATERIALS
);

assert(len(records_named(all_projects, "BEND_PROGRAM_LAB")) == 1,
    "Laboratory project registry exact-name contract failed.");
assert(len(records_named(all_projects, "VERTEX_POLYGON_LAB")) == 1,
    "Vertex-polygon project registry exact-name contract failed.");
assert(len(records_named(all_projects, "REGULAR_POLYGON_LAB")) == 1,
    "Regular-polygon project registry exact-name contract failed.");
assert(len(records_named(all_projects, "WAVE_PATTERN_LAB")) == 1,
    "Wave-pattern project registry exact-name contract failed.");
assert(len(records_named(all_projects, "STRAP_PROFILE_LAB")) == 1,
    "Strap-profile project registry exact-name contract failed.");
assert(len(records_named(
        all_projects,
        "CALIBRATION_EVIDENCE_LAB"
    )) == 1,
    "Calibration-evidence project registry exact-name contract failed.");
assert(len(records_named(all_projects, "RADIUS_CALIBRATION_LAB")) == 1,
    "Radius-calibration project registry exact-name contract failed.");
assert(len(records_named(all_projects, "CATALOG_WORKBENCH_STUB")) == 1,
    "Catalog project registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_BEND_PROGRAMS,
        "OPEN_MIXED_RADIUS_EXAMPLE"
    )) == 1,
    "Small bend-program registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_BEND_PROGRAMS,
        "THIRTY_SIX_BEND_SCALE_EXAMPLE"
    )) == 1,
    "Scale bend-program registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_VERTEX_POLYGONS,
        "ROUNDED_SQUARE_EXAMPLE"
    )) == 1,
    "Rounded-square polygon registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_VERTEX_POLYGONS,
        "CONCAVE_L_EXAMPLE"
    )) == 1,
    "Concave polygon registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_REGULAR_POLYGONS,
        "REGULAR_TRIANGLE_SIDE_100_R5"
    )) == 1,
    "Regular-triangle registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_REGULAR_POLYGONS,
        "REGULAR_SQUARE_APOTHEM_50_R10"
    )) == 1,
    "Regular-square registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_REGULAR_POLYGONS,
        "REGULAR_PENTAGON_CIRCUMRADIUS_60_MIXED"
    )) == 1,
    "Regular-pentagon registry exact-name contract failed.");
assert(len(records_named(
        LABORATORY_REGULAR_POLYGONS,
        "REGULAR_NONAGON_EVERY_THIRD_R5"
    )) == 1,
    "Scheduled nonagon registry exact-name contract failed.");
assert(sb_regular_polygon_resolved_corner_radii(regular_nonagon) ==
    [1.6, 1.6, 5, 1.6, 1.6, 5, 1.6, 1.6, 5],
    "Scheduled nonagon registry must preserve every-third radii.");
assert(len(records_named(
        STANDARD_PATTERN_BLOCKS,
        "THREE_SEGMENT_S_WAVE"
    )) == 1,
    "Standard wave-pattern exact-name contract failed.");
assert(len(records_named(
        LABORATORY_PATTERN_INSTANCES,
        "THIRTY_WAVE_EVERY_THIRD_R5"
    )) == 1,
    "Long-wave instance exact-name contract failed.");
assert(len(records_named(
        LABORATORY_PATTERN_INSTANCES,
        "SIX_WAVE_VARIABLE_SEGMENTS"
    )) == 1,
    "Variable-wave instance exact-name contract failed.");
assert(workbench_name_valid("bend_program"),
    "Bend Program workbench must be registered.");
assert(workbench_name_valid("vertex_polygon"),
    "Vertex Polygon workbench must be registered.");
assert(workbench_name_valid("regular_polygon"),
    "Regular Polygon workbench must be registered.");
assert(workbench_name_valid("wave_pattern"),
    "Wave Pattern workbench must be registered.");
assert(workbench_name_valid("strap_profile"),
    "Strap Profile workbench must be registered.");
assert(workbench_name_valid("radius_calibration"),
    "Radius Calibration workbench must be registered.");
assert(workbench_name_valid("radius_observation"),
    "Radius Observation workbench must be registered.");
assert(workbench_name_valid("calibration_evidence"),
    "Calibration Evidence workbench must be registered.");
assert(workbench_render_mode_allowed("bend_program", "report_only"),
    "Bend Program report-only route must be allowed.");
assert(workbench_render_mode_allowed("bend_program", "diagnostic_path"),
    "Bend Program diagnostic-path route must be allowed.");
assert(workbench_render_mode_allowed("vertex_polygon", "report_only"),
    "Vertex Polygon report-only route must be allowed.");
assert(workbench_render_mode_allowed("vertex_polygon", "diagnostic_path"),
    "Vertex Polygon diagnostic-path route must be allowed.");
assert(workbench_render_mode_allowed("regular_polygon", "report_only"),
    "Regular Polygon report-only route must be allowed.");
assert(workbench_render_mode_allowed("regular_polygon", "diagnostic_path"),
    "Regular Polygon diagnostic-path route must be allowed.");
assert(workbench_render_mode_allowed("wave_pattern", "report_only"),
    "Wave Pattern report-only route must be allowed.");
assert(workbench_render_mode_allowed("wave_pattern", "diagnostic_path"),
    "Wave Pattern diagnostic-path route must be allowed.");
assert(workbench_render_mode_allowed("bend_program", "bend_post_fixture"),
    "Bend Program bend-post fixture route must be allowed.");
assert(workbench_render_mode_allowed("vertex_polygon", "bend_post_fixture"),
    "Vertex Polygon bend-post fixture route must be allowed.");
assert(workbench_render_mode_allowed("regular_polygon", "bend_post_fixture"),
    "Regular Polygon bend-post fixture route must be allowed.");
assert(workbench_render_mode_allowed("wave_pattern", "bend_post_fixture"),
    "Wave Pattern bend-post fixture route must be allowed.");
assert(workbench_render_mode_allowed("calibration_evidence", "report_only"),
    "Calibration Evidence report-only route must be allowed.");
assert(!workbench_render_mode_allowed(
        "calibration_evidence",
        "diagnostic_path"
    ),
    "Calibration Evidence must reject geometry rendering routes.");
assert(!workbench_render_mode_allowed("catalog", "diagnostic_path"),
    "Catalog must reject mutable diagnostic rendering routes.");
assert(!workbench_render_mode_allowed("regular_polygon", "fixture"),
    "Unimplemented regular-polygon fixture modes must remain rejected.");
assert(len(shape_commands(scale_program)) == 73,
    "Registry must preserve the arbitrary-length command list.");
long_wave_compilation = compile_pattern_instance(long_wave, wave_pattern);
assert(len(shape_commands(pattern_compilation_normalized_shape(
    long_wave_compilation
))) == 180,
    "Registry must preserve compact thirty-wave expansion intent.");

regular_square_compilation = compile_regular_polygon(regular_square);
validate_regular_polygon_compilation(
    regular_square_compilation,
    regular_square
);
assert(sb_point_lists_near(
    regular_polygon_compilation_vertices(regular_square_compilation),
    vertex_polygon_vertices(rounded_square),
    0.000001
), "Regular-square registry source must match the explicit square vertices.");

assert(len(records_named(
        LABORATORY_STRAP_MATERIALS,
        "ULINE_S_1655_BLACK"
    )) == 1,
    "ULINE strap material exact-name contract failed.");
assert(workbench_render_mode_allowed("strap_profile", "report_only"),
    "Strap Profile report-only route must be allowed.");
assert(!workbench_render_mode_allowed(
        "strap_profile",
        "diagnostic_path"
    ),
    "Strap Profile must not allow a geometry render route.");
assert(workbench_render_mode_allowed(
        "radius_calibration",
        "calibration_coupon"
    ),
    "Radius Calibration must allow printable coupon rendering.");
assert(workbench_render_mode_allowed(
        "radius_calibration",
        "report_only"
    ),
    "Radius Calibration must allow report-only routing.");
assert(!workbench_render_mode_allowed(
        "radius_calibration",
        "diagnostic_path"
    ),
    "Radius Calibration must reject diagnostic-path rendering.");
assert(workbench_render_mode_allowed(
        "radius_observation",
        "report_only"
    ),
    "Radius Observation must allow report-only routing.");
assert(!workbench_render_mode_allowed(
        "radius_observation",
        "diagnostic_path"
    ),
    "Radius Observation must reject geometry rendering.");
assert(len(records_named(
        LABORATORY_RADIUS_CALIBRATION_COUPONS,
        "ULINE_R90_TOOL_R1_6_EXPERIMENTAL"
    )) == 1,
    "Radius-coupon registry exact-name contract failed.");

echo("STRAP BENDER WORKBENCH REGISTRY CONTRACT: PASS");
