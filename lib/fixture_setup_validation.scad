//////////////////////////////////////////////////////////////////////
// LibFile: fixture_setup_validation.scad
// Project: Strap Bender
// FileGroup: Fixture Setup Aid Validation
// FileSummary: Validates shared registration holes and component marks.
//////////////////////////////////////////////////////////////////////

module validate_fixture_setup_aid_source(setup) {
    assert(is_list(setup) && len(setup) == 12,
        "Fixture setup-aid records must contain twelve fields.");
    assert(setup[FSA_RECORD_TYPE] == STRAP_BENDER_FIXTURE_SETUP_AID_RECORD,
        "Invalid fixture setup-aid record type.");
    assert(sb_schema_version_valid(setup[FSA_SCHEMA_VERSION]),
        "Unsupported fixture setup-aid schema version.");
    assert(sb_nonempty_string(fixture_setup_aid_name(setup)),
        "Fixture setup-aid name must be non-empty.");
    assert(sb_fixture_setup_registration_mode_valid(
            fixture_setup_aid_registration_mode(setup)),
        str("Unsupported fixture registration mode: ",
            fixture_setup_aid_registration_mode(setup)));
    assert(sb_finite_number(
            fixture_setup_aid_pin_nominal_diameter_mm(setup)) &&
        fixture_setup_aid_pin_nominal_diameter_mm(setup) > 0,
        "Fixture registration-pin nominal diameter must be positive.");
    assert(sb_finite_number(
            fixture_setup_aid_hole_diametral_clearance_mm(setup)) &&
        fixture_setup_aid_hole_diametral_clearance_mm(setup) >= 0,
        "Fixture registration-hole diametral clearance must be nonnegative.");
    assert(sb_finite_number(fixture_setup_aid_tangent_spacing_mm(setup)) &&
        fixture_setup_aid_tangent_spacing_mm(setup) >
            fixture_setup_aid_hole_diameter_mm(setup),
        "Fixture registration-hole center spacing must exceed hole diameter.");
    assert(sb_finite_number(fixture_setup_aid_normal_offset_mm(setup)) &&
        fixture_setup_aid_normal_offset_mm(setup) >
            fixture_setup_aid_hole_radius_mm(setup),
        "Fixture registration-hole normal offset must exceed hole radius.");
    assert(sb_fixture_setup_label_mode_valid(
            fixture_setup_aid_label_mode(setup)),
        str("Unsupported fixture component-label mode: ",
            fixture_setup_aid_label_mode(setup)));
    assert(sb_finite_number(fixture_setup_aid_label_size_mm(setup)) &&
        fixture_setup_aid_label_size_mm(setup) > 0,
        "Fixture component-label size must be positive.");
    assert(sb_finite_number(fixture_setup_aid_label_depth_mm(setup)) &&
        fixture_setup_aid_label_depth_mm(setup) > 0,
        "Fixture component-label depth must be positive.");
    assert(is_string(fixture_setup_aid_notes(setup)),
        "Fixture setup-aid notes must be a string.");
}

module validate_fixture_setup_aid(
    setup,
    segmentation,
    full_plan,
    fixture,
    path
) {
    validate_fixture_setup_aid_source(setup);
    assert(fixture_setup_aid_label_depth_mm(setup) <
        bend_post_fixture_base_thickness_mm(fixture),
        "Recessed component-label depth must be less than base thickness.");
    assert(!sb_fixture_setup_label_enabled(setup) ||
        bend_post_fixture_base_margin_mm(fixture) >=
            2 * fixture_setup_aid_label_size_mm(setup) + 1,
        "Base margin is too small for the recessed component index mark.");

    if (sb_fixture_setup_registration_enabled(setup)) {
        required_path_clearance =
            bend_post_fixture_plan_nominal_strap_thickness_mm(full_plan) +
            bend_post_fixture_strap_clearance_mm(fixture);
        components = fixture_segmentation_plan_components(segmentation);
        for (component = components) {
            points = sb_fixture_component_registration_points(component, setup);
            for (point = points) {
                assert(sb_fixture_setup_circle_inside_bounds(
                        point,
                        fixture_setup_aid_hole_radius_mm(setup),
                        fixture_component_base_bounds(component)
                    ),
                    str("Registration hole falls outside component base: ",
                        fixture_component_id(component), " at ", point));
                assert(sb_fixture_setup_registration_edge_clearance_mm(
                        point, setup, path
                    ) + SB_NUMERIC_POSITION_TOLERANCE_MM >=
                        required_path_clearance,
                    str("Registration hole is too close to the strap path on ",
                        fixture_component_id(component), " at ", point, "."));
                for (station = bend_post_fixture_plan_stations(full_plan))
                    assert(sb_fixture_setup_registration_to_station_gap_mm(
                            point, station, setup, full_plan, fixture
                        ) + SB_NUMERIC_POSITION_TOLERANCE_MM >=
                            bend_post_fixture_minimum_post_gap_mm(fixture),
                        str("Registration hole is too close to bend tooling on ",
                            fixture_component_id(component), " at ", point,
                            "; bend source ",
                            bend_post_station_source_index(station), "."));
            }
        }

        if (len(components) > 1)
            for (index = [1 : len(components) - 1]) {
                previous = components[index - 1];
                current = components[index];
                previous_points = sb_fixture_datum_registration_points(
                    fixture_component_end_datum(previous), setup
                );
                current_points = sb_fixture_datum_registration_points(
                    fixture_component_start_datum(current), setup
                );
                assert(sb_fixture_setup_points_near(
                        previous_points,
                        current_points,
                        SB_NUMERIC_POSITION_TOLERANCE_MM
                    ),
                    "Adjacent components must share an exact registration pair.");
            }
    }
}
