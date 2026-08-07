//////////////////////////////////////////////////////////////////////
// LibFile: calibration_validation.scad
// Project: Strap Bender
// FileGroup: Forming Calibration Validation
// FileSummary: Validates measured radius evidence and material provenance.
//////////////////////////////////////////////////////////////////////

function sb_forming_method_valid(method) =
    method == "cold" ||
    method == "local_heat" ||
    method == "global_heat" ||
    method == "other";

function sb_cooling_restraint_valid(state) =
    state == "restrained" ||
    state == "released_hot" ||
    state == "not_applicable";


function radius_observation_completion_issues(observation, material_registry) =
    !(is_list(observation) && len(observation) == 19)
        ? ["radius observation record is structurally invalid"]
        : concat(
            sb_nonempty_string(radius_observation_name(observation))
                ? [] : ["observation name is empty"],
            sb_nonempty_string(
                radius_observation_strap_material_name(observation)
            )
                ? [] : ["strap-material name is empty"],
            len(records_named(
                material_registry,
                radius_observation_strap_material_name(observation)
            )) == 1
                ? [] : ["strap material does not resolve exactly once"],
            sb_nonempty_string(radius_observation_specimen_id(observation))
                ? [] : ["specimen ID is empty"],
            sb_finite_number(
                radius_observation_measured_width_mm(observation)
            ) && radius_observation_measured_width_mm(observation) > 0
                ? [] : ["measured specimen width must be greater than zero"],
            sb_finite_number(
                radius_observation_measured_thickness_mm(observation)
            ) && radius_observation_measured_thickness_mm(observation) > 0
                ? [] : ["measured specimen thickness must be greater than zero"],
            sb_finite_number(
                radius_observation_measured_width_mm(observation)
            ) && radius_observation_measured_width_mm(observation) > 0 &&
            sb_finite_number(
                radius_observation_measured_thickness_mm(observation)
            ) && radius_observation_measured_thickness_mm(observation) > 0 &&
            radius_observation_measured_thickness_mm(observation) >=
                radius_observation_measured_width_mm(observation)
                ? ["measured specimen thickness must be smaller than width"]
                : [],
            sb_bend_angle_valid(
                radius_observation_bend_angle_degrees(observation)
            )
                ? [] : ["observed bend angle is invalid"],
            sb_finite_number(
                radius_observation_tool_inside_radius_mm(observation)
            ) && radius_observation_tool_inside_radius_mm(observation) > 0
                ? [] : ["tool inside radius must be greater than zero"],
            sb_forming_method_valid(
                radius_observation_forming_method(observation)
            )
                ? [] : ["forming method is unset or invalid"],
            sb_finite_number(
                radius_observation_forming_temperature_c(observation)
            )
                ? [] : ["forming temperature must be finite"],
            sb_finite_number(radius_observation_dwell_seconds(observation)) &&
            radius_observation_dwell_seconds(observation) >= 0
                ? [] : ["dwell time must be nonnegative"],
            sb_cooling_restraint_valid(
                radius_observation_cooling_restraint(observation)
            )
                ? [] : ["cooling-restraint state is unset or invalid"],
            sb_finite_number(
                radius_observation_release_rest_seconds(observation)
            ) && radius_observation_release_rest_seconds(observation) >= 0
                ? [] : ["post-release rest time must be nonnegative"],
            sb_finite_number(
                radius_observation_measured_finished_inside_radius_mm(
                    observation
                )
            ) && radius_observation_measured_finished_inside_radius_mm(
                observation
            ) > 0
                ? [] : ["measured finished inside radius must be positive"],
            sb_nonempty_string(
                radius_observation_measurement_method(observation)
            )
                ? [] : ["measurement method is empty"],
            sb_nonempty_string(radius_observation_measured_date(observation))
                ? [] : ["measurement date is empty"],
            sb_finite_number(
                radius_observation_measurement_uncertainty_mm(observation)
            ) && radius_observation_measurement_uncertainty_mm(observation) >= 0
                ? [] : ["measurement uncertainty must be nonnegative"],
            is_string(radius_observation_notes(observation))
                ? [] : ["observation notes must be a string"]
        );

