//////////////////////////////////////////////////////////////////////
// LibFile: cut_plan_accessors.scad
// Project: Strap Bender
// FileGroup: Strap Cut Planning Data Model
// FileSummary: Named accessors for nominal development and cutting records.
//////////////////////////////////////////////////////////////////////

function strap_cut_name(spec) = spec[SC_NAME];
function strap_cut_strap_material_name(spec) = spec[SC_STRAP_MATERIAL_NAME];
function strap_cut_development_mode(spec) = spec[SC_DEVELOPMENT_MODE];
function strap_cut_neutral_axis_fraction(spec) = spec[SC_NEUTRAL_AXIS_FRACTION];
function strap_cut_start_allowance_mm(spec) = spec[SC_START_ALLOWANCE_MM];
function strap_cut_end_allowance_mm(spec) = spec[SC_END_ALLOWANCE_MM];
function strap_cut_closure_mode(spec) = spec[SC_CLOSURE_MODE];
function strap_cut_closure_overlap_mm(spec) = spec[SC_CLOSURE_OVERLAP_MM];
function strap_cut_joining_allowance_mm(spec) = spec[SC_JOINING_ALLOWANCE_MM];
function strap_cut_notes(spec) = spec[SC_NOTES];

function strap_cut_plan_source_name(plan) = plan[CP_SOURCE_NAME];
function strap_cut_plan_path_name(plan) = plan[CP_PATH_NAME];
function strap_cut_plan_path_closure(plan) = plan[CP_PATH_CLOSURE];
function strap_cut_plan_strap_material_name(plan) = plan[CP_STRAP_MATERIAL_NAME];
function strap_cut_plan_nominal_thickness_mm(plan) = plan[CP_NOMINAL_THICKNESS_MM];
function strap_cut_plan_neutral_axis_fraction(plan) =
    plan[CP_NEUTRAL_AXIS_FRACTION];
function strap_cut_plan_inside_reference_length_mm(plan) =
    plan[CP_INSIDE_REFERENCE_LENGTH_MM];
function strap_cut_plan_straight_length_mm(plan) = plan[CP_STRAIGHT_LENGTH_MM];
function strap_cut_plan_inside_arc_length_mm(plan) =
    plan[CP_INSIDE_ARC_LENGTH_MM];
function strap_cut_plan_developed_arc_length_mm(plan) =
    plan[CP_DEVELOPED_ARC_LENGTH_MM];
function strap_cut_plan_nominal_developed_length_mm(plan) =
    plan[CP_NOMINAL_DEVELOPED_LENGTH_MM];
function strap_cut_plan_allowance_total_mm(plan) = plan[CP_ALLOWANCE_TOTAL_MM];
function strap_cut_plan_cut_length_mm(plan) = plan[CP_CUT_LENGTH_MM];
function strap_cut_plan_status(plan) = plan[CP_STATUS];
function strap_cut_plan_notes(plan) = plan[CP_NOTES];
