//////////////////////////////////////////////////////////////////////
// LibFile: catalog_object_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies candidate/accepted provenance and embedded recipe identity.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

material = strap_material_spec(
    "TEST_CATALOG_STRAP",
    "TEST MAKER",
    "TEST-CATALOG-1",
    "PET polyester",
    15.875,
    0.508,
    sb_pounds_force_to_newtons(750),
    sb_feet_to_mm(2850),
    "black",
    "smooth",
    100,
    "TEST SOURCE",
    "2026-08-07",
    "https://example.invalid/catalog-strap"
);
shape = bend_program_shape_spec(
    "TEST_CATALOG_SHAPE",
    [
        straight_command(0, 80, "S0"),
        bend_command(1, 90, 10, "B0"),
        straight_command(2, 80, "S1")
    ],
    "open",
    start_pose_spec(0, 0, 0),
    "Synthetic Catalog object contract shape."
);
path = compile_bend_program(shape);
cut = strap_cut_spec(
    "TEST_CATALOG_CUT",
    "TEST_CATALOG_STRAP",
    "nominal_mid_thickness",
    0.5,
    2,
    3,
    "none",
    0,
    0,
    "Synthetic Catalog object cut policy."
);
fixture = bend_post_fixture_spec(
    "TEST_CATALOG_FIXTURE",
    "TEST_CATALOG_STRAP",
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
    "Synthetic Catalog object fixture."
);
setup = fixture_setup_aid_spec(
    "TEST_CATALOG_SETUP",
    "pin_pair",
    3,
    0.3,
    8,
    3,
    "recessed_corner",
    2.5,
    0.4,
    "Synthetic Catalog object setup aids."
);

candidate = catalog_object_spec(
    "TEST_CATALOG_OBJECT",
    3,
    "laboratory_candidate",
    "bend_program",
    "TEST_CATALOG_SHAPE",
    1,
    shape,
    material,
    cut,
    fixture,
    "auto",
    setup,
    "",
    "",
    "",
    "",
    "Synthetic candidate; no physical acceptance claimed."
);
validate_catalog_object(candidate);
assert(catalog_object_normalized_shape(candidate) == shape &&
    catalog_object_strap_material(candidate) == material &&
    catalog_object_cut_spec(candidate) == cut &&
    catalog_object_fixture_spec(candidate) == fixture &&
    catalog_object_fixture_setup_aid(candidate) == setup,
    "Catalog candidate must embed exact geometry-affecting records.");
assert(catalog_object_lifecycle_status(candidate) == "laboratory_candidate" &&
    len(catalog_object_accepted_date(candidate)) == 0,
    "Laboratory candidate must not claim physical acceptance.");

accepted = catalog_object_spec(
    "TEST_ACCEPTED_OBJECT",
    1,
    "accepted",
    "bend_program",
    "TEST_CATALOG_SHAPE",
    1,
    shape,
    material,
    cut,
    fixture,
    "full_form",
    setup,
    "0123456789abcdef0123456789abcdef01234567",
    "2099-01-01",
    "Synthetic contract acceptance only; not physical project evidence.",
    "TEST_ACCEPTED_OBJECT-r1.3mf",
    "Synthetic accepted-state contract record."
);
validate_catalog_object(accepted);
accepted_manifest = plan_catalog_object_manufacturing(accepted);
validate_manufacturing_manifest(accepted_manifest);
assert(catalog_object_source_commit(accepted) ==
    "0123456789abcdef0123456789abcdef01234567" &&
    catalog_object_slicer_project_file(accepted) ==
        "TEST_ACCEPTED_OBJECT-r1.3mf",
    "Accepted Catalog provenance and manufacturing-project references failed.");
assert(strap_cut_plan_path_name(
        manufacturing_manifest_cut_plan(accepted_manifest)
    ) == analytical_path_name(path),
    "Accepted object must regenerate its deterministic cut plan from embedded data.");

report_catalog_object(candidate, "summary");
report_catalog_object(accepted, "summary");
echo("STRAP BENDER CATALOG OBJECT CONTRACT: PASS");
