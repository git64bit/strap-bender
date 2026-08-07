//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing.scad
// Project: Strap Bender
// FileGroup: Workbench Manufacturing Configuration
// FileSummary: Packages the active normalized shape as a Laboratory candidate.
//////////////////////////////////////////////////////////////////////

function workbench_catalog_object(shape, source_kind, source_name) =
    let(
        material = named_record(
            STRAP_MATERIALS,
            wb_strap_material_name,
            "strap material"
        ),
        resolved_name = len(wb_manufacturing_object_name) > 0
            ? wb_manufacturing_object_name
            : shape_name(shape)
    )
    catalog_object_spec(
        name = resolved_name,
        revision = wb_manufacturing_revision,
        lifecycle_status = "laboratory_candidate",
        source_authoring_kind = source_kind,
        source_authoring_name = source_name,
        required_api_version = STRAP_BENDER_API_VERSION,
        normalized_shape = shape,
        strap_material = material,
        cut_spec = WORKBENCH_STRAP_CUT_SPEC,
        fixture_spec = WORKBENCH_BEND_POST_FIXTURE,
        fixture_layout_mode = wb_fixture_layout_mode,
        fixture_setup_aid = WORKBENCH_FIXTURE_SETUP_AID,
        source_commit = wb_manufacturing_source_commit,
        accepted_date = "",
        acceptance_notes = "",
        slicer_project_file = wb_manufacturing_slicer_project_file,
        notes = str(
            "Mutable workbench package generated for application-level export ",
            "planning. It embeds geometry-affecting records but remains a ",
            "Laboratory candidate until a physically accepted immutable recipe ",
            "is committed under objects/ and registered in Catalog."
        )
    );
