//////////////////////////////////////////////////////////////////////
// LibFile: fixture_material_routing_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Proves every bend-post fixture route receives strap materials.
//////////////////////////////////////////////////////////////////////

workbench_name = "vertex_polygon";
render_mode = "bend_post_fixture";

include <../strap_bender.scad>
include <../config/defaults.scad>
include <../registries/laboratory_strap_materials.scad>
include <../config/materials.scad>

assert(len(records_named(
        STRAP_MATERIALS,
        "ULINE_S_1655_BLACK"
    )) == 1,
    "Bend-post fixture routes must expose ULINE_S_1655_BLACK exactly once.");

fixture_material = named_record(
    STRAP_MATERIALS,
    "ULINE_S_1655_BLACK",
    "strap material"
);
validate_strap_material(fixture_material);

assert(strap_material_name(fixture_material) == "ULINE_S_1655_BLACK",
    "Fixture material routing returned the wrong material.");

echo("STRAP BENDER FIXTURE MATERIAL ROUTING CONTRACT: PASS");
