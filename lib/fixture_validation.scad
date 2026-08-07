//////////////////////////////////////////////////////////////////////
// LibFile: fixture_validation.scad
// Project: Strap Bender
// FileGroup: Fixture Validation
// FileSummary: Validates bend-post fixture specifications, plans, and clearances.
//////////////////////////////////////////////////////////////////////

function sb_bend_post_radius_mode_valid(mode) =
    mode == "nominal_target";
function sb_bend_post_retention_mode_valid(mode) =
    mode == "none" || mode == "arc_follower";

module validate_bend_post_fixture(fixture, material_registry) {
    assert(is_list(fixture) && len(fixture) == 17,
        "Bend-post fixture records must contain seventeen fields.");
    assert(fixture[BF_RECORD_TYPE] == STRAP_BENDER_BEND_POST_FIXTURE_RECORD,
        "Invalid bend-post fixture record type.");
    assert(sb_schema_version_valid(fixture[BF_SCHEMA_VERSION]),
        str("Unsupported bend-post fixture schema version: ",
            fixture[BF_SCHEMA_VERSION]));
    assert(sb_nonempty_string(bend_post_fixture_name(fixture)),
        "Bend-post fixture name must be non-empty.");
    assert(sb_nonempty_string(
            bend_post_fixture_strap_material_name(fixture)),
        "Bend-post fixture strap-material name must be non-empty.");
    assert(len(records_named(
            material_registry,
            bend_post_fixture_strap_material_name(fixture)
        )) == 1,
        str("Bend-post fixture must reference exactly one strap material: ",
            bend_post_fixture_strap_material_name(fixture)));
    assert(sb_bend_post_radius_mode_valid(
            bend_post_fixture_radius_mode(fixture)),
        str("Unsupported bend-post radius mode: ",
            bend_post_fixture_radius_mode(fixture)));
    assert(sb_finite_number(
            bend_post_fixture_base_thickness_mm(fixture)) &&
        bend_post_fixture_base_thickness_mm(fixture) > 0,
        "Fixture base thickness must be finite and positive.");
    assert(sb_finite_number(bend_post_fixture_base_margin_mm(fixture)) &&
        bend_post_fixture_base_margin_mm(fixture) >= 0,
        "Fixture base margin must be finite and nonnegative.");
    assert(sb_finite_number(bend_post_fixture_post_height_mm(fixture)) &&
        bend_post_fixture_post_height_mm(fixture) > 0,
        "Fixture post height must be finite and positive.");
    assert(sb_finite_number(bend_post_fixture_strap_clearance_mm(fixture)) &&
        bend_post_fixture_strap_clearance_mm(fixture) >= 0,
        "Fixture strap clearance must be finite and nonnegative.");
    assert(sb_finite_number(bend_post_fixture_minimum_post_gap_mm(fixture)) &&
        bend_post_fixture_minimum_post_gap_mm(fixture) >= 0,
        "Fixture minimum post gap must be finite and nonnegative.");
    assert(sb_finite_number(
            bend_post_fixture_max_base_width_mm(fixture)) &&
        bend_post_fixture_max_base_width_mm(fixture) > 0,
        "Fixture maximum base width must be finite and positive.");
    assert(sb_finite_number(
            bend_post_fixture_max_base_depth_mm(fixture)) &&
        bend_post_fixture_max_base_depth_mm(fixture) > 0,
        "Fixture maximum base depth must be finite and positive.");
    assert(sb_sampling_chord_error_valid(
            bend_post_fixture_tool_surface_chord_error_mm(fixture)),
        "Fixture tool-surface chord error must be positive.");
    assert(sb_sampling_max_angle_step_valid(
            bend_post_fixture_tool_surface_max_angle_step_degrees(fixture)),
        "Fixture tool-surface angular step must be within (0, 180].");
    assert(sb_bend_post_retention_mode_valid(
            bend_post_fixture_retention_mode(fixture)),
        str("Unsupported bend-post retention mode: ",
            bend_post_fixture_retention_mode(fixture)));
    assert(sb_finite_number(
            bend_post_fixture_follower_wall_thickness_mm(fixture)) &&
        bend_post_fixture_follower_wall_thickness_mm(fixture) > 0,
        "Fixture follower wall thickness must be finite and positive.");
    assert(is_string(bend_post_fixture_notes(fixture)),
        "Bend-post fixture notes must be a string.");

