//////////////////////////////////////////////////////////////////////
// LibFile: catalog_object_render.scad
// Project: Strap Bender
// FileGroup: Manufacturing Rendering
// FileSummary: Renders one fixture component from an embedded immutable recipe.
//////////////////////////////////////////////////////////////////////

module sb_render_catalog_object_fixture_component(object, component_index = 0) {
    assert(sb_nonnegative_integer(component_index),
        "Catalog fixture component index must be a nonnegative integer.");
    validate_catalog_object(object);
    manifest = plan_catalog_object_manufacturing(object);
    validate_manufacturing_manifest(manifest);

    fixture = catalog_object_fixture_spec(object);
    fixture_plan = manufacturing_manifest_fixture_plan(manifest);
    if (manufacturing_manifest_use_segmentation(manifest)) {
        segmentation = manufacturing_manifest_segmentation_plan(manifest);
        components = fixture_segmentation_plan_components(segmentation);
        assert(component_index < len(components),
            str("Catalog fixture component index ", component_index,
                " is outside the available range 0..", len(components) - 1,
                "."));
        render_bend_post_fixture_component(
            components[component_index],
            fixture_plan,
            fixture,
            catalog_object_fixture_setup_aid(object)
        );
    } else {
        assert(component_index == 0,
            "Full-form Catalog fixtures expose only component index 0.");
        render_bend_post_fixture(fixture_plan, fixture);
    }
}
