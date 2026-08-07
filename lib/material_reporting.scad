
//////////////////////////////////////////////////////////////////////
// LibFile: material_reporting.scad
// Project: Strap Bender
// FileGroup: Strap Material Reporting
// FileSummary: Reports physical strap identity and nominal vendor values.
//////////////////////////////////////////////////////////////////////

module report_strap_material(material, report_level = "full") {
    echo(str("STRAP MATERIAL: ", strap_material_name(material)));
    echo(str("  manufacturer/product: ",
        strap_material_manufacturer(material), " / ",
        strap_material_product_number(material)));
    echo(str("  material: ", strap_material_family(material),
        "; color: ", strap_material_color(material),
        "; surface: ", strap_material_surface(material)));
    echo(str("  nominal width: ",
        strap_material_nominal_width_mm(material), " mm (",
        strap_material_nominal_width_in(material), " in)"));
    echo(str("  nominal thickness: ",
        strap_material_nominal_thickness_mm(material), " mm (",
        strap_material_nominal_thickness_in(material), " in)"));
    echo(str("  nominal break strength: ",
        strap_material_nominal_break_strength_n(material), " N (",
        strap_material_nominal_break_strength_lbf(material), " lbf)"));
    echo(str("  nominal coil length: ",
        strap_material_nominal_coil_length_mm(material), " mm (",
        strap_material_nominal_coil_length_ft(material), " ft)"));
    echo(str("  recycled content: ",
        strap_material_recycled_content_percent(material), "%"));
    echo(str("  vendor source checked: ",
        strap_material_source_checked_date(material)));
    if (report_level == "full") {
        echo(str("  source: ", strap_material_source_title(material)));
        echo(str("  source locator: ",
            strap_material_source_locator(material)));
        echo(str("  notes: ", strap_material_notes(material)));
    }
}
