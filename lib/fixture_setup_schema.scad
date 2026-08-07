//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup_schema.scad
// Project: Strap Bender
// FileGroup: Fixture Setup Aid Data Model
// FileSummary: Constructor for segmented-fixture registration settings.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_FIXTURE_SETUP_AID_RECORD =
    "strap_bender_fixture_setup_aid";

function fixture_setup_aid_spec(
    name,
    registration_mode = "pin_pair",
    pin_nominal_diameter_mm = 3,
    hole_diametral_clearance_mm = 0.3,
    tangent_spacing_mm = 8,
    normal_offset_mm = 3,
    label_mode = "recessed_corner",
    label_size_mm = 2.5,
    label_depth_mm = 0.4,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_FIXTURE_SETUP_AID_RECORD,
    schema_version,
    name,
    registration_mode,
    pin_nominal_diameter_mm,
    hole_diametral_clearance_mm,
    tangent_spacing_mm,
    normal_offset_mm,
    label_mode,
    label_size_mm,
    label_depth_mm,
    notes
];
