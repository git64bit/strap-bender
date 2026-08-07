//////////////////////////////////////////////////////////////////////
// LibFile: radius_observation_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies physical bend observations and direct metrics.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>

// Synthetic values exist only to exercise the record contract. They are not
// registered calibration data and must never be treated as PET process advice.
observation_a = radius_observation_spec(
    name = "SYNTHETIC_RADIUS_TEST_A",
    strap_material_name = "ULINE_S_1655_BLACK",
    specimen_id = "SYNTH-A",
    measured_width_mm = 15.88,
    measured_thickness_mm = 0.51,
    bend_angle_degrees = 90,
    tool_inside_radius_mm = 4,
    forming_method = "cold",
    forming_temperature_c = 21,
    dwell_seconds = 30,
    cooling_restraint = "not_applicable",
    release_rest_seconds = 60,
    measured_finished_inside_radius_mm = 5,
    measurement_method = "synthetic contract value",
    measured_date = "2099-01-01",
    measurement_uncertainty_mm = 0.1,
    notes = "TEST DATA ONLY; not a physical observation."
);

observation_b = radius_observation_spec(
    name = "SYNTHETIC_RADIUS_TEST_B",
    strap_material_name = "ULINE_S_1655_BLACK",
    specimen_id = "SYNTH-B",
    measured_width_mm = 15.87,
    measured_thickness_mm = 0.50,
    bend_angle_degrees = -90,
    tool_inside_radius_mm = 2,
    forming_method = "local_heat",
    forming_temperature_c = 80,
    dwell_seconds = 15,
    cooling_restraint = "restrained",
    release_rest_seconds = 120,
    measured_finished_inside_radius_mm = 2.5,
    measurement_method = "synthetic contract value",
    measured_date = "2099-01-01",
    measurement_uncertainty_mm = 0.05,
    notes = "TEST DATA ONLY; not a forming recommendation."
);

observations = [observation_a, observation_b];

validate_radius_observation(
    observation_a,
    LABORATORY_STRAP_MATERIALS
);
validate_radius_observation(
    observation_b,
    LABORATORY_STRAP_MATERIALS
);
report_radius_observation(observation_a, "full");

assert(radius_observation_name(observation_a) ==
    "SYNTHETIC_RADIUS_TEST_A",
    "Radius observation name accessor failed.");
assert(radius_observation_strap_material_name(observation_a) ==
    "ULINE_S_1655_BLACK",
    "Radius observation material provenance failed.");
assert(abs(radius_observation_springback_delta_mm(observation_a) - 1) < 1e-9,
    "Direct springback delta calculation failed.");
assert(abs(radius_observation_finished_to_tool_ratio(observation_a) - 1.25) <
    1e-9,
    "Finished/tool ratio calculation failed.");
assert(abs(radius_observation_tool_to_finished_ratio(observation_a) - 0.8) <
    1e-9,
    "Tool/finished ratio calculation failed.");
assert(len(records_named(observations, "SYNTHETIC_RADIUS_TEST_B")) == 1,
    "Radius observation exact-name lookup failed.");
assert(named_record(
        observations,
        "SYNTHETIC_RADIUS_TEST_B",
        "radius observation"
    ) == observation_b,
    "Radius observation exact-name resolution failed.");

// The public library deliberately supplies no claimed physical observations.
assert(!is_undef(STRAP_BENDER_RADIUS_OBSERVATION_CONTRACT_VERSION),
    "Radius observation contract version must be public.");

echo("STRAP BENDER RADIUS OBSERVATION CONTRACT: PASS");
