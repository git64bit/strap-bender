//////////////////////////////////////////////////////////////////////
// LibFile: fixture_segmentation_validation.scad
// Project: Strap Bender
// FileGroup: Fixture Segmentation Validation
// FileSummary: Validates long-form component manifests and assembly datums.
//////////////////////////////////////////////////////////////////////

function sb_fixture_layout_mode_valid(mode) =
    mode == "auto" || mode == "full_form" || mode == "segmented";

module validate_fixture_assembly_datum(datum) {
    assert(is_list(datum) && len(datum) == 8,
        "Fixture assembly datum records must contain eight fields.");
    assert(datum[FD_RECORD_TYPE] ==
        STRAP_BENDER_FIXTURE_ASSEMBLY_DATUM_RECORD,
        "Invalid fixture assembly datum record type.");
    assert(sb_schema_version_valid(datum[FD_SCHEMA_VERSION]),
        "Unsupported fixture assembly datum schema version.");
    assert(sb_finite_number(fixture_datum_station_mm(datum)) &&
        fixture_datum_station_mm(datum) >= 0,
        "Fixture datum station must be finite and nonnegative.");
    assert(sb_point_valid(fixture_datum_point(datum)),
        "Fixture datum point must be a finite XY point.");
    assert(sb_finite_number(fixture_datum_heading_degrees(datum)),
        "Fixture datum heading must be finite.");
    assert(fixture_datum_role(datum) == "path_start" ||
        fixture_datum_role(datum) == "component_split" ||
        fixture_datum_role(datum) == "path_end",
        str("Unsupported fixture datum role: ", fixture_datum_role(datum)));
    assert(sb_nonnegative_integer(fixture_datum_source_index(datum)),
        "Fixture datum source index must be a nonnegative integer.");
    assert(is_string(fixture_datum_label(datum)),
        "Fixture datum label must be a string.");
}

module validate_fixture_component(component, fixture, expected_index) {
    assert(is_list(component) && len(component) == 11,
        "Fixture component records must contain eleven fields.");
    assert(component[FC_RECORD_TYPE] == STRAP_BENDER_FIXTURE_COMPONENT_RECORD,
        "Invalid fixture component record type.");
    assert(sb_schema_version_valid(component[FC_SCHEMA_VERSION]),
        "Unsupported fixture component schema version.");
    assert(sb_nonempty_string(fixture_component_id(component)),
        "Fixture component ID must be non-empty.");
    assert(fixture_component_index(component) == expected_index,
        "Fixture component indexes must be contiguous and zero-based.");
    assert(fixture_component_station_start_mm(component) >= 0 &&
        fixture_component_station_end_mm(component) >
            fixture_component_station_start_mm(component),
        "Fixture component station interval must be increasing.");
    validate_fixture_assembly_datum(fixture_component_start_datum(component));
    validate_fixture_assembly_datum(fixture_component_end_datum(component));
    assert(sb_near(
            fixture_datum_station_mm(fixture_component_start_datum(component)),
            fixture_component_station_start_mm(component),
            SB_NUMERIC_STATION_TOLERANCE_MM
        ) &&
        sb_near(
            fixture_datum_station_mm(fixture_component_end_datum(component)),
            fixture_component_station_end_mm(component),
            SB_NUMERIC_STATION_TOLERANCE_MM
        ),
        "Fixture component datums must preserve component station boundaries.");
    assert(is_list(fixture_component_bend_stations(component)),
        "Fixture component bend stations must be a list.");
    for (station = fixture_component_bend_stations(component))
        validate_bend_post_station(station, fixture);
    assert(sb_bounds_valid(fixture_component_base_bounds(component)),
        "Fixture component base bounds must be finite and ordered.");
    assert(fixture_component_base_width_mm(component) <=
            bend_post_fixture_max_base_width_mm(fixture) +
                SB_NUMERIC_POSITION_TOLERANCE_MM &&
        fixture_component_base_depth_mm(component) <=
            bend_post_fixture_max_base_depth_mm(fixture) +
                SB_NUMERIC_POSITION_TOLERANCE_MM,
        str("Fixture component ", fixture_component_id(component),
            " exceeds the configured print envelope."));
    assert(is_string(fixture_component_notes(component)),
        "Fixture component notes must be a string.");
}

