//////////////////////////////////////////////////////////////////////
// LibFile: calibration_reporting.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Reporting
// FileSummary: Reports one measured bend without fitting compensation.
//////////////////////////////////////////////////////////////////////

module report_radius_observation(observation, report_level = "full") {
    echo(str("RADIUS OBSERVATION: ", radius_observation_name(observation)));
    echo(str("  strap material: ",
        radius_observation_strap_material_name(observation)));
    echo(str("  specimen: ", radius_observation_specimen_id(observation)));
    echo(str("  measured width/thickness: ",
        radius_observation_measured_width_mm(observation), " / ",
        radius_observation_measured_thickness_mm(observation), " mm"));
    echo(str("  bend angle: ",
        radius_observation_bend_angle_degrees(observation), " deg"));
    echo(str("  tool inside radius: ",
        radius_observation_tool_inside_radius_mm(observation), " mm"));
    echo(str("  measured finished inside radius: ",
        radius_observation_measured_finished_inside_radius_mm(observation),
        " mm"));
    echo(str("  measured springback delta: ",
        radius_observation_springback_delta_mm(observation), " mm"));
    echo(str("  finished/tool radius ratio: ",
        radius_observation_finished_to_tool_ratio(observation)));
    echo(str("  forming method/temperature: ",
        radius_observation_forming_method(observation), " / ",
        radius_observation_forming_temperature_c(observation), " C"));
    echo(str("  dwell/cooling/rest: ",
        radius_observation_dwell_seconds(observation), " s / ",
        radius_observation_cooling_restraint(observation), " / ",
        radius_observation_release_rest_seconds(observation), " s"));
    echo(str("  measured date: ",
        radius_observation_measured_date(observation)));
    if (report_level == "full") {
        echo(str("  measurement method: ",
            radius_observation_measurement_method(observation)));
        echo(str("  stated measurement uncertainty: +/-",
            radius_observation_measurement_uncertainty_mm(observation),
            " mm"));
        echo(str("  notes: ", radius_observation_notes(observation)));
    }
}
