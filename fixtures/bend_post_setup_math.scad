//////////////////////////////////////////////////////////////////////
// LibFile: bend_post_setup_math.scad
// Project: Strap Bender
// FileGroup: Fixture Planning
// FileSummary: Shared split-datum registration holes and component marks.
//////////////////////////////////////////////////////////////////////

function sb_fixture_setup_registration_mode_valid(mode) =
    mode == "none" || mode == "pin_pair";

function sb_fixture_setup_label_mode_valid(mode) =
    mode == "none" || mode == "recessed_corner";

function sb_fixture_setup_registration_enabled(setup) =
    fixture_setup_aid_registration_mode(setup) == "pin_pair";

function sb_fixture_setup_label_enabled(setup) =
    fixture_setup_aid_label_mode(setup) == "recessed_corner";

function sb_fixture_setup_heading_tangent(heading_degrees) = [
    cos(heading_degrees),
    sin(heading_degrees)
];

function sb_fixture_setup_heading_left_normal(heading_degrees) = [
    -sin(heading_degrees),
    cos(heading_degrees)
];

function sb_fixture_setup_offset_point(point, direction, distance_mm) = [
    sb_point_x(point) + direction[0] * distance_mm,
    sb_point_y(point) + direction[1] * distance_mm
];

function sb_fixture_datum_registration_points(datum, setup) =
    let(
        point = fixture_datum_point(datum),
        heading = fixture_datum_heading_degrees(datum),
        tangent = sb_fixture_setup_heading_tangent(heading),
        normal = sb_fixture_setup_heading_left_normal(heading),
        anchor = sb_fixture_setup_offset_point(
            point,
            normal,
            fixture_setup_aid_normal_offset_mm(setup)
        ),
        half_spacing = fixture_setup_aid_tangent_spacing_mm(setup) / 2
    )
    [
        sb_fixture_setup_offset_point(anchor, tangent, -half_spacing),
        sb_fixture_setup_offset_point(anchor, tangent, half_spacing)
    ];

function sb_fixture_component_split_datums(component) = concat(
    fixture_datum_role(fixture_component_start_datum(component)) ==
            "component_split"
        ? [fixture_component_start_datum(component)] : [],
    fixture_datum_role(fixture_component_end_datum(component)) ==
            "component_split"
        ? [fixture_component_end_datum(component)] : []
);

function sb_fixture_component_registration_points(component, setup) =
    sb_fixture_setup_registration_enabled(setup)
        ? [
            for (datum = sb_fixture_component_split_datums(component))
                each sb_fixture_datum_registration_points(datum, setup)
        ]
        : [];

function sb_fixture_component_local_registration_points(component, setup) = [
    for (point = sb_fixture_component_registration_points(component, setup))
        fixture_component_local_point(component, point)
];

function sb_fixture_component_short_label(component) =
    str(
        fixture_component_index(component) + 1 < 10 ? "00" :
            fixture_component_index(component) + 1 < 100 ? "0" : "",
        fixture_component_index(component) + 1
    );

function sb_fixture_setup_circle_inside_bounds(point, radius_mm, bounds) =
    sb_point_x(point) - radius_mm >=
            sb_bounds_min_x(bounds) - SB_NUMERIC_POSITION_TOLERANCE_MM &&
    sb_point_x(point) + radius_mm <=
            sb_bounds_max_x(bounds) + SB_NUMERIC_POSITION_TOLERANCE_MM &&
    sb_point_y(point) - radius_mm >=
            sb_bounds_min_y(bounds) - SB_NUMERIC_POSITION_TOLERANCE_MM &&
    sb_point_y(point) + radius_mm <=
            sb_bounds_max_y(bounds) + SB_NUMERIC_POSITION_TOLERANCE_MM;

function sb_fixture_setup_point_to_path_distance(point, path) =
    min([
        for (primitive = analytical_path_primitives(path))
            sb_fixture_point_to_primitive_distance(point, primitive)
    ]);

function sb_fixture_setup_registration_edge_clearance_mm(
    point,
    setup,
    path
) =
    sb_fixture_setup_point_to_path_distance(point, path) -
    fixture_setup_aid_hole_radius_mm(setup);


function sb_fixture_setup_station_envelope_radius_mm(
    station,
    full_plan,
    fixture
) =
    bend_post_station_tool_inside_radius_mm(station) +
    (sb_bend_post_retention_enabled(fixture)
        ? sb_bend_post_follower_outer_extension_mm(
            fixture,
            bend_post_fixture_plan_nominal_strap_thickness_mm(full_plan)
        )
        : 0);

function sb_fixture_setup_registration_to_station_gap_mm(
    point,
    station,
    setup,
    full_plan,
    fixture
) =
    sb_point_distance(point, bend_post_station_tool_center(station)) -
    sb_fixture_setup_station_envelope_radius_mm(
        station, full_plan, fixture
    ) -
    fixture_setup_aid_hole_radius_mm(setup);

function sb_fixture_setup_points_near(first, second, tolerance) =
    len(first) == len(second) &&
    len([
        for (index = [0 : len(first) - 1])
            if (sb_point_distance(first[index], second[index]) > tolerance)
                index
    ]) == 0;
