//////////////////////////////////////////////////////////////////////
// LibFile: strap_bender.scad
// Project: Strap Bender
// FileGroup: Public Foundation
// FileSummary: Loads the native Strap Bender record and validation contract.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_API_VERSION = 1;
STRAP_BENDER_SCHEMA_VERSION = 1;
STRAP_BENDER_SCAFFOLD_VERSION = 1;
STRAP_BENDER_BEND_PROGRAM_CONTRACT_VERSION = 1;

include <lib/indices.scad>
include <lib/schema.scad>
include <lib/accessors.scad>
include <lib/lookup.scad>
include <lib/validation.scad>
include <lib/reporting.scad>