    material = named_record(
        material_registry,
        bend_post_fixture_strap_material_name(fixture),
        "strap material"
    );
    assert(bend_post_fixture_post_height_mm(fixture) >=
        strap_material_nominal_width_mm(material),
        str("Fixture post height must be at least the nominal strap width of ",
            strap_material_nominal_width_mm(material), " mm."));
}

module validate_bend_post_station(station, fixture) {
    assert(is_list(station) && len(station) == 15,
        "Bend-post station records must contain fifteen fields.");
    assert(station[BS_RECORD_TYPE] == STRAP_BENDER_BEND_POST_STATION_RECORD,
        "Invalid bend-post station record type.");
    assert(sb_schema_version_valid(station[BS_SCHEMA_VERSION]),
        str("Unsupported bend-post station schema version: ",
            station[BS_SCHEMA_VERSION]));
    assert(sb_nonnegative_integer(bend_post_station_source_index(station)),
        "Bend-post source index must be nonnegative.");
    assert(is_string(bend_post_station_label(station)),
        "Bend-post station label must be a string.");
    assert(sb_finite_number(bend_post_station_station_start(station)) &&
        bend_post_station_station_start(station) >= 0,
        "Bend-post station start must be nonnegative.");
    assert(sb_finite_number(bend_post_station_station_end(station)) &&
        bend_post_station_station_end(station) >
            bend_post_station_station_start(station),
        "Bend-post station end must exceed its start.");
    assert(sb_point_valid(bend_post_station_target_center(station)),
        "Bend-post target center must be a finite XY point.");
    assert(sb_point_valid(bend_post_station_tool_center(station)),
        "Bend-post tool center must be a finite XY point.");
    assert(sb_bend_angle_valid(bend_post_station_angle_degrees(station)),
        "Bend-post angle is outside the supported domain.");
    assert(sb_finite_number(
            bend_post_station_target_inside_radius_mm(station)) &&
        bend_post_station_target_inside_radius_mm(station) > 0,
        "Bend-post target inside radius must be positive.");
    assert(sb_finite_number(
            bend_post_station_tool_inside_radius_mm(station)) &&
        bend_post_station_tool_inside_radius_mm(station) > 0,
        "Bend-post tool inside radius must be positive.");
    assert(sb_point_valid(bend_post_station_target_entry_point(station)) &&
        sb_point_valid(bend_post_station_target_exit_point(station)) &&
        sb_point_valid(bend_post_station_tool_entry_point(station)) &&
        sb_point_valid(bend_post_station_tool_exit_point(station)),
        "Bend-post target/tool tangent datums must be finite XY points.");
    if (bend_post_fixture_radius_mode(fixture) == "nominal_target") {
        assert(sb_near(
                bend_post_station_tool_inside_radius_mm(station),
                bend_post_station_target_inside_radius_mm(station),
                SB_NUMERIC_POSITION_TOLERANCE_MM
            ),
            "Nominal fixture mode must preserve target radius exactly.");
        assert(sb_point_distance(
                bend_post_station_tool_center(station),
                bend_post_station_target_center(station)
            ) <= SB_NUMERIC_POSITION_TOLERANCE_MM,
            "Nominal fixture mode must preserve the target arc center.");
        assert(sb_point_distance(
                bend_post_station_tool_entry_point(station),
                bend_post_station_target_entry_point(station)
            ) <= SB_NUMERIC_POSITION_TOLERANCE_MM &&
            sb_point_distance(
                bend_post_station_tool_exit_point(station),
                bend_post_station_target_exit_point(station)
            ) <= SB_NUMERIC_POSITION_TOLERANCE_MM,
            "Nominal fixture mode must preserve target tangent datums.");
    }
    assert(bend_post_fixture_tool_surface_chord_error_mm(fixture) <
        bend_post_station_tool_inside_radius_mm(station),
        str("Fixture chord error must be smaller than tool radius at source ",
            bend_post_station_source_index(station), "."));
    assert(bend_post_station_actual_surface_sagitta_mm(station, fixture) <=
        bend_post_fixture_tool_surface_chord_error_mm(fixture) + 1e-9,
        "Resolved post tessellation exceeds requested chord error.");
}

