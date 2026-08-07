//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_reporting.scad
// Project: Strap Bender
// FileGroup: Manufacturing Reporting
// FileSummary: Reports Catalog-ready recipes and deterministic export manifests.
//////////////////////////////////////////////////////////////////////

module report_catalog_object(object, level = "summary") {
    echo("--- Strap Bender Catalog-ready object package ---");
    echo(str("Object: ", catalog_object_name(object),
        " revision ", catalog_object_revision(object)));
    echo(str("Lifecycle: ", catalog_object_lifecycle_status(object)));
    echo(str("Authoring source: ",
        catalog_object_source_authoring_kind(object), " / ",
        catalog_object_source_authoring_name(object)));
    echo(str("Required API: ", catalog_object_required_api_version(object),
        "; embedded schema: ", STRAP_BENDER_SCHEMA_VERSION));
    echo(str("Normalized shape: ",
        shape_name(catalog_object_normalized_shape(object))));
    echo(str("Embedded strap material: ",
        strap_material_name(catalog_object_strap_material(object))));
    echo(str("Fixture layout: ",
        catalog_object_fixture_layout_mode(object)));
    echo(str("Source commit: ",
        len(catalog_object_source_commit(object)) > 0
            ? catalog_object_source_commit(object)
            : "UNPINNED LABORATORY CANDIDATE"));
    if (catalog_object_lifecycle_status(object) == "accepted") {
        echo(str("Accepted date: ", catalog_object_accepted_date(object)));
        echo(str("Acceptance: ", catalog_object_acceptance_notes(object)));
    } else
        echo("Physical acceptance: NOT CLAIMED");
    echo(str("Slicer project: ",
        len(catalog_object_slicer_project_file(object)) > 0
            ? catalog_object_slicer_project_file(object)
            : "not assigned"));
    if (level == "full")
        echo(str("Notes: ", catalog_object_notes(object)));
}

module report_manufacturing_export(entry) {
    echo(str(
        "  export ", manufacturing_export_component_index(entry),
        ": ", manufacturing_export_component_id(entry),
        "; station ", manufacturing_export_station_start_mm(entry),
        " to ", manufacturing_export_station_end_mm(entry), " mm",
        "; base ", manufacturing_export_base_width_mm(entry), " x ",
        manufacturing_export_base_depth_mm(entry), " mm",
        "; recipe ", manufacturing_export_recipe_filename(entry),
        "; STL ", manufacturing_export_stl_filename(entry)
    ));
}

module report_manufacturing_manifest(manifest, level = "summary") {
    object = manufacturing_manifest_catalog_object(manifest);
    cut_plan = manufacturing_manifest_cut_plan(manifest);
    fixture_plan = manufacturing_manifest_fixture_plan(manifest);
    entries = manufacturing_manifest_export_entries(manifest);
    report_catalog_object(object, level);
    echo("--- Strap Bender manufacturing/export manifest ---");
    echo(str("Manifest file: ", manufacturing_manifest_filename(manifest)));
    echo(str("Object recipe file: ",
        manufacturing_manifest_object_recipe_filename(manifest)));
    echo(str("Status: ", manufacturing_manifest_status(manifest)));
    echo(str("Nominal cut length: ",
        strap_cut_plan_cut_length_mm(cut_plan), " mm (",
        sb_mm_to_feet(strap_cut_plan_cut_length_mm(cut_plan)), " ft)"));
    echo(str("Fixture: ", bend_post_fixture_plan_fixture_name(fixture_plan),
        "; layout: ",
        manufacturing_manifest_use_segmentation(manifest)
            ? "segmented sequential" : "full form"));
    echo(str("Printable fixture exports: ", len(entries)));
    for (entry = entries)
        report_manufacturing_export(entry);
    echo(str(
        "Export instruction: render exactly the listed component index and ",
        "save it with the listed STL filename. OpenSCAD does not write these ",
        "files or the manifest automatically."
    ));
    if (catalog_object_lifecycle_status(object) == "laboratory_candidate")
        echo(str(
            "Catalog warning: this package is a Laboratory candidate only. ",
            "Physical acceptance and an explicit immutable object recipe are ",
            "required before Catalog registration."
        ));
    if (level == "full")
        echo(str("Notes: ", manufacturing_manifest_notes(manifest)));
}
