//////////////////////////////////////////////////////////////////////
// LibFile: manufacturing_manifest_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies deterministic full-form and segmented export manifests.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../patterns/standard_patterns.scad>
include <../registries/laboratory_pattern_instances.scad>
include <../registries/laboratory_strap_materials.scad>
include <../registries/laboratory_vertex_polygons.scad>

material = named_record(
    LABORATORY_STRAP_MATERIALS,
    "ULINE_S_1655_BLACK",
    "strap material"
);
setup = fixture_setup_aid_spec(
    "MANIFEST_SETUP",
    "pin_pair",
    3,
    0.3,
    8,
    3,
    "recessed_corner",
    2.5,
    0.4,
    "Synthetic manifest setup-aid contract."
);

square_source = named_record(
    LABORATORY_VERTEX_POLYGONS,
    "ROUNDED_SQUARE_EXAMPLE",
    "vertex polygon"
);
square_compilation = compile_vertex_polygon(square_source);
square_shape = polygon_compilation_normalized_shape(square_compilation);
square_path = compile_bend_program(square_shape);
square_cut = strap_cut_spec(
    "SQUARE_CUT",
    "ULINE_S_1655_BLACK",
    "nominal_mid_thickness",
    0.5,
    0,
    0,
    "none",
    0,
    0,
    "Synthetic full-form manifest cut policy."
);
square_fixture = bend_post_fixture_spec(
    "SQUARE_MANIFEST_FIXTURE",
    "ULINE_S_1655_BLACK",
    "nominal_target",
    3,
    8,
    18,
    0.25,
    1,
    220,
    220,
    0.02,
    5,
    "arc_follower",
    2,
    "Synthetic full-form manifest fixture."
);
square_object = catalog_object_spec(
    "ROUNDED_SQUARE_OBJECT",
    1,
    "laboratory_candidate",
    "vertex_polygon",
    "ROUNDED_SQUARE_EXAMPLE",
    STRAP_BENDER_API_VERSION,
    square_shape,
    material,
    square_cut,
    square_fixture,
    "auto",
    setup,
    "",
    "",
    "",
    "",
    "Synthetic full-form Catalog candidate."
);
validate_catalog_object(square_object);
square_manifest = plan_catalog_object_manufacturing(square_object);
validate_manufacturing_manifest(square_manifest);
square_entries = manufacturing_manifest_export_entries(square_manifest);
assert(!manufacturing_manifest_use_segmentation(square_manifest),
    "Rounded-square reference must remain a one-piece manufacturing fixture.");
assert(len(square_entries) == 1,
    "Full-form manufacturing manifest must contain exactly one fixture export.");
assert(manufacturing_export_component_index(square_entries[0]) == 0 &&
    manufacturing_export_component_id(square_entries[0]) ==
        "SQUARE_MANIFEST_FIXTURE__C001",
    "Full-form export identity must be deterministic.");
assert(manufacturing_export_stl_filename(square_entries[0]) ==
    "ROUNDED_SQUARE_OBJECT-r1-fixture-c001.stl",
    "Full-form STL filename must be deterministic.");
assert(manufacturing_manifest_object_recipe_filename(square_manifest) ==
    "ROUNDED_SQUARE_OBJECT-r1.scad" &&
    manufacturing_manifest_filename(square_manifest) ==
        "ROUNDED_SQUARE_OBJECT-r1-manifest.txt",
    "Object-recipe and manifest filenames must be deterministic.");
assert(sb_near(
        manufacturing_export_station_end_mm(square_entries[0]),
        analytical_path_length(square_path),
        SB_NUMERIC_STATION_TOLERANCE_MM
    ),
    "Full-form export must cover the complete analytical station interval.");

pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
instance = named_record(
    LABORATORY_PATTERN_INSTANCES,
    "THIRTY_WAVE_EVERY_THIRD_R5",
    "pattern instance"
);
pattern_compilation = compile_pattern_instance(instance, pattern);
wave_shape = pattern_compilation_normalized_shape(pattern_compilation);
wave_cut = strap_cut_spec(
    "WAVE_CUT",
    "ULINE_S_1655_BLACK",
    "nominal_mid_thickness",
    0.5,
    0,
    0,
    "none",
    0,
    0,
    "Synthetic segmented manifest cut policy."
);
wave_fixture = bend_post_fixture_spec(
    "WAVE_MANIFEST_FIXTURE",
    "ULINE_S_1655_BLACK",
    "nominal_target",
    3,
    8,
    18,
    0.25,
    1,
    220,
    220,
    0.02,
    5,
    "arc_follower",
    2,
    "Synthetic segmented manifest fixture."
);
wave_object = catalog_object_spec(
    "THIRTY_WAVE_OBJECT",
    2,
    "laboratory_candidate",
    "pattern",
    "THIRTY_WAVE_EVERY_THIRD_R5",
    STRAP_BENDER_API_VERSION,
    wave_shape,
    material,
    wave_cut,
    wave_fixture,
    "auto",
    setup,
    "",
    "",
    "",
    "",
    "Synthetic segmented Catalog candidate."
);
validate_catalog_object(wave_object);
wave_manifest = plan_catalog_object_manufacturing(wave_object);
validate_manufacturing_manifest(wave_manifest);
wave_entries = manufacturing_manifest_export_entries(wave_manifest);
wave_segmentation = manufacturing_manifest_segmentation_plan(wave_manifest);
assert(manufacturing_manifest_use_segmentation(wave_manifest),
    "Thirty-wave reference must automatically select segmented manufacturing.");
assert(len(wave_entries) ==
    fixture_segmentation_plan_component_count(wave_segmentation),
    "Segmented manifest must provide one export entry per fixture component.");
assert(len(wave_entries) == 23,
    "Thirty-wave manufacturing manifest must preserve the 23-component contract.");
assert(manufacturing_export_stl_filename(wave_entries[0]) ==
    "THIRTY_WAVE_OBJECT-r2-fixture-c001.stl" &&
    manufacturing_export_stl_filename(wave_entries[22]) ==
        "THIRTY_WAVE_OBJECT-r2-fixture-c023.stl",
    "Segmented STL filenames must preserve deterministic zero-padded indexes.");

report_manufacturing_manifest(square_manifest, "summary");
report_manufacturing_manifest(wave_manifest, "summary");
echo("STRAP BENDER MANUFACTURING MANIFEST CONTRACT: PASS");
