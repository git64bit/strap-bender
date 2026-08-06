//////////////////////////////////////////////////////////////////////
// LibFile: default.scad
// Project: Strap Bender
// FileGroup: Development Workbench Entry Point
// FileSummary: Broad maintainer wrapper for framework validation.
//////////////////////////////////////////////////////////////////////

/* [Project selection] */
project_name_selected = "BEND_PROGRAM_LAB"; // [BEND_PROGRAM_LAB,VERTEX_POLYGON_LAB,REGULAR_POLYGON_LAB,CATALOG_WORKBENCH_STUB]

/* [Bend program selection] */
program_name_selected = "OPEN_MIXED_RADIUS_EXAMPLE"; // [OPEN_MIXED_RADIUS_EXAMPLE,THIRTY_SIX_BEND_SCALE_EXAMPLE]

/* [Vertex polygon selection] */
polygon_name_selected = "ROUNDED_SQUARE_EXAMPLE"; // [ROUNDED_SQUARE_EXAMPLE,CONCAVE_L_EXAMPLE]

/* [Regular polygon selection] */
regular_polygon_name_selected = "REGULAR_TRIANGLE_SIDE_100_R5"; // [REGULAR_TRIANGLE_SIDE_100_R5,REGULAR_SQUARE_APOTHEM_50_R10,REGULAR_PENTAGON_CIRCUMRADIUS_60_MIXED]

/* [Console report] */
report_level = "full"; // [summary,full]

/* [Hidden] */
workbench_name = "development";
render_mode = "report_only";
include <main.scad>
