//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_validation.scad
// Project: Strap Bender
// FileGroup: Manufacturing Validation
// FileSummary: Validates embedded recipes and deterministic export manifests.
//////////////////////////////////////////////////////////////////////

module validate_catalog_object(object) {
    assert(is_list(object) && len(object) == 19,
        "Catalog-ready object records must contain nineteen fields.");
    assert(object[CO_RECORD_TYPE] == STRAP_BENDER_CATALOG_OBJECT_RECORD,
        "Invalid Catalog-ready object record type.");
    assert(sb_schema_version_valid(object[CO_SCHEMA_VERSION]),
        "Unsupported Catalog-ready object schema version.");
    assert(sb_nonempty_string(catalog_object_name(object)),
        "Catalog-ready object name must be non-empty.");
    assert(sb_nonnegative_integer(catalog_object_revision(object)) &&
        catalog_object_revision(object) >= 1,
        "Catalog-ready object revision must be a positive integer.");
    assert(sb_catalog_lifecycle_status_valid(
        catalog_object_lifecycle_status(object)
    ), str("Unsupported Catalog lifecycle status: ",
        catalog_object_lifecycle_status(object)));
    assert(sb_catalog_source_authoring_kind_valid(
        catalog_object_source_authoring_kind(object)
    ), str("Unsupported Catalog source authoring kind: ",
        catalog_object_source_authoring_kind(object)));
    assert(sb_nonempty_string(catalog_object_source_authoring_name(object)),
        "Catalog source authoring name must be non-empty.");
    assert(catalog_object_required_api_version(object) ==
        STRAP_BENDER_API_VERSION,
        str("Catalog-ready object requires Strap Bender API ",
            catalog_object_required_api_version(object),
            " but this runtime provides ", STRAP_BENDER_API_VERSION, "."));

    shape = catalog_object_normalized_shape(object);
    material = catalog_object_strap_material(object);
    cut_spec = catalog_object_cut_spec(object);
    fixture = catalog_object_fixture_spec(object);
    setup_aid = catalog_object_fixture_setup_aid(object);
    path = compile_bend_program(shape);
    materials = [material];

    validate_bend_program_shape(shape);
    validate_analytical_path(path);
    validate_strap_material(material);
    validate_strap_cut_spec(cut_spec, path, materials);
    validate_bend_post_fixture(fixture, materials);
    validate_fixture_setup_aid_source(setup_aid);
    assert(strap_cut_strap_material_name(cut_spec) ==
        strap_material_name(material),
        "Catalog cut policy must reference its embedded strap material.");
    assert(bend_post_fixture_strap_material_name(fixture) ==
        strap_material_name(material),
        "Catalog fixture must reference its embedded strap material.");
    assert(sb_fixture_layout_mode_valid(
        catalog_object_fixture_layout_mode(object)
    ), str("Unsupported Catalog fixture layout mode: ",
        catalog_object_fixture_layout_mode(object)));
    assert(is_string(catalog_object_source_commit(object)) &&
        is_string(catalog_object_accepted_date(object)) &&
        is_string(catalog_object_acceptance_notes(object)) &&
        is_string(catalog_object_slicer_project_file(object)) &&
        is_string(catalog_object_notes(object)),
        "Catalog provenance, slicer-project, and notes fields must be strings.");

    if (catalog_object_lifecycle_status(object) == "accepted") {
        assert(sb_nonempty_string(catalog_object_source_commit(object)),
            "Accepted Catalog objects require source-commit provenance.");
        assert(sb_nonempty_string(catalog_object_accepted_date(object)),
            "Accepted Catalog objects require an acceptance date.");
        assert(sb_nonempty_string(catalog_object_acceptance_notes(object)),
            "Accepted Catalog objects require physical acceptance notes.");
    } else {
        assert(len(catalog_object_accepted_date(object)) == 0 &&
            len(catalog_object_acceptance_notes(object)) == 0,
            str("Laboratory candidates cannot contain physical acceptance ",
                "date or acceptance notes."));
    }
}

