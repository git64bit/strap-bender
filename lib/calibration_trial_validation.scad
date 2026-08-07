//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_validation.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Validation
// FileSummary: Validates one observation against its named printed coupon.
//////////////////////////////////////////////////////////////////////

module validate_calibration_trial(
    trial,
    material_registry,
    coupon_registry
) {
    assert(is_list(trial) && len(trial) == 6,
        "Calibration trial records must contain six fields.");
    assert(trial[CT_RECORD_TYPE] == STRAP_BENDER_CALIBRATION_TRIAL_RECORD,
        "Invalid Strap Bender calibration trial record type.");
    assert(sb_schema_version_valid(trial[CT_SCHEMA_VERSION]),
        str("Unsupported calibration trial schema version: ",
            trial[CT_SCHEMA_VERSION]));
    assert(sb_nonempty_string(calibration_trial_name(trial)),
        "Calibration trial name must be a non-empty string.");
    assert(sb_nonempty_string(calibration_trial_coupon_name(trial)),
        "Calibration trial coupon name must be a non-empty string.");
    assert(is_string(calibration_trial_notes(trial)),
        "Calibration trial notes must be a string.");

    observation = calibration_trial_observation(trial);
    validate_radius_observation(observation, material_registry);

    coupon = named_record(
        coupon_registry,
        calibration_trial_coupon_name(trial),
        "radius calibration coupon"
    );
    validate_radius_calibration_coupon(coupon, material_registry);

    assert(radius_observation_strap_material_name(observation) ==
        radius_coupon_strap_material_name(coupon),
        "Calibration trial observation material must match source coupon.");
    assert(sb_near(
        radius_observation_tool_inside_radius_mm(observation),
        radius_coupon_tool_inside_radius_mm(coupon),
        SB_NUMERIC_POSITION_TOLERANCE_MM
    ), "Calibration trial tool radius must match source coupon.");
    assert(sb_near(
        radius_observation_bend_angle_degrees(observation),
        radius_coupon_bend_angle_degrees(coupon),
        SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
    ), "Calibration trial bend angle must match source coupon.");
}


function calibration_trial_registry_names_unique(trials) =
    len(trials) == 0
        ? true
        : len([
            for (trial = trials)
                if (len(records_named(
                    trials,
                    calibration_trial_name(trial)
                )) != 1)
                    calibration_trial_name(trial)
        ]) == 0;

module validate_calibration_trial_registry(
    trials,
    material_registry,
    coupon_registry
) {
    assert(is_list(trials),
        "Calibration trial registry must be a list.");

    for (trial = trials)
        validate_calibration_trial(
            trial,
            material_registry,
            coupon_registry
        );

    assert(calibration_trial_registry_names_unique(trials),
        "Calibration trial registry names must be unique.");
}
