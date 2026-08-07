
//////////////////////////////////////////////////////////////////////
// LibFile: material_accessors.scad
// Project: Strap Bender
// FileGroup: Strap Material Data Model
// FileSummary: Named accessors for physical strap product records.
//////////////////////////////////////////////////////////////////////

function strap_material_name(material) = material[MT_NAME];
function strap_material_manufacturer(material) = material[MT_MANUFACTURER];
function strap_material_product_number(material) = material[MT_PRODUCT_NUMBER];
function strap_material_family(material) = material[MT_MATERIAL_FAMILY];
function strap_material_nominal_width_mm(material) =
    material[MT_NOMINAL_WIDTH_MM];
function strap_material_nominal_thickness_mm(material) =
    material[MT_NOMINAL_THICKNESS_MM];
function strap_material_nominal_break_strength_n(material) =
    material[MT_NOMINAL_BREAK_STRENGTH_N];
function strap_material_nominal_coil_length_mm(material) =
    material[MT_NOMINAL_COIL_LENGTH_MM];
function strap_material_color(material) = material[MT_COLOR];
function strap_material_surface(material) = material[MT_SURFACE];
function strap_material_recycled_content_percent(material) =
    material[MT_RECYCLED_CONTENT_PERCENT];
function strap_material_source_title(material) = material[MT_SOURCE_TITLE];
function strap_material_source_checked_date(material) =
    material[MT_SOURCE_CHECKED_DATE];
function strap_material_source_locator(material) =
    material[MT_SOURCE_LOCATOR];
function strap_material_notes(material) = material[MT_NOTES];

function strap_material_nominal_width_in(material) =
    sb_mm_to_inches(strap_material_nominal_width_mm(material));
function strap_material_nominal_thickness_in(material) =
    sb_mm_to_inches(strap_material_nominal_thickness_mm(material));
function strap_material_nominal_break_strength_lbf(material) =
    sb_newtons_to_pounds_force(
        strap_material_nominal_break_strength_n(material)
    );
function strap_material_nominal_coil_length_ft(material) =
    sb_mm_to_feet(strap_material_nominal_coil_length_mm(material));
