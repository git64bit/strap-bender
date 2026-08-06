//////////////////////////////////////////////////////////////////////
// LibFile: workbench_registry_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies exact-name project, program, and workbench routing.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_projects.scad>
include <../registries/catalog_projects.scad>
include <../registries/laboratory_bend_programs.scad>
include <../config/workbenches.scad>

all_projects = concat(LABORATORY_PROJECTS, CATALOG_PROJECTS);
lab_project = named_record(all_projects, "BEND_PROGRAM_LAB", "project");
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

validate_project(lab_project);
validate_project(catalog_project);
validate_bend_program_shape(small_program);
validate_bend_program_shape(scale_program);

assert(len(records_named(all_projects, "BEND_PROGRAM_LAB")) == 1,
    "Laboratory project registry exact-name contract failed.");
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
assert(workbench_name_valid("bend_program"),
    "Bend Program workbench must be registered.");
assert(workbench_render_mode_allowed("bend_program", "report_only"),
    "Bend Program report-only route must be allowed.");
assert(!workbench_render_mode_allowed("bend_program", "fixture"),
    "Unimplemented geometry modes must remain rejected.");

assert(len(shape_commands(scale_program)) == 73,
    "Registry must preserve the arbitrary-length command list.");

echo("STRAP BENDER WORKBENCH REGISTRY CONTRACT: PASS");
