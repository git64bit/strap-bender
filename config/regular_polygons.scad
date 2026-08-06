//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygons.scad
// Project: Strap Bender
// FileGroup: Regular-Polygon Router
// FileSummary: Exposes the active regular-polygon source registry.
//////////////////////////////////////////////////////////////////////

WORKBENCH_REGULAR_POLYGON = regular_polygon_spec(
    name = wb_regular_polygon_name,
    side_count = wb_regular_side_count,
    dimension_kind = wb_regular_dimension_kind,
    dimension_value = wb_regular_dimension_value_mm,
    corner_radii = wb_regular_corner_radius_mm,
    center = [wb_regular_center_x_mm, wb_regular_center_y_mm],
    first_vertex_angle_degrees =
        wb_regular_first_vertex_angle_degrees,
    start_vertex_index = 0,
    notes = str(
        "Mutable Customizer regular-polygon source. The workbench exposes ",
        "one common radius; explicit per-corner lists remain registry data."
    )
);

REGULAR_POLYGONS =
    wb_workbench_name == "regular_polygon"
        ? [WORKBENCH_REGULAR_POLYGON]
        : wb_workbench_name == "development"
            ? LABORATORY_REGULAR_POLYGONS
            : [];
