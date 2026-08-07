//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_math.scad
// Project: Strap Bender
// FileGroup: Manufacturing Planning
// FileSummary: Derives deterministic export manifests from embedded object recipes.
//////////////////////////////////////////////////////////////////////

function sb_catalog_source_authoring_kind_valid(kind) =
    kind == "bend_program" ||
    kind == "vertex_polygon" ||
    kind == "regular_polygon" ||
    kind == "pattern";

function sb_catalog_lifecycle_status_valid(status) =
    status == "laboratory_candidate" || status == "accepted";

function sb_manufacturing_component_token(component_index) =
    str(
        "c",
        component_index + 1 < 10 ? "00" :
            component_index + 1 < 100 ? "0" : "",
        component_index + 1
    );

function sb_manufacturing_object_stem(object) =
    str(catalog_object_name(object), "-r", catalog_object_revision(object));

function sb_manufacturing_object_recipe_filename(object) =
    str(sb_manufacturing_object_stem(object), ".scad");

function sb_manufacturing_manifest_filename(object) =
    str(sb_manufacturing_object_stem(object), "-manifest.txt");

function sb_manufacturing_component_recipe_filename(object, component_index) =
    str(
        sb_manufacturing_object_stem(object), "-fixture-",
        sb_manufacturing_component_token(component_index), ".scad"
    );

function sb_manufacturing_component_stl_filename(object, component_index) =
    str(
        sb_manufacturing_object_stem(object), "-fixture-",
        sb_manufacturing_component_token(component_index), ".stl"
    );

function sb_manufacturing_use_segmentation(object, fixture_plan) =
    let(
        fixture = catalog_object_fixture_spec(object),
        layout_mode = catalog_object_fixture_layout_mode(object),
        full_form_fits = sb_fixture_plan_fits_print_envelope(
            fixture_plan, fixture
        )
    )
    layout_mode == "segmented" ||
    (layout_mode == "auto" && !full_form_fits);

function sb_full_form_export_entry(object, path, fixture_plan) =
    manufacturing_export_spec(
        kind = "fixture_stl",
        component_index = 0,
        component_id = str(
            bend_post_fixture_plan_fixture_name(fixture_plan), "__C001"
        ),
        recipe_filename = sb_manufacturing_component_recipe_filename(
            object, 0
        ),
        stl_filename = sb_manufacturing_component_stl_filename(object, 0),
        station_start_mm = 0,
        station_end_mm = analytical_path_length(path),
        base_bounds = bend_post_fixture_plan_base_bounds(fixture_plan)
    );

function sb_segmented_export_entries(object, segmentation_plan) = [
    for (component = fixture_segmentation_plan_components(segmentation_plan))
        manufacturing_export_spec(
            kind = "fixture_stl",
            component_index = fixture_component_index(component),
            component_id = fixture_component_id(component),
            recipe_filename = sb_manufacturing_component_recipe_filename(
                object, fixture_component_index(component)
            ),
            stl_filename = sb_manufacturing_component_stl_filename(
                object, fixture_component_index(component)
            ),
            station_start_mm = fixture_component_station_start_mm(component),
            station_end_mm = fixture_component_station_end_mm(component),
            base_bounds = fixture_component_base_bounds(component)
        )
];

function sb_manufacturing_manifest_status(cut_plan, fixture_plan) =
    str(
        bend_post_fixture_plan_status(fixture_plan), "__",
        strap_cut_plan_status(cut_plan)
    );

function plan_catalog_object_manufacturing(object) =
    let(
        shape = catalog_object_normalized_shape(object),
        material = catalog_object_strap_material(object),
        materials = [material],
        cut_spec = catalog_object_cut_spec(object),
        fixture = catalog_object_fixture_spec(object),
        path = compile_bend_program(shape),
        cut_plan = plan_strap_cut(path, cut_spec, materials),
        fixture_plan = plan_bend_post_fixture(path, fixture, materials),
        use_segmentation = sb_manufacturing_use_segmentation(
            object, fixture_plan
        ),
        segmentation_plan = use_segmentation
            ? plan_bend_post_fixture_segmentation(
                path, fixture_plan, fixture
            )
            : undef,
        export_entries = use_segmentation
            ? sb_segmented_export_entries(object, segmentation_plan)
            : [sb_full_form_export_entry(object, path, fixture_plan)]
    )
    manufacturing_manifest_spec(
        catalog_object = object,
        cut_plan = cut_plan,
        fixture_plan = fixture_plan,
        use_segmentation = use_segmentation,
        segmentation_plan = segmentation_plan,
        export_entries = export_entries,
        object_recipe_filename = sb_manufacturing_object_recipe_filename(object),
        manifest_filename = sb_manufacturing_manifest_filename(object),
        status = sb_manufacturing_manifest_status(cut_plan, fixture_plan),
        notes = str(
            "Deterministic application-level manufacturing manifest. Export ",
            "filenames and component indexes are derived from the embedded ",
            "Catalog-ready recipe. No STL, SCAD recipe, text manifest, or slicer ",
            "project is written automatically by OpenSCAD."
        )
    );
