//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_workbench_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes packaging without cut-plan display or fixture rendering.
//////////////////////////////////////////////////////////////////////

polygon_name_selected = "ROUNDED_SQUARE_EXAMPLE";
strap_material_name_selected = "ULINE_S_1655_BLACK";
cut_plan_enabled = false;
manufacturing_manifest_enabled = true;
manufacturing_object_name = "WORKBENCH_SQUARE_PACKAGE";
manufacturing_revision = 4;
manufacturing_source_commit = "";
manufacturing_slicer_project_file = "";
project_name_selected = "VERTEX_POLYGON_LAB";
workbench_name = "vertex_polygon";
render_mode = "report_only";
report_level = "summary";

include <../main.scad>

assert(!wb_cut_plan_enabled && wb_manufacturing_manifest_enabled,
    "Manufacturing package must be independently enabled from cut-plan display.");
assert(len(STRAP_MATERIALS) == 1,
    "Manufacturing package routing must expose the strap-material registry.");
assert(wb_manufacturing_object_name == "WORKBENCH_SQUARE_PACKAGE" &&
    wb_manufacturing_revision == 4,
    "Manufacturing workbench candidate identity routing failed.");

echo("STRAP BENDER MANUFACTURING WORKBENCH CONTRACT: PASS");
