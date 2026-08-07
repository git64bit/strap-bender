//////////////////////////////////////////////////////////////////////
// LibFile: calibration_evidence_workbench_wrapper_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Executes the exact persistent calibration-evidence audit wrapper.
//////////////////////////////////////////////////////////////////////

include <../workbenches/calibration-evidence.scad>

assert(len(CALIBRATION_TRIALS) == 0,
    "Calibration Evidence workbench must start with zero physical trials.");

echo("STRAP BENDER CALIBRATION EVIDENCE WORKBENCH CONTRACT: PASS");
