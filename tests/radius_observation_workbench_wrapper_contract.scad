//////////////////////////////////////////////////////////////////////
// LibFile: radius_observation_workbench_wrapper_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes the exact guarded Radius Observation wrapper.
//////////////////////////////////////////////////////////////////////

include <../workbenches/radius-observation.scad>

assert(!observation_ready,
    "Default Radius Observation workbench must remain gated as a draft.");
echo("STRAP BENDER RADIUS-OBSERVATION WORKBENCH WRAPPER CONTRACT: PASS");
