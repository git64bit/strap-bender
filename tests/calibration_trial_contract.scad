//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies coupon-linked calibration evidence provenance.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../registries/laboratory_strap_materials.scad>
include <../registries/laboratory_radius_coupons.scad>

coupon = named_record(
    LABORATORY_RADIUS_CALIBRATION_COUPONS,
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "radius calibration coupon"
);

// Synthetic values exercise the evidence link only. They are not PET data.
observation = radius_observation_spec(
    name = "SYNTHETIC_LINKED_OBSERVATION",
    strap_material_name = radius_coupon_strap_material_name(coupon),
    specimen_id = "SYNTH-LINK",
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
    measurement_method = "synthetic contract value",
    measured_date = "2099-01-01",
    measurement_uncertainty_mm = 0.1,
    notes = "TEST DATA ONLY; not a physical observation."
);

trial = calibration_trial_spec(
    name = "SYNTHETIC_COUPON_LINK_TRIAL",
    coupon_name = radius_coupon_name(coupon),
    observation = observation,
    notes = "TEST DATA ONLY; verifies exact coupon linkage."
);

validate_calibration_trial(
    trial,
    LABORATORY_STRAP_MATERIALS,
    LABORATORY_RADIUS_CALIBRATION_COUPONS
);
report_calibration_trial(trial, coupon, "full");

assert(calibration_trial_name(trial) == "SYNTHETIC_COUPON_LINK_TRIAL",
    "Calibration trial name accessor failed.");
assert(calibration_trial_coupon_name(trial) ==
    "ULINE_R90_TOOL_R1_6_EXPERIMENTAL",
    "Calibration trial coupon provenance failed.");
assert(calibration_trial_observation(trial) == observation,
    "Calibration trial observation accessor failed.");
assert(abs(radius_observation_tool_inside_radius_mm(observation) - 1.6) <
    1e-9,
    "Linked observation must inherit the source coupon tool radius.");
assert(abs(radius_observation_bend_angle_degrees(observation) - 90) < 1e-9,
    "Linked observation must inherit the source coupon bend angle.");

trial_registry = [trial];
assert(named_record(
        trial_registry,
        "SYNTHETIC_COUPON_LINK_TRIAL",
        "calibration trial"
    ) == trial,
    "Calibration trial exact-name lookup failed.");

echo("STRAP BENDER CALIBRATION TRIAL CONTRACT: PASS");
