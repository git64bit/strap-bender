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
STRAP_BENDER_VALUE_SCHEDULE_CONTRACT_VERSION = 1;
STRAP_BENDER_VERTEX_POLYGON_CONTRACT_VERSION = 1;
STRAP_BENDER_REGULAR_POLYGON_CONTRACT_VERSION = 1;
STRAP_BENDER_PATTERN_CONTRACT_VERSION = 1;

include <lib/indices.scad>
include <lib/schema.scad>
include <lib/pattern_schema.scad>
include <lib/accessors.scad>
include <lib/lookup.scad>
include <paths/value_schedules.scad>
include <paths/pattern_math.scad>
include <paths/analytical_math.scad>
include <paths/analytical_bounds.scad>
include <paths/polygon_math.scad>
include <paths/regular_polygon_math.scad>
include <paths/compile_bend_program.scad>
include <paths/compile_vertex_polygon.scad>
include <paths/compile_regular_polygon.scad>
include <paths/compile_pattern_instance.scad>
include <paths/sample_analytical_path.scad>
include <lib/validation.scad>
include <lib/value_schedule_validation.scad>
include <lib/polygon_validation.scad>
include <lib/regular_polygon_validation.scad>
include <lib/pattern_validation.scad>
include <lib/reporting.scad>
include <lib/pattern_reporting.scad>
include <geometry/diagnostic_path.scad>