module validate_bend_post_fixture_segmentation(
    segmentation,
    full_plan,
    fixture,
    analytical_path
) {
    assert(is_list(segmentation) && len(segmentation) == 11,
        "Fixture segmentation plans must contain eleven fields.");
    assert(segmentation[FS_RECORD_TYPE] ==
        STRAP_BENDER_FIXTURE_SEGMENTATION_PLAN_RECORD,
        "Invalid fixture segmentation plan record type.");
    assert(sb_schema_version_valid(segmentation[FS_SCHEMA_VERSION]),
        "Unsupported fixture segmentation plan schema version.");
    assert(fixture_segmentation_plan_fixture_name(segmentation) ==
        bend_post_fixture_name(fixture) &&
        fixture_segmentation_plan_fixture_name(segmentation) ==
        bend_post_fixture_plan_fixture_name(full_plan),
        "Segmentation plan must preserve fixture identity.");
    assert(fixture_segmentation_plan_source_path_name(segmentation) ==
        analytical_path_name(analytical_path) &&
        fixture_segmentation_plan_source_path_name(segmentation) ==
        bend_post_fixture_plan_source_path_name(full_plan),
        "Segmentation plan must preserve analytical-path identity.");
    assert(fixture_segmentation_plan_strategy(segmentation) ==
        "sequential_straight_split",
        "Unsupported fixture segmentation strategy.");
    assert(fixture_segmentation_plan_status(segmentation) ==
        "experimental_uncompensated",
        "Segmentation status must preserve uncompensated fixture status.");
    assert(sb_near(
            fixture_segmentation_plan_max_base_width_mm(segmentation),
            bend_post_fixture_max_base_width_mm(fixture),
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ) &&
        sb_near(
            fixture_segmentation_plan_max_base_depth_mm(segmentation),
            bend_post_fixture_max_base_depth_mm(fixture),
            SB_NUMERIC_POSITION_TOLERANCE_MM
        ),
        "Segmentation plan must preserve the configured print envelope.");

    components = fixture_segmentation_plan_components(segmentation);
    splits = fixture_segmentation_plan_split_stations_mm(segmentation);
    assert(is_list(components) && len(components) > 0,
        "Fixture segmentation must contain at least one component.");
    assert(is_list(splits) && len(splits) == len(components) + 1,
        "Fixture split-station list must contain one more value than components.");
    assert(sb_near(splits[0], 0, SB_NUMERIC_STATION_TOLERANCE_MM) &&
        sb_near(
            splits[len(splits) - 1],
            analytical_path_length(analytical_path),
            SB_NUMERIC_STATION_TOLERANCE_MM
        ),
        "Fixture segmentation must cover the complete analytical station range.");

    for (index = [0 : len(components) - 1]) {
        component = components[index];
        validate_fixture_component(component, fixture, index);
        assert(fixture_component_id(component) ==
            sb_fixture_component_id(fixture, index),
            "Fixture component ID is not deterministic for its index.");
        assert(sb_near(
                fixture_component_station_start_mm(component),
                splits[index],
                SB_NUMERIC_STATION_TOLERANCE_MM
            ) &&
            sb_near(
                fixture_component_station_end_mm(component),
                splits[index + 1],
                SB_NUMERIC_STATION_TOLERANCE_MM
            ),
            "Fixture component station range must match manifest splits.");
        if (index > 0) {
            previous = components[index - 1];
            previous_end = fixture_component_end_datum(previous);
            current_start = fixture_component_start_datum(component);
            assert(sb_near(
                    fixture_component_station_end_mm(previous),
                    fixture_component_station_start_mm(component),
                    SB_NUMERIC_STATION_TOLERANCE_MM
                ),
                "Fixture component station ranges must be contiguous.");
            assert(sb_point_distance(
                    fixture_datum_point(previous_end),
                    fixture_datum_point(current_start)
                ) <= SB_NUMERIC_POSITION_TOLERANCE_MM &&
                sb_smallest_angle_delta_degrees(
                    fixture_datum_heading_degrees(previous_end),
                    fixture_datum_heading_degrees(current_start)
                ) <= SB_NUMERIC_ANGLE_TOLERANCE_DEGREES,
                "Adjacent fixture components must share one exact split pose.");
            assert(fixture_datum_role(previous_end) == "component_split" &&
                fixture_datum_role(current_start) == "component_split",
                "Interior component boundaries must use component-split datums.");
        }
    }

    assigned_bend_count = sb_list_sum([
        for (component = components)
            len(fixture_component_bend_stations(component))
    ]);
    assert(assigned_bend_count ==
        len(bend_post_fixture_plan_stations(full_plan)),
        "Every full-plan bend station must be assigned to exactly one component.");
    assert(is_string(fixture_segmentation_plan_notes(segmentation)),
        "Fixture segmentation notes must be a string.");
}
