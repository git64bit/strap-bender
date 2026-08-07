//////////////////////////////////////////////////////////////////////
// LibFile: cut_plan_reporting.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Reporting
// FileSummary: Reports nominal development assumptions, allowances, and cut length.
//////////////////////////////////////////////////////////////////////

module report_strap_cut_plan(plan, spec, path, level = "summary") {
    thickness_mm = strap_cut_plan_nominal_thickness_mm(plan);
    fraction = strap_cut_plan_neutral_axis_fraction(plan);
    echo("--- Strap Bender nominal strap cut plan ---");
    echo(str("Path: ", strap_cut_plan_path_name(plan),
        " (", strap_cut_plan_path_closure(plan), ")"));
    echo(str("Strap material: ", strap_cut_plan_strap_material_name(plan)));
    echo(str("Development mode: ", strap_cut_development_mode(spec)));
    echo(str("Nominal thickness: ", thickness_mm, " mm"));
    echo(str("Neutral-axis assumption: ", fraction,
        " x thickness = ", thickness_mm * fraction,
        " mm outward from finished inside edge"));
    echo(str("Inside-reference length: ",
        strap_cut_plan_inside_reference_length_mm(plan), " mm"));
    echo(str("Straight length: ", strap_cut_plan_straight_length_mm(plan),
        " mm; inside-edge arcs: ",
        strap_cut_plan_inside_arc_length_mm(plan), " mm"));
    echo(str("Nominal developed arc length: ",
        strap_cut_plan_developed_arc_length_mm(plan), " mm"));
    echo(str("Nominal developed strap length: ",
        strap_cut_plan_nominal_developed_length_mm(plan), " mm (",
        sb_mm_to_feet(strap_cut_plan_nominal_developed_length_mm(plan)),
        " ft)"));
    echo(str("End allowances: start ", strap_cut_start_allowance_mm(spec),
        " mm; end ", strap_cut_end_allowance_mm(spec), " mm"));
    echo(str("Closure mode: ", strap_cut_closure_mode(spec),
        "; overlap allowance: ",
        sb_cut_effective_closure_overlap_mm(spec), " mm",
        "; joining allowance: ", strap_cut_joining_allowance_mm(spec),
        " mm"));
    echo(str("Total explicit allowances: ",
        strap_cut_plan_allowance_total_mm(plan), " mm"));
    echo(str("NOMINAL CUT LENGTH: ", strap_cut_plan_cut_length_mm(plan),
        " mm (", sb_mm_to_feet(strap_cut_plan_cut_length_mm(plan)), " ft)"));
    echo(str("Status: ", strap_cut_plan_status(plan)));
    if (strap_cut_plan_status(plan) ==
        "nominal_uncalibrated_closure_unassigned")
        echo("Closure warning: closed path has no selected physical seam policy.");
    echo(str(
        "Length warning: this is an explicitly nominal estimate, not a ",
        "calibrated neutral-axis or empirically corrected production cut length."
    ));
    if (level == "full")
        for (primitive = analytical_path_primitives(path))
            if (primitive_kind(primitive) == "arc")
                echo(str(
                    "  bend source ", primitive_source_index(primitive),
                    " [", primitive_label(primitive), "]: ",
                    abs(primitive_angle_degrees(primitive)), " deg, inside R",
                    primitive_inside_radius(primitive), " mm, nominal develop R",
                    sb_cut_arc_development_radius_mm(
                        primitive, thickness_mm, fraction
                    ), " mm, developed arc ",
                    sb_cut_arc_developed_length_mm(
                        primitive, thickness_mm, fraction
                    ), " mm"
                ));
    if (level == "full")
        echo(str("Notes: ", strap_cut_plan_notes(plan)));
}
