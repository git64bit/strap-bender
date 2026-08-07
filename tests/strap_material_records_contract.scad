
//////////////////////////////////////////////////////////////////////
// LibFile: strap_material_records_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies the exact ULINE S-1655 nominal product record.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>

material = named_record(
    LABORATORY_STRAP_MATERIALS,
    "ULINE_S_1655_BLACK",
    "strap material"
);

validate_strap_material(material);
report_strap_material(material, "full");

assert(len(LABORATORY_STRAP_MATERIALS) == 1,
    "Batch 009 must register exactly one confirmed strap product.");
assert(strap_material_manufacturer(material) == "ULINE" &&
    strap_material_product_number(material) == "S-1655",
    "ULINE S-1655 identity contract failed.");
assert(abs(strap_material_nominal_width_mm(material) - 15.875) < 1e-9,
    "Five-eighth-inch nominal width conversion failed.");
assert(abs(strap_material_nominal_thickness_mm(material) - 0.508) < 1e-9,
    ".020-inch nominal thickness conversion failed.");
assert(abs(strap_material_nominal_break_strength_lbf(material) - 750) <
    1e-9,
    "Seven-hundred-fifty-pound nominal break-strength conversion failed.");
assert(abs(strap_material_nominal_coil_length_ft(material) - 2850) < 1e-9,
    "Two-thousand-eight-hundred-fifty-foot coil conversion failed.");
assert(strap_material_color(material) == "black" &&
    strap_material_surface(material) == "smooth",
    "ULINE S-1655 color or surface contract failed.");
assert(strap_material_recycled_content_percent(material) == 100,
    "ULINE S-1655 recycled-content contract failed.");
assert(strap_material_source_locator(material) == str(
        "https://www.uline.com/Product/Detail/S-1655/",
        "Polyester-Strapping/Uline-Polyester-Strapping-",
        "5-8-x-020-x-2850-Black"
    ),
    "ULINE S-1655 source-locator contract failed.");
assert(len(records_named(
        LABORATORY_STRAP_MATERIALS,
        "ULINE_S_1655_BLACK"
    )) == 1,
    "Strap material exact-name registry contract failed.");

echo("STRAP BENDER STRAP MATERIAL RECORDS CONTRACT: PASS");
