//////////////////////////////////////////////////////////////////////
// LibFile: cut_plan_schema.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Data Model
// FileSummary: Constructors for source cutting policy and derived cut plans.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_STRAP_CUT_SPEC_RECORD = "strap_bender_strap_cut_spec";
STRAP_BENDER_STRAP_CUT_PLAN_RECORD = "strap_bender_strap_cut_plan";

function strap_cut_spec(
    name,
    strap_material_name,
    development_mode = "nominal_mid_thickness",
    neutral_axis_fraction = 0.5,
    start_allowance_mm = 0,
    end_allowance_mm = 0,
    closure_mode = "none",
    closure_overlap_mm = 0,
    joining_allowance_mm = 0,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_STRAP_CUT_SPEC_RECORD,
    schema_version,
    name,
    strap_material_name,
    development_mode,
    neutral_axis_fraction,
    start_allowance_mm,
    end_allowance_mm,
    closure_mode,
    closure_overlap_mm,
    joining_allowance_mm,
    notes
];

function strap_cut_plan_spec(
    source_name,
    path_name,
    path_closure,
    strap_material_name,
    nominal_thickness_mm,
    neutral_axis_fraction,
    inside_reference_length_mm,
    straight_length_mm,
    inside_arc_length_mm,
    developed_arc_length_mm,
    nominal_developed_length_mm,
    allowance_total_mm,
    cut_length_mm,
    status,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_STRAP_CUT_PLAN_RECORD,
    schema_version,
    source_name,
    path_name,
    path_closure,
    strap_material_name,
    nominal_thickness_mm,
    neutral_axis_fraction,
    inside_reference_length_mm,
    straight_length_mm,
    inside_arc_length_mm,
    developed_arc_length_mm,
    nominal_developed_length_mm,
    allowance_total_mm,
    cut_length_mm,
    status,
    notes
];
