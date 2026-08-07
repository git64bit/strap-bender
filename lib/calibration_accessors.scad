//////////////////////////////////////////////////////////////////////
// LibFile: calibration_accessors.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Data Model
// FileSummary: Named accessors and direct derived metrics for observations.
//////////////////////////////////////////////////////////////////////

function radius_observation_name(observation) = observation[RO_NAME];
function radius_observation_strap_material_name(observation) =
    observation[RO_STRAP_MATERIAL_NAME];
function radius_observation_specimen_id(observation) =
    observation[RO_SPECIMEN_ID];
function radius_observation_measured_width_mm(observation) =
    observation[RO_MEASURED_WIDTH_MM];
function radius_observation_measured_thickness_mm(observation) =
    observation[RO_MEASURED_THICKNESS_MM];
function radius_observation_bend_angle_degrees(observation) =
    observation[RO_BEND_ANGLE_DEGREES];
function radius_observation_tool_inside_radius_mm(observation) =
    observation[RO_TOOL_INSIDE_RADIUS_MM];
function radius_observation_forming_method(observation) =
    observation[RO_FORMING_METHOD];
function radius_observation_forming_temperature_c(observation) =
    observation[RO_FORMING_TEMPERATURE_C];
function radius_observation_dwell_seconds(observation) =
    observation[RO_DWELL_SECONDS];
function radius_observation_cooling_restraint(observation) =
    observation[RO_COOLING_RESTRAINT];
function radius_observation_release_rest_seconds(observation) =
    observation[RO_RELEASE_REST_SECONDS];
function radius_observation_measured_finished_inside_radius_mm(observation) =
    observation[RO_MEASURED_FINISHED_INSIDE_RADIUS_MM];
function radius_observation_measurement_method(observation) =
    observation[RO_MEASUREMENT_METHOD];
function radius_observation_measured_date(observation) =
    observation[RO_MEASURED_DATE];
function radius_observation_measurement_uncertainty_mm(observation) =
    observation[RO_MEASUREMENT_UNCERTAINTY_MM];
function radius_observation_notes(observation) = observation[RO_NOTES];

// Direct observations may be summarized without asserting a compensation model.
function radius_observation_springback_delta_mm(observation) =
    radius_observation_measured_finished_inside_radius_mm(observation) -
    radius_observation_tool_inside_radius_mm(observation);
function radius_observation_finished_to_tool_ratio(observation) =
    radius_observation_measured_finished_inside_radius_mm(observation) /
    radius_observation_tool_inside_radius_mm(observation);
function radius_observation_tool_to_finished_ratio(observation) =
    radius_observation_tool_inside_radius_mm(observation) /
    radius_observation_measured_finished_inside_radius_mm(observation);
