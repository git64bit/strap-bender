//////////////////////////////////////////////////////////////////////
// LibFile: cut_planning.scad
// Project: Strap Bender
// FileGroup: Workbench Cut Planning Configuration
// FileSummary: Constructs the transient nominal developed/cut-length policy.
//////////////////////////////////////////////////////////////////////

WORKBENCH_STRAP_CUT_SPEC = strap_cut_spec(
    name = str(wb_project_name, "_STRAP_CUT"),
    strap_material_name = wb_strap_material_name,
    development_mode = wb_cut_development_mode,
    neutral_axis_fraction = wb_cut_development_mode == "nominal_mid_thickness"
        ? 0.5 : wb_cut_neutral_axis_fraction,
    start_allowance_mm = wb_cut_start_allowance_mm,
    end_allowance_mm = wb_cut_end_allowance_mm,
    closure_mode = wb_cut_closure_mode,
    closure_overlap_mm = wb_cut_closure_overlap_mm,
    joining_allowance_mm = wb_cut_joining_allowance_mm,
    notes = str(
        "Mutable application-completion cutting policy. Nominal mid-thickness ",
        "development is explicitly uncalibrated. Every end, overlap, and joining ",
        "allowance is user-entered and defaults to zero rather than being inferred."
    )
);
