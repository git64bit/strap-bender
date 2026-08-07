//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_registry_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies the persistent physical calibration-evidence boundary.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>
include <../registries/laboratory_radius_coupons.scad>
include <../registries/laboratory_calibration_trials.scad>

assert(len(LABORATORY_CALIBRATION_TRIALS) == 0,
    "Batch 013 must not invent or register physical PET evidence.");
validate_calibration_trial_registry(
    LABORATORY_CALIBRATION_TRIALS,
    LABORATORY_STRAP_MATERIALS,
    LABORATORY_RADIUS_CALIBRATION_COUPONS
);
report_calibration_trial_registry(
    LABORATORY_CALIBRATION_TRIALS,
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "full"
);

coupon = named_record(
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "radius calibration coupon"
);

// This record remains local to this contract. It is not physical PET evidence.
synthetic_observation = radius_observation_spec(
    name = "SYNTHETIC_REGISTRY_OBSERVATION",
    strap_material_name = radius_coupon_strap_material_name(coupon),
    specimen_id = "SYNTH-REGISTRY",
    measured_width_mm = 15.88,
    measured_thickness_mm = 0.51,
    bend_angle_degrees = radius_coupon_bend_angle_degrees(coupon),
    tool_inside_radius_mm = radius_coupon_tool_inside_radius_mm(coupon),
    forming_method = "cold",
    forming_temperature_c = 21,
    dwell_seconds = 30,
    cooling_restraint = "not_applicable",
    release_rest_seconds = 60,
    measured_finished_inside_radius_mm = 2.1,
    measurement_method = "synthetic registry contract value",
    measured_date = "2099-01-01",
    measurement_uncertainty_mm = 0.1,
    notes = "TEST DATA ONLY; never persist as physical evidence."
);

synthetic_trial = calibration_trial_spec(
    name = "SYNTHETIC_REGISTRY_TRIAL",
    coupon_name = radius_coupon_name(coupon),
    observation = synthetic_observation,
    notes = "TEST DATA ONLY; local registry-validation fixture."
);

synthetic_registry = [synthetic_trial];
validate_calibration_trial_registry(
    synthetic_registry,
    LABORATORY_STRAP_MATERIALS,
    LABORATORY_RADIUS_CALIBRATION_COUPONS
);
assert(calibration_trial_registry_names_unique(synthetic_registry),
    "One named synthetic trial must satisfy registry uniqueness.");
assert(!calibration_trial_registry_names_unique(
        [synthetic_trial, synthetic_trial]
    ),
    "Duplicate calibration-trial names must be detected.");
assert(named_record(
        synthetic_registry,
        "SYNTHETIC_REGISTRY_TRIAL",
        "calibration trial"
    ) == synthetic_trial,
    "Calibration evidence exact-name lookup failed.");

echo("STRAP BENDER CALIBRATION TRIAL REGISTRY CONTRACT: PASS");
