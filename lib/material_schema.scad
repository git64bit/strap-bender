
//////////////////////////////////////////////////////////////////////
// LibFile: material_schema.scad
// Project: Strap Bender
// FileGroup: Strap Material Data Model
// FileSummary: Constructor and unit helpers for physical strap products.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_STRAP_MATERIAL_RECORD = "strap_bender_strap_material";

SB_MATERIAL_MM_PER_INCH = 25.4;
SB_MATERIAL_MM_PER_FOOT = 304.8;
SB_MATERIAL_NEWTONS_PER_POUND_FORCE = 4.4482216152605;

function sb_inches_to_mm(value) = value * SB_MATERIAL_MM_PER_INCH;
function sb_feet_to_mm(value) = value * SB_MATERIAL_MM_PER_FOOT;
function sb_pounds_force_to_newtons(value) =
    value * SB_MATERIAL_NEWTONS_PER_POUND_FORCE;
function sb_mm_to_inches(value) = value / SB_MATERIAL_MM_PER_INCH;
function sb_mm_to_feet(value) = value / SB_MATERIAL_MM_PER_FOOT;
function sb_newtons_to_pounds_force(value) =
    value / SB_MATERIAL_NEWTONS_PER_POUND_FORCE;

function strap_material_spec(
    name,
    manufacturer,
    product_number,
    material_family,
    nominal_width_mm,
    nominal_thickness_mm,
    nominal_break_strength_n,
    nominal_coil_length_mm,
    color,
    surface,
    recycled_content_percent,
    source_title,
    source_checked_date,
    source_locator,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_STRAP_MATERIAL_RECORD,
    schema_version,
    name,
    manufacturer,
    product_number,
    material_family,
    nominal_width_mm,
    nominal_thickness_mm,
    nominal_break_strength_n,
    nominal_coil_length_mm,
    color,
    surface,
    recycled_content_percent,
    source_title,
    source_checked_date,
    source_locator,
    notes
];
