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

validate_project(lab_project);
validate_project(polygon_project);
validate_project(regular_project);
validate_project(catalog_project);
validate_bend_program_shape(small_program);
validate_bend_program_shape(scale_program);
validate_vertex_polygon(rounded_square);
validate_vertex_polygon(concave_l);
validate_regular_polygon(regular_triangle);
validate_regular_polygon(regular_square);
validate_regular_polygon(regular_pentagon);

assert(len(records_named(all_projects, "BEND_PROGRAM_LAB")) == 1,
    "Laboratory project registry exact-name contract failed.");
assert(len(records_named(all_projects, "VERTEX_POLYGON_LAB")) == 1,
    "Vertex-polygon project registry exact-name contract failed.");
assert(len(records_named(all_projects, "REGULAR_POLYGON_LAB")) == 1,
    "Regular-polygon project registry exact-name contract failed.");
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
assert(workbench_name_valid("bend_program"),
    "Bend Program workbench must be registered.");
assert(workbench_name_valid("vertex_polygon"),
    "Vertex Polygon workbench must be registered.");
assert(workbench_name_valid("regular_polygon"),
    "Regular Polygon workbench must be registered.");
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
assert(!workbench_render_mode_allowed("catalog", "diagnostic_path"),
    "Catalog must reject mutable diagnostic rendering routes.");
assert(!workbench_render_mode_allowed("regular_polygon", "fixture"),
    "Unimplemented regular-polygon fixture modes must remain rejected.");
assert(len(shape_commands(scale_program)) == 73,
    "Registry must preserve the arbitrary-length command list.");

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

echo("STRAP BENDER WORKBENCH REGISTRY CONTRACT: PASS");
