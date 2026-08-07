//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trial_reporting.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Reporting
// FileSummary: Reports one coupon-linked trial without fitting compensation.
//////////////////////////////////////////////////////////////////////

module report_calibration_trial(
    trial,
    coupon,
    report_level = "full"
) {
    observation = calibration_trial_observation(trial);

    echo(str("CALIBRATION TRIAL: ", calibration_trial_name(trial)));
    echo(str("  source coupon: ", calibration_trial_coupon_name(trial)));
    echo(str("  designed tool radius/angle: ",
        radius_coupon_tool_inside_radius_mm(coupon), " mm / ",
        radius_coupon_bend_angle_degrees(coupon), " deg"));
    echo(str("  strap material: ",
        radius_coupon_strap_material_name(coupon)));
    echo("  status: measured evidence only; no compensation model fitted");
    if (report_level == "full") {
        echo(str("  trial notes: ", calibration_trial_notes(trial)));
    }

    report_radius_observation(observation, report_level);
}


module report_calibration_trial_registry(
    trials,
    coupon_registry,
    report_level = "full"
) {
    echo("CALIBRATION EVIDENCE REGISTRY");
    echo(str("  registered physical trials: ", len(trials)));

    if (len(trials) == 0) {
        echo("  status: no physical calibration trials registered");
        echo("  compensation fitting remains blocked");
    }

    for (trial = trials) {
        coupon = named_record(
            coupon_registry,
            calibration_trial_coupon_name(trial),
            "radius calibration coupon"
        );
        report_calibration_trial(trial, coupon, report_level);
    }
}
