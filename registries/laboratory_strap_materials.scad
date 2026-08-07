
//////////////////////////////////////////////////////////////////////
// LibFile: laboratory_strap_materials.scad
// Project: Strap Bender
// FileGroup: Laboratory Registry
// FileSummary: Registers the confirmed ULINE PET strap product.
//////////////////////////////////////////////////////////////////////

LABORATORY_STRAP_MATERIALS = [
    strap_material_spec(
        name = "ULINE_S_1655_BLACK",
        manufacturer = "ULINE",
        product_number = "S-1655",
        material_family = "PET polyester",
        nominal_width_mm = sb_inches_to_mm(5 / 8),
        nominal_thickness_mm = sb_inches_to_mm(0.020),
        nominal_break_strength_n = sb_pounds_force_to_newtons(750),
        nominal_coil_length_mm = sb_feet_to_mm(2850),
        color = "black",
        surface = "smooth",
        recycled_content_percent = 100,
        source_title = str(
            "Uline Polyester Strapping - 5/8 x .020 x 2,850', Black"
        ),
        source_checked_date = "2026-08-06",
        source_locator = str(
            "https://www.uline.com/Product/Detail/S-1655/",
            "Polyester-Strapping/Uline-Polyester-Strapping-",
            "5-8-x-020-x-2850-Black"
        ),
        notes = str(
            "Vendor nominal product data for the 16 x 3 inch core. ",
            "This is the physical strap identity used by Strap Bender. ",
            "No measured width, measured thickness, springback mapping, ",
            "neutral-axis correction, or forming-temperature recommendation ",
            "is implied by this record."
        )
    )
];
