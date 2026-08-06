//////////////////////////////////////////////////////////////////////
// LibFile: polygons.scad
// Project: Strap Bender
// FileGroup: Vertex-Polygon Router
// FileSummary: Exposes polygons allowed by the active workbench.
//////////////////////////////////////////////////////////////////////

VERTEX_POLYGONS =
    wb_workbench_name == "vertex_polygon" ||
    wb_workbench_name == "development"
        ? LABORATORY_VERTEX_POLYGONS
        : [];
