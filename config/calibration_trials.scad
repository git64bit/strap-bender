//////////////////////////////////////////////////////////////////////
// LibFile: calibration_trials.scad
// Project: Strap Bender
// FileGroup: Calibration Evidence Router
// FileSummary: Builds one guarded coupon-linked observation trial.
//////////////////////////////////////////////////////////////////////

WORKBENCH_CALIBRATION_TRIAL_COUPON =
    wb_workbench_name == "radius_observation"
        ? named_record(
            RADIUS_CALIBRATION_COUPONS,
            wb_calibration_trial_coupon_name,
            "radius calibration coupon"
        )
        : undef;

WORKBENCH_RADIUS_OBSERVATION =
    wb_workbench_name == "radius_observation" &&
    wb_calibration_trial_ready
        ? radius_observation_spec(
            name = wb_radius_observation_name,
            strap_material_name = radius_coupon_strap_material_name(
                WORKBENCH_CALIBRATION_TRIAL_COUPON
            ),
            specimen_id = wb_radius_observation_specimen_id,
            measured_width_mm = wb_radius_observation_measured_width_mm,
            measured_thickness_mm =
                wb_radius_observation_measured_thickness_mm,
            bend_angle_degrees = radius_coupon_bend_angle_degrees(
                WORKBENCH_CALIBRATION_TRIAL_COUPON
            ),
            tool_inside_radius_mm = radius_coupon_tool_inside_radius_mm(
                WORKBENCH_CALIBRATION_TRIAL_COUPON
            ),
            forming_method = wb_radius_observation_forming_method,
            forming_temperature_c =
                wb_radius_observation_forming_temperature_c,
            dwell_seconds = wb_radius_observation_dwell_seconds,
            cooling_restraint =
                wb_radius_observation_cooling_restraint,
            release_rest_seconds =
                wb_radius_observation_release_rest_seconds,
            measured_finished_inside_radius_mm =
                wb_radius_observation_finished_radius_mm,
            measurement_method =
                wb_radius_observation_measurement_method,
            measured_date = wb_radius_observation_measured_date,
            measurement_uncertainty_mm =
                wb_radius_observation_measurement_uncertainty_mm,
            notes = wb_radius_observation_notes
        )
        : undef;

WORKBENCH_CALIBRATION_TRIAL =
    wb_workbench_name == "radius_observation" &&
    wb_calibration_trial_ready
        ? calibration_trial_spec(
            name = wb_calibration_trial_name,
            coupon_name = wb_calibration_trial_coupon_name,
            observation = WORKBENCH_RADIUS_OBSERVATION,
            notes = str(
                "Transient Customizer trial. Persist only after physical ",
                "values, process, and measurement provenance are reviewed."
            )
        )
        : undef;
