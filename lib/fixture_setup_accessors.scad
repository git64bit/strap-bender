//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup_accessors.scad
// Project: Strap Bender
// FileGroup: Fixture Setup Aid Data Model
// FileSummary: Named accessors for segmented-fixture registration settings.
//////////////////////////////////////////////////////////////////////

function fixture_setup_aid_name(setup) = setup[FSA_NAME];
function fixture_setup_aid_registration_mode(setup) =
    setup[FSA_REGISTRATION_MODE];
function fixture_setup_aid_pin_nominal_diameter_mm(setup) =
    setup[FSA_PIN_NOMINAL_DIAMETER_MM];
function fixture_setup_aid_hole_diametral_clearance_mm(setup) =
    setup[FSA_HOLE_DIAMETRAL_CLEARANCE_MM];
function fixture_setup_aid_tangent_spacing_mm(setup) =
    setup[FSA_TANGENT_SPACING_MM];
function fixture_setup_aid_normal_offset_mm(setup) =
    setup[FSA_NORMAL_OFFSET_MM];
function fixture_setup_aid_label_mode(setup) = setup[FSA_LABEL_MODE];
function fixture_setup_aid_label_size_mm(setup) = setup[FSA_LABEL_SIZE_MM];
function fixture_setup_aid_label_depth_mm(setup) = setup[FSA_LABEL_DEPTH_MM];
function fixture_setup_aid_notes(setup) = setup[FSA_NOTES];
function fixture_setup_aid_hole_diameter_mm(setup) =
    fixture_setup_aid_pin_nominal_diameter_mm(setup) +
    fixture_setup_aid_hole_diametral_clearance_mm(setup);
function fixture_setup_aid_hole_radius_mm(setup) =
    fixture_setup_aid_hole_diameter_mm(setup) / 2;
