//////////////////////////////////////////////////////////////////////
// LibFile: calibration_schema.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Data Model
// FileSummary: Constructor for auditable physical radius observations.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_RADIUS_OBSERVATION_RECORD =
    "strap_bender_radius_observation";

function radius_observation_spec(
    name,
    strap_material_name,
    specimen_id,
    measured_width_mm,
    measured_thickness_mm,
    bend_angle_degrees,
    tool_inside_radius_mm,
    forming_method,
    forming_temperature_c,
    dwell_seconds,
    cooling_restraint,
    release_rest_seconds,
    measured_finished_inside_radius_mm,
    measurement_method,
    measured_date,
    measurement_uncertainty_mm,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_RADIUS_OBSERVATION_RECORD,
    schema_version,
    name,
    strap_material_name,
    specimen_id,
    measured_width_mm,
    measured_thickness_mm,
    bend_angle_degrees,
    tool_inside_radius_mm,
    forming_method,
    forming_temperature_c,
    dwell_seconds,
    cooling_restraint,
    release_rest_seconds,
    measured_finished_inside_radius_mm,
    measurement_method,
    measured_date,
    measurement_uncertainty_mm,
    notes
];
