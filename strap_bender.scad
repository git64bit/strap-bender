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
STRAP_BENDER_STRAP_MATERIAL_CONTRACT_VERSION = 1;
STRAP_BENDER_RADIUS_OBSERVATION_CONTRACT_VERSION = 1;
STRAP_BENDER_RADIUS_CALIBRATION_COUPON_CONTRACT_VERSION = 1;
STRAP_BENDER_CALIBRATION_TRIAL_CONTRACT_VERSION = 1;
STRAP_BENDER_CALIBRATION_EVIDENCE_REGISTRY_CONTRACT_VERSION = 1;

include <lib/indices.scad>
include <lib/material_indices.scad>
include <lib/calibration_indices.scad>
include <lib/calibration_coupon_indices.scad>
include <lib/calibration_trial_indices.scad>
include <lib/schema.scad>
include <lib/pattern_schema.scad>
include <lib/material_schema.scad>
include <lib/calibration_schema.scad>
include <lib/calibration_coupon_schema.scad>
include <lib/calibration_trial_schema.scad>
include <lib/accessors.scad>
include <lib/material_accessors.scad>
include <lib/calibration_accessors.scad>
include <lib/calibration_coupon_accessors.scad>
include <lib/calibration_trial_accessors.scad>
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
include <calibration/radius_coupon_math.scad>
include <lib/validation.scad>
include <lib/value_schedule_validation.scad>
include <lib/polygon_validation.scad>
include <lib/regular_polygon_validation.scad>
include <lib/pattern_validation.scad>
include <lib/material_validation.scad>
include <lib/calibration_validation.scad>
include <lib/calibration_coupon_validation.scad>
include <lib/calibration_trial_validation.scad>
include <lib/reporting.scad>
include <lib/pattern_reporting.scad>
include <lib/material_reporting.scad>
include <lib/calibration_reporting.scad>
include <lib/calibration_coupon_reporting.scad>
include <lib/calibration_trial_reporting.scad>
include <geometry/diagnostic_path.scad>
include <geometry/radius_calibration_coupon.scad>
