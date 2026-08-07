
//////////////////////////////////////////////////////////////////////
// LibFile: material_validation.scad
// Project: Strap Bender
// FileGroup: Strap Material Validation
// FileSummary: Validates physical strap product records.
//////////////////////////////////////////////////////////////////////

module validate_strap_material(material) {
    assert(is_list(material) && len(material) == 17,
        "Strap material records must contain seventeen fields.");
    assert(material[MT_RECORD_TYPE] ==
        STRAP_BENDER_STRAP_MATERIAL_RECORD,
        "Invalid Strap Bender strap material record type.");
    assert(sb_schema_version_valid(material[MT_SCHEMA_VERSION]),
        str("Unsupported strap material schema version: ",
            material[MT_SCHEMA_VERSION]));
    assert(sb_nonempty_string(strap_material_name(material)),
        "Strap material name must be a non-empty string.");
    assert(sb_nonempty_string(strap_material_manufacturer(material)),
        "Strap material manufacturer must be a non-empty string.");
    assert(sb_nonempty_string(strap_material_product_number(material)),
        "Strap material product number must be a non-empty string.");
    assert(sb_nonempty_string(strap_material_family(material)),
        "Strap material family must be a non-empty string.");
    assert(sb_finite_number(strap_material_nominal_width_mm(material)) &&
        strap_material_nominal_width_mm(material) > 0,
        "Nominal strap width must be finite and greater than zero.");
    assert(sb_finite_number(strap_material_nominal_thickness_mm(material)) &&
        strap_material_nominal_thickness_mm(material) > 0,
        "Nominal strap thickness must be finite and greater than zero.");
    assert(strap_material_nominal_thickness_mm(material) <
        strap_material_nominal_width_mm(material),
        "Nominal strap thickness must be smaller than nominal width.");
    assert(sb_finite_number(
            strap_material_nominal_break_strength_n(material)) &&
        strap_material_nominal_break_strength_n(material) > 0,
        "Nominal break strength must be finite and greater than zero.");
    assert(sb_finite_number(
            strap_material_nominal_coil_length_mm(material)) &&
        strap_material_nominal_coil_length_mm(material) > 0,
        "Nominal coil length must be finite and greater than zero.");
    assert(sb_nonempty_string(strap_material_color(material)),
        "Strap material color must be a non-empty string.");
    assert(sb_nonempty_string(strap_material_surface(material)),
        "Strap material surface must be a non-empty string.");
    assert(sb_finite_number(
            strap_material_recycled_content_percent(material)) &&
        strap_material_recycled_content_percent(material) >= 0 &&
        strap_material_recycled_content_percent(material) <= 100,
        "Recycled content must be between zero and one hundred percent.");
    assert(sb_nonempty_string(strap_material_source_title(material)),
        "Strap material source title must be a non-empty string.");
    assert(sb_nonempty_string(
            strap_material_source_checked_date(material)),
        "Strap material source checked date must be a non-empty string.");
    assert(sb_nonempty_string(strap_material_source_locator(material)),
        "Strap material source locator must be a non-empty string.");
    assert(is_string(strap_material_notes(material)),
        "Strap material notes must be a string.");
}