function radius_observation_complete(observation, material_registry) =
    len(radius_observation_completion_issues(
        observation,
        material_registry
    )) == 0;

module validate_radius_observation(observation, material_registry) {
    assert(is_list(observation) && len(observation) == 19,
        "Radius observation records must contain nineteen fields.");
    assert(observation[RO_RECORD_TYPE] ==
        STRAP_BENDER_RADIUS_OBSERVATION_RECORD,
        "Invalid Strap Bender radius observation record type.");
    assert(sb_schema_version_valid(observation[RO_SCHEMA_VERSION]),
        str("Unsupported radius observation schema version: ",
            observation[RO_SCHEMA_VERSION]));
    assert(sb_nonempty_string(radius_observation_name(observation)),
        "Radius observation name must be a non-empty string.");
    assert(sb_nonempty_string(
            radius_observation_strap_material_name(observation)),
        "Radius observation strap-material name must be non-empty.");
    assert(len(records_named(
            material_registry,
            radius_observation_strap_material_name(observation)
        )) == 1,
        str("Radius observation must reference exactly one strap material: ",
            radius_observation_strap_material_name(observation)));
    assert(sb_nonempty_string(radius_observation_specimen_id(observation)),
        "Radius observation specimen ID must be non-empty.");
    assert(sb_finite_number(
            radius_observation_measured_width_mm(observation)) &&
        radius_observation_measured_width_mm(observation) > 0,
        "Measured specimen width must be finite and greater than zero.");
    assert(sb_finite_number(
            radius_observation_measured_thickness_mm(observation)) &&
        radius_observation_measured_thickness_mm(observation) > 0,
        "Measured specimen thickness must be finite and greater than zero.");
    assert(radius_observation_measured_thickness_mm(observation) <
        radius_observation_measured_width_mm(observation),
        "Measured specimen thickness must be smaller than width.");
    assert(sb_bend_angle_valid(
            radius_observation_bend_angle_degrees(observation)),
        "Observed bend angle must be finite, nonzero, and below 360 degrees.");
    assert(sb_finite_number(
            radius_observation_tool_inside_radius_mm(observation)) &&
        radius_observation_tool_inside_radius_mm(observation) > 0,
        "Tool inside radius must be finite and greater than zero.");
    assert(sb_forming_method_valid(
            radius_observation_forming_method(observation)),
        str("Unknown forming method: ",
            radius_observation_forming_method(observation)));
    assert(sb_finite_number(
            radius_observation_forming_temperature_c(observation)),
        "Recorded forming temperature must be finite.");
    assert(sb_finite_number(radius_observation_dwell_seconds(observation)) &&
        radius_observation_dwell_seconds(observation) >= 0,
        "Dwell time must be finite and nonnegative.");
    assert(sb_cooling_restraint_valid(
            radius_observation_cooling_restraint(observation)),
        str("Unknown cooling-restraint state: ",
            radius_observation_cooling_restraint(observation)));
    assert(sb_finite_number(
            radius_observation_release_rest_seconds(observation)) &&
        radius_observation_release_rest_seconds(observation) >= 0,
        "Post-release rest time must be finite and nonnegative.");
    assert(sb_finite_number(
            radius_observation_measured_finished_inside_radius_mm(
                observation)) &&
        radius_observation_measured_finished_inside_radius_mm(observation) > 0,
        "Measured finished inside radius must be finite and positive.");
    assert(sb_nonempty_string(
            radius_observation_measurement_method(observation)),
        "Radius measurement method must be a non-empty string.");
    assert(sb_nonempty_string(radius_observation_measured_date(observation)),
        "Radius observation date must be a non-empty string.");
    assert(sb_finite_number(
            radius_observation_measurement_uncertainty_mm(observation)) &&
        radius_observation_measurement_uncertainty_mm(observation) >= 0,
        "Measurement uncertainty must be finite and nonnegative.");
    assert(is_string(radius_observation_notes(observation)),
        "Radius observation notes must be a string.");
}
