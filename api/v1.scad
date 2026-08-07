//////////////////////////////////////////////////////////////////////
// LibFile: v1.scad
// Project: Strap Bender
// FileGroup: Versioned Public API
// FileSummary: Pins immutable object recipes to Strap Bender API version 1.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

assert(STRAP_BENDER_API_VERSION == 1,
    str("api/v1.scad requires Strap Bender API 1; runtime provides ",
        STRAP_BENDER_API_VERSION, "."));
assert(STRAP_BENDER_CATALOG_OBJECT_CONTRACT_VERSION == 1,
    "api/v1.scad requires Catalog object contract version 1.");
assert(STRAP_BENDER_MANUFACTURING_MANIFEST_CONTRACT_VERSION == 1,
    "api/v1.scad requires manufacturing manifest contract version 1.");

module strap_bender_render_catalog_object_component(
    object,
    component_index = 0
) {
    assert(catalog_object_required_api_version(object) == 1,
        str("Object recipe requires API ",
            catalog_object_required_api_version(object),
            "; api/v1.scad can render only API 1 objects."));
    sb_render_catalog_object_fixture_component(object, component_index);
}