module validate_bend_post_fixture_plan(
    plan,
    fixture,
    analytical_path,
    material_registry,
    enforce_print_envelope = true
) {
    validate_bend_post_fixture(fixture, material_registry);
    assert(is_list(plan) && len(plan) == 10,
        "Bend-post fixture plan records must contain ten fields.");
    assert(plan[BP_RECORD_TYPE] ==
        STRAP_BENDER_BEND_POST_FIXTURE_PLAN_RECORD,
        "Invalid bend-post fixture plan record type.");
    assert(sb_schema_version_valid(plan[BP_SCHEMA_VERSION]),
        str("Unsupported bend-post fixture plan schema version: ",
            plan[BP_SCHEMA_VERSION]));
    assert(bend_post_fixture_plan_fixture_name(plan) ==
        bend_post_fixture_name(fixture),
        "Fixture plan must preserve source fixture identity.");
    assert(bend_post_fixture_plan_source_path_name(plan) ==
        analytical_path_name(analytical_path),
        "Fixture plan must preserve source analytical-path identity.");
    assert(bend_post_fixture_plan_reference_axis(plan) ==
        analytical_path_reference_axis(analytical_path),
        "Fixture plan must preserve analytical reference axis.");
    assert(bend_post_fixture_plan_status(plan) ==
        "experimental_uncompensated",
        "Nominal bend-post fixture plan must be marked experimental.");
    assert(is_string(bend_post_fixture_plan_notes(plan)),
        "Bend-post fixture plan notes must be a string.");
    material = named_record(
        material_registry,
        bend_post_fixture_strap_material_name(fixture),
        "strap material"
    );
    expected_thickness = strap_material_nominal_thickness_mm(material);
    assert(sb_near(
            bend_post_fixture_plan_nominal_strap_thickness_mm(plan),
            expected_thickness,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Fixture plan must preserve the referenced nominal strap thickness.");

    stations = bend_post_fixture_plan_stations(plan);
    arc_count = len([
        for (primitive = analytical_path_primitives(analytical_path))
            if (primitive_kind(primitive) == "arc") primitive
    ]);
    assert(is_list(stations) && len(stations) == arc_count,
        "Fixture plan must create exactly one station per analytical arc.");
    assert(len(stations) > 0,
        "The bend-post fixture family requires at least one bend.");
    for (station = stations) {
        validate_bend_post_station(station, fixture);
        if (sb_bend_post_retention_enabled(fixture)) {
            assert(sb_bend_post_follower_inner_radius_mm(
                    station, fixture, expected_thickness
                ) > bend_post_station_tool_inside_radius_mm(station),
                "Arc follower must remain outside the inside-form post.");
            assert(sb_bend_post_follower_actual_surface_sagitta_mm(
                    station, fixture, expected_thickness
                ) <=
                bend_post_fixture_tool_surface_chord_error_mm(fixture) + 1e-9,
                "Resolved follower tessellation exceeds requested chord error.");
            assert(len(sb_bend_post_follower_polygon_points(
                    station, fixture, expected_thickness
                )) >= 4,
                "Arc follower polygon must contain at least four points.");
        }
    }

    bounds = bend_post_fixture_plan_base_bounds(plan);
    assert(sb_bounds_valid(bounds),
        "Fixture base bounds must be finite and ordered.");
    if (enforce_print_envelope) {
        assert(bend_post_fixture_plan_base_width_mm(plan) <=
            bend_post_fixture_max_base_width_mm(fixture) +
                SB_NUMERIC_POSITION_TOLERANCE_MM,
            str("Fixture base width ", bend_post_fixture_plan_base_width_mm(plan),
                " mm exceeds configured print envelope ",
                bend_post_fixture_max_base_width_mm(fixture), " mm."));
        assert(bend_post_fixture_plan_base_depth_mm(plan) <=
            bend_post_fixture_max_base_depth_mm(fixture) +
                SB_NUMERIC_POSITION_TOLERANCE_MM,
            str("Fixture base depth ", bend_post_fixture_plan_base_depth_mm(plan),
                " mm exceeds configured print envelope ",
                bend_post_fixture_max_base_depth_mm(fixture), " mm."));
    }
}

module validate_fixture_clearance_issue(issue) {
    assert(is_list(issue) && len(issue) == 8,
        "Fixture clearance issue records must contain eight fields.");
    assert(issue[CI_RECORD_TYPE] == STRAP_BENDER_FIXTURE_CLEARANCE_ISSUE_RECORD,
        "Invalid fixture clearance issue record type.");
    assert(sb_schema_version_valid(issue[CI_SCHEMA_VERSION]),
        "Unsupported fixture clearance issue schema version.");
    assert(fixture_clearance_issue_kind(issue) == "post_post" ||
            fixture_clearance_issue_kind(issue) == "post_path",
        "Fixture clearance issue kind must be post_post or post_path.");
    assert(sb_nonnegative_integer(
            fixture_clearance_issue_primary_source_index(issue)) &&
        sb_nonnegative_integer(
            fixture_clearance_issue_secondary_source_index(issue)),
        "Fixture clearance issue source indexes must be nonnegative integers.");
    assert(sb_finite_number(fixture_clearance_issue_measured_gap_mm(issue)),
        "Fixture clearance measured gap must be finite.");
    assert(sb_finite_number(fixture_clearance_issue_required_gap_mm(issue)) &&
        fixture_clearance_issue_required_gap_mm(issue) >= 0,
        "Fixture clearance required gap must be finite and nonnegative.");
    assert(is_string(fixture_clearance_issue_label(issue)),
        "Fixture clearance issue label must be a string.");
}
module validate_bend_post_fixture_clearance(
    report,
    plan,
    fixture,
    analytical_path,
    material_registry
) {
    assert(is_list(report) && len(report) == 12,
        "Fixture clearance reports must contain twelve fields.");
    assert(report[CR_RECORD_TYPE] == STRAP_BENDER_FIXTURE_CLEARANCE_REPORT_RECORD,
        "Invalid fixture clearance report record type.");
    assert(sb_schema_version_valid(report[CR_SCHEMA_VERSION]),
        "Unsupported fixture clearance report schema version.");
    assert(fixture_clearance_report_fixture_name(report) ==
        bend_post_fixture_name(fixture),
        "Clearance report must preserve fixture identity.");
    assert(fixture_clearance_report_source_path_name(report) ==
        analytical_path_name(analytical_path),
        "Clearance report must preserve analytical-path identity.");
    assert(bend_post_fixture_plan_fixture_name(plan) ==
        fixture_clearance_report_fixture_name(report),
        "Clearance report and fixture plan must reference the same fixture.");
    material = named_record(
        material_registry,
        bend_post_fixture_strap_material_name(fixture),
        "strap material"
    );
    expected_thickness = strap_material_nominal_thickness_mm(material);
    expected_path_gap = sb_fixture_required_nonlocal_path_gap_mm(
        fixture, expected_thickness
    );
    expected_post_gap = sb_fixture_required_post_pair_gap_mm(
        fixture, expected_thickness
    );
    assert(sb_near(
            fixture_clearance_report_nominal_strap_thickness_mm(report),
            expected_thickness,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Clearance report must preserve nominal strap thickness.");
    assert(sb_near(
            fixture_clearance_report_required_nonlocal_path_gap_mm(report),
            expected_path_gap,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Clearance report required path gap is inconsistent with fixture policy.");
    assert(sb_near(
            fixture_clearance_report_required_post_gap_mm(report),
            expected_post_gap,
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Clearance report required post gap is inconsistent with fixture policy.");
    pair_issues = fixture_clearance_report_post_pair_issues(report);
    path_issues = fixture_clearance_report_post_path_issues(report);
    assert(is_list(pair_issues) && is_list(path_issues),
        "Fixture clearance issue collections must be lists.");
    for (issue = pair_issues)
        validate_fixture_clearance_issue(issue);
    for (issue = path_issues)
        validate_fixture_clearance_issue(issue);
    pair_min = fixture_clearance_report_minimum_post_pair_gap_mm(report);
    path_min = fixture_clearance_report_minimum_post_path_gap_mm(report);
    assert(is_undef(pair_min) || sb_finite_number(pair_min),
        "Minimum post-pair gap must be finite or undefined when no pair exists.");
    assert(is_undef(path_min) || sb_finite_number(path_min),
        "Minimum post/path gap must be finite or undefined when none exists.");
    assert(is_string(fixture_clearance_report_notes(report)),
        "Fixture clearance report notes must be a string.");
    assert(len(pair_issues) == 0,
        str("Fixture post/post retention-envelope clearance failed with ",
            len(pair_issues),
            " issue(s). Increase spacing, reduce tool radii/follower extent, ",
            "or segment the fixture."));
    assert(len(path_issues) == 0,
        str("Fixture post/nonlocal-path retention-envelope clearance failed with ",
            len(path_issues),
            " issue(s). The target path approaches an unrelated bend station ",
            "too closely for the configured strap slot/follower policy."));
}