module validate_manufacturing_export(entry) {
    assert(is_list(entry) && len(entry) == 10,
        "Manufacturing export records must contain ten fields.");
    assert(entry[ME_RECORD_TYPE] == STRAP_BENDER_MANUFACTURING_EXPORT_RECORD,
        "Invalid manufacturing export record type.");
    assert(sb_schema_version_valid(entry[ME_SCHEMA_VERSION]),
        "Unsupported manufacturing export schema version.");
    assert(manufacturing_export_kind(entry) == "fixture_stl",
        str("Unsupported manufacturing export kind: ",
            manufacturing_export_kind(entry)));
    assert(sb_nonnegative_integer(manufacturing_export_component_index(entry)),
        "Manufacturing export component index must be nonnegative.");
    assert(sb_nonempty_string(manufacturing_export_component_id(entry)) &&
        sb_nonempty_string(manufacturing_export_recipe_filename(entry)) &&
        sb_nonempty_string(manufacturing_export_stl_filename(entry)),
        "Manufacturing export IDs and filenames must be non-empty.");
    assert(sb_finite_number(manufacturing_export_station_start_mm(entry)) &&
        sb_finite_number(manufacturing_export_station_end_mm(entry)) &&
        manufacturing_export_station_end_mm(entry) >
            manufacturing_export_station_start_mm(entry),
        "Manufacturing export station interval must be finite and positive.");
    assert(sb_bounds_valid(manufacturing_export_base_bounds(entry)),
        "Manufacturing export base bounds are invalid.");
}

module validate_manufacturing_manifest(manifest) {
    assert(is_list(manifest) && len(manifest) == 12,
        "Manufacturing manifest records must contain twelve fields.");
    assert(manifest[MM_RECORD_TYPE] ==
        STRAP_BENDER_MANUFACTURING_MANIFEST_RECORD,
        "Invalid manufacturing manifest record type.");
    assert(sb_schema_version_valid(manifest[MM_SCHEMA_VERSION]),
        "Unsupported manufacturing manifest schema version.");

    object = manufacturing_manifest_catalog_object(manifest);
    validate_catalog_object(object);
    shape = catalog_object_normalized_shape(object);
    material = catalog_object_strap_material(object);
    materials = [material];
    cut_spec = catalog_object_cut_spec(object);
    fixture = catalog_object_fixture_spec(object);
    setup_aid = catalog_object_fixture_setup_aid(object);
    path = compile_bend_program(shape);
    cut_plan = manufacturing_manifest_cut_plan(manifest);
    fixture_plan = manufacturing_manifest_fixture_plan(manifest);
    use_segmentation = manufacturing_manifest_use_segmentation(manifest);

    validate_strap_cut_plan(cut_plan, cut_spec, path, materials);
    expected_use_segmentation = sb_manufacturing_use_segmentation(
        object, fixture_plan
    );
    assert(use_segmentation == expected_use_segmentation,
        "Manufacturing manifest segmentation decision mismatch.");
    validate_bend_post_fixture_plan(
        fixture_plan,
        fixture,
        path,
        materials,
        enforce_print_envelope = !use_segmentation
    );

    clearance_report = analyze_bend_post_fixture_clearance(
        fixture_plan, fixture, path, materials
    );
    validate_bend_post_fixture_clearance(
        clearance_report, fixture_plan, fixture, path, materials
    );

    segmentation_plan = manufacturing_manifest_segmentation_plan(manifest);
    if (use_segmentation) {
        assert(!is_undef(segmentation_plan),
            "Segmented manufacturing manifests require a segmentation plan.");
        validate_bend_post_fixture_segmentation(
            segmentation_plan, fixture_plan, fixture, path
        );
        validate_fixture_setup_aid(
            setup_aid, segmentation_plan, fixture_plan, fixture, path
        );
    } else {
        assert(is_undef(segmentation_plan),
            "Full-form manufacturing manifests must not carry segmentation.");
    }

    entries = manufacturing_manifest_export_entries(manifest);
    expected_entries = use_segmentation
        ? sb_segmented_export_entries(object, segmentation_plan)
        : [sb_full_form_export_entry(object, path, fixture_plan)];
    assert(entries == expected_entries,
        "Manufacturing export entries are not deterministic from the recipe.");
    assert(len(entries) >= 1,
        "Manufacturing manifest must contain at least one printable export.");
    for (entry = entries)
        validate_manufacturing_export(entry);

    assert(manufacturing_manifest_object_recipe_filename(manifest) ==
        sb_manufacturing_object_recipe_filename(object),
        "Manufacturing object-recipe filename mismatch.");
    assert(manufacturing_manifest_filename(manifest) ==
        sb_manufacturing_manifest_filename(object),
        "Manufacturing manifest filename mismatch.");
    assert(manufacturing_manifest_status(manifest) ==
        sb_manufacturing_manifest_status(cut_plan, fixture_plan),
        "Manufacturing manifest status mismatch.");
    assert(is_string(manufacturing_manifest_notes(manifest)),
        "Manufacturing manifest notes must be a string.");
}
