//////////////////////////////////////////////////////////////////////
// LibFile: fixture_validation.scad
// Project: Strap Bender
// FileGroup: Fixture Validation
// FileSummary: Validates nominal bend-post fixture specifications and plans.
//////////////////////////////////////////////////////////////////////

function sb_bend_post_radius_mode_valid(mode) =
    mode == "nominal_target";
function sb_bend_post_retention_mode_valid(mode) =
    mode == "none";

module validate_bend_post_fixture(fixture, material_registry) {
    assert(is_list(fixture) && len(fixture) == 14,
        "Bend-post fixture records must contain fourteen fields.");
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
    material_registry
) {
    validate_bend_post_fixture(fixture, material_registry);
    assert(is_list(plan) && len(plan) == 9,
        "Bend-post fixture plan records must contain nine fields.");
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

    stations = bend_post_fixture_plan_stations(plan);
    arc_count = len([
        for (primitive = analytical_path_primitives(analytical_path))
            if (primitive_kind(primitive) == "arc") primitive
    ]);
    assert(is_list(stations) && len(stations) == arc_count,
        "Fixture plan must create exactly one station per analytical arc.");
    assert(len(stations) > 0,
        "The bend-post fixture family requires at least one bend.");
    for (station = stations)
        validate_bend_post_station(station, fixture);

    bounds = bend_post_fixture_plan_base_bounds(plan);
    assert(sb_bounds_valid(bounds),
        "Fixture base bounds must be finite and ordered.");
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
