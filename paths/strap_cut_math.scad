//////////////////////////////////////////////////////////////////////
// LibFile: strap_cut_math.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Mathematics
// FileSummary: Derives nominal developed and cutting lengths from exact primitives.
//////////////////////////////////////////////////////////////////////

function sb_cut_development_mode_valid(value) =
    value == "nominal_mid_thickness" || value == "custom_fraction";

function sb_cut_closure_mode_valid(value) =
    value == "none" || value == "butt" || value == "overlap";

function sb_cut_straight_length_mm(path) = sb_list_sum([
    for (primitive = analytical_path_primitives(path))
        if (primitive_kind(primitive) == "line") primitive_length(primitive)
]);

function sb_cut_inside_arc_length_mm(path) = sb_list_sum([
    for (primitive = analytical_path_primitives(path))
        if (primitive_kind(primitive) == "arc") primitive_length(primitive)
]);

function sb_cut_arc_development_radius_mm(primitive, thickness_mm, fraction) =
    primitive_inside_radius(primitive) + thickness_mm * fraction;

function sb_cut_arc_developed_length_mm(primitive, thickness_mm, fraction) =
    sb_cut_arc_development_radius_mm(primitive, thickness_mm, fraction) *
        abs(primitive_angle_degrees(primitive)) * SB_PI / 180;

function sb_cut_developed_arc_length_mm(path, thickness_mm, fraction) =
    sb_list_sum([
        for (primitive = analytical_path_primitives(path))
            if (primitive_kind(primitive) == "arc")
                sb_cut_arc_developed_length_mm(
                    primitive, thickness_mm, fraction
                )
    ]);

function sb_cut_effective_closure_overlap_mm(spec) =
    strap_cut_closure_mode(spec) == "overlap"
        ? strap_cut_closure_overlap_mm(spec)
        : 0;

function sb_cut_allowance_total_mm(spec) =
    strap_cut_start_allowance_mm(spec) +
    strap_cut_end_allowance_mm(spec) +
    sb_cut_effective_closure_overlap_mm(spec) +
    strap_cut_joining_allowance_mm(spec);

function sb_cut_plan_status(path, spec) =
    analytical_path_closure(path) == "closed" &&
        strap_cut_closure_mode(spec) == "none"
        ? "nominal_uncalibrated_closure_unassigned"
        : "nominal_uncalibrated";

function plan_strap_cut(path, spec, materials) =
    let(
        material = named_record(
            materials,
            strap_cut_strap_material_name(spec),
            "strap material"
        ),
        thickness_mm = strap_material_nominal_thickness_mm(material),
        fraction = strap_cut_neutral_axis_fraction(spec),
        straight_mm = sb_cut_straight_length_mm(path),
        inside_arc_mm = sb_cut_inside_arc_length_mm(path),
        developed_arc_mm = sb_cut_developed_arc_length_mm(
            path, thickness_mm, fraction
        ),
        developed_mm = straight_mm + developed_arc_mm,
        allowances_mm = sb_cut_allowance_total_mm(spec)
    )
    strap_cut_plan_spec(
        source_name = strap_cut_name(spec),
        path_name = analytical_path_name(path),
        path_closure = analytical_path_closure(path),
        strap_material_name = strap_material_name(material),
        nominal_thickness_mm = thickness_mm,
        neutral_axis_fraction = fraction,
        inside_reference_length_mm = analytical_path_length(path),
        straight_length_mm = straight_mm,
        inside_arc_length_mm = inside_arc_mm,
        developed_arc_length_mm = developed_arc_mm,
        nominal_developed_length_mm = developed_mm,
        allowance_total_mm = allowances_mm,
        cut_length_mm = developed_mm + allowances_mm,
        status = sb_cut_plan_status(path, spec),
        notes = str(
            "Nominal development uses the selected fraction of vendor nominal ",
            "strap thickness measured outward from the finished inside edge. ",
            "This is not a calibrated neutral-axis or empirical cut correction."
        )
    );
