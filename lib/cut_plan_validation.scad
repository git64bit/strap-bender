//////////////////////////////////////////////////////////////////////
// LibFile: cut_plan_validation.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Validation
// FileSummary: Validates source allowances and nominal developed-length plans.
//////////////////////////////////////////////////////////////////////

module validate_strap_cut_spec(spec, path, materials) {
    assert(is_list(spec) && len(spec) == 12,
        "Strap cut source records must contain twelve fields.");
    assert(spec[SC_RECORD_TYPE] == STRAP_BENDER_STRAP_CUT_SPEC_RECORD,
        "Invalid strap cut source record type.");
    assert(sb_schema_version_valid(spec[SC_SCHEMA_VERSION]),
        "Unsupported strap cut source schema version.");
    assert(sb_nonempty_string(strap_cut_name(spec)),
        "Strap cut source name must be non-empty.");
    assert(sb_nonempty_string(strap_cut_strap_material_name(spec)),
        "Strap cut source material name must be non-empty.");
    material = named_record(
        materials,
        strap_cut_strap_material_name(spec),
        "strap material"
    );
    validate_strap_material(material);
    assert(sb_cut_development_mode_valid(strap_cut_development_mode(spec)),
        str("Unsupported strap development mode: ",
            strap_cut_development_mode(spec)));
    assert(sb_finite_number(strap_cut_neutral_axis_fraction(spec)) &&
        strap_cut_neutral_axis_fraction(spec) >= 0 &&
        strap_cut_neutral_axis_fraction(spec) <= 1,
        "Nominal neutral-axis fraction must be between zero and one.");
    if (strap_cut_development_mode(spec) == "nominal_mid_thickness")
        assert(sb_near(strap_cut_neutral_axis_fraction(spec), 0.5, 1e-9),
            "nominal_mid_thickness mode must use an explicit 0.5 fraction.");
    assert(sb_finite_number(strap_cut_start_allowance_mm(spec)) &&
        strap_cut_start_allowance_mm(spec) >= 0 &&
        sb_finite_number(strap_cut_end_allowance_mm(spec)) &&
        strap_cut_end_allowance_mm(spec) >= 0,
        "Start and end cutting allowances must be finite and nonnegative.");
    assert(sb_cut_closure_mode_valid(strap_cut_closure_mode(spec)),
        str("Unsupported strap closure mode: ", strap_cut_closure_mode(spec)));
    assert(sb_finite_number(strap_cut_closure_overlap_mm(spec)) &&
        strap_cut_closure_overlap_mm(spec) >= 0 &&
        sb_finite_number(strap_cut_joining_allowance_mm(spec)) &&
        strap_cut_joining_allowance_mm(spec) >= 0,
        "Closure and joining allowances must be finite and nonnegative.");
    if (analytical_path_closure(path) == "open") {
        assert(strap_cut_closure_mode(spec) == "none",
            "Open paths require closure mode 'none'.");
        assert(sb_near(strap_cut_closure_overlap_mm(spec), 0, 1e-9) &&
            sb_near(strap_cut_joining_allowance_mm(spec), 0, 1e-9),
            "Open paths cannot use closure overlap or joining allowance.");
    } else if (strap_cut_closure_mode(spec) == "overlap") {
        assert(strap_cut_closure_overlap_mm(spec) > 0,
            "Overlap closure requires a positive explicit overlap allowance.");
    } else {
        assert(sb_near(strap_cut_closure_overlap_mm(spec), 0, 1e-9),
            "Closure overlap must be zero unless closure mode is 'overlap'.");
        if (strap_cut_closure_mode(spec) == "none")
            assert(sb_near(strap_cut_joining_allowance_mm(spec), 0, 1e-9),
                "Unassigned closed-path closure cannot use joining allowance.");
    }
    assert(is_string(strap_cut_notes(spec)),
        "Strap cut source notes must be a string.");
}

module validate_strap_cut_plan(plan, spec, path, materials) {
    tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM;
    assert(is_list(plan) && len(plan) == 17,
        "Strap cut plan records must contain seventeen fields.");
    assert(plan[CP_RECORD_TYPE] == STRAP_BENDER_STRAP_CUT_PLAN_RECORD,
        "Invalid strap cut plan record type.");
    assert(sb_schema_version_valid(plan[CP_SCHEMA_VERSION]),
        "Unsupported strap cut plan schema version.");
    assert(strap_cut_plan_source_name(plan) == strap_cut_name(spec) &&
        strap_cut_plan_path_name(plan) == analytical_path_name(path) &&
        strap_cut_plan_path_closure(plan) == analytical_path_closure(path),
        "Strap cut plan source/path identity mismatch.");
    material = named_record(
        materials,
        strap_cut_plan_strap_material_name(plan),
        "strap material"
    );
    assert(strap_cut_plan_strap_material_name(plan) ==
        strap_cut_strap_material_name(spec),
        "Strap cut plan material identity mismatch.");
    assert(sb_near(strap_cut_plan_nominal_thickness_mm(plan),
        strap_material_nominal_thickness_mm(material), tolerance),
        "Strap cut plan nominal thickness mismatch.");
    assert(sb_near(strap_cut_plan_inside_reference_length_mm(plan),
        analytical_path_length(path), tolerance),
        "Strap cut plan inside-reference length mismatch.");
    assert(sb_near(
        strap_cut_plan_straight_length_mm(plan) +
        strap_cut_plan_inside_arc_length_mm(plan),
        strap_cut_plan_inside_reference_length_mm(plan),
        tolerance),
        "Strap cut plan straight/inside-arc decomposition mismatch.");
    assert(strap_cut_plan_developed_arc_length_mm(plan) + tolerance >=
        strap_cut_plan_inside_arc_length_mm(plan),
        "Nominal developed arc length cannot be shorter than inside-edge arcs.");
    assert(sb_near(strap_cut_plan_nominal_developed_length_mm(plan),
        strap_cut_plan_straight_length_mm(plan) +
        strap_cut_plan_developed_arc_length_mm(plan), tolerance),
        "Nominal developed-length total mismatch.");
    assert(sb_near(strap_cut_plan_allowance_total_mm(plan),
        sb_cut_allowance_total_mm(spec), tolerance),
        "Strap cut allowance total mismatch.");
    assert(sb_near(strap_cut_plan_cut_length_mm(plan),
        strap_cut_plan_nominal_developed_length_mm(plan) +
        strap_cut_plan_allowance_total_mm(plan), tolerance),
        "Nominal cut-length total mismatch.");
    assert(strap_cut_plan_status(plan) == sb_cut_plan_status(path, spec),
        "Strap cut plan status mismatch.");
    assert(is_string(strap_cut_plan_notes(plan)),
        "Strap cut plan notes must be a string.");
}
