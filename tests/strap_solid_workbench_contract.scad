//////////////////////////////////////////////////////////////////////
// LibFile: strap_solid_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies strap-solid routing and material availability.
//////////////////////////////////////////////////////////////////////

polygon_name_selected = "ROUNDED_SQUARE_EXAMPLE";
strap_material_name_selected = "ULINE_S_1655_BLACK";
show_strap_solid = true;
show_diagnostic_preview = false;
show_bend_post_fixture = false;
cut_plan_enabled = false;
manufacturing_manifest_enabled = false;
project_name_selected = "VERTEX_POLYGON_LAB";
workbench_name = "vertex_polygon";
render_mode = "strap_solid";
report_level = "summary";

include <../main.scad>

assert(wb_strap_solid_enabled,
    "Strap-solid workbench flag did not resolve true.");
assert(wb_render_mode == "strap_solid",
    "Strap-solid-only workbench must use the strap_solid render mode.");
assert(len(STRAP_MATERIALS) == 1,
    "Strap-solid routing must expose the strap-material registry.");

echo("STRAP BENDER STRAP SOLID WORKBENCH CONTRACT: PASS");
