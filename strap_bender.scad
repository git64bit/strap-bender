//////////////////////////////////////////////////////////////////////
// LibFile: strap_bender.scad
// Project: Strap Bender
// FileGroup: Public Foundation
// FileSummary: Loads records, analytical paths, sampling, and diagnostics.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_API_VERSION = 1;
STRAP_BENDER_SCHEMA_VERSION = 1;
STRAP_BENDER_SCAFFOLD_VERSION = 1;
STRAP_BENDER_BEND_PROGRAM_CONTRACT_VERSION = 1;
STRAP_BENDER_ANALYTICAL_PATH_CONTRACT_VERSION = 1;
STRAP_BENDER_SAMPLED_PATH_CONTRACT_VERSION = 1;

include <lib/indices.scad>
include <lib/schema.scad>
include <lib/accessors.scad>
include <lib/lookup.scad>
include <paths/analytical_math.scad>
include <paths/analytical_bounds.scad>
include <paths/compile_bend_program.scad>
include <paths/sample_analytical_path.scad>
include <lib/validation.scad>
include <lib/reporting.scad>
include <geometry/diagnostic_path.scad>
