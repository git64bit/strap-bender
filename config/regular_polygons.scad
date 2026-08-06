//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygons.scad
// Project: Strap Bender
// FileGroup: Regular-Polygon Router
// FileSummary: Exposes the active regular-polygon source registry.
//////////////////////////////////////////////////////////////////////

function sb_workbench_regular_corner_radius_source() =
    wb_regular_corner_radius_mode == "constant"
        ? wb_regular_corner_radius_mm
        : wb_regular_corner_radius_mode == "every_nth"
            ? value_schedule_every_nth(
                default_value = wb_regular_corner_radius_mm,
                selected_value = wb_regular_scheduled_corner_radius_mm,
                interval = wb_regular_schedule_interval,
                first_position = wb_regular_schedule_first_position,
                label = "Customizer every-nth corner radius"
            )
            : assert(false, str(
                "Unsupported regular-polygon corner-radius mode: ",
                wb_regular_corner_radius_mode
            )) undef;

WORKBENCH_REGULAR_POLYGON = regular_polygon_spec(
    name = wb_regular_polygon_name,
    side_count = wb_regular_side_count,
    dimension_kind = wb_regular_dimension_kind,
    dimension_value = wb_regular_dimension_value_mm,
    corner_radii = sb_workbench_regular_corner_radius_source(),
    center = [wb_regular_center_x_mm, wb_regular_center_y_mm],
    first_vertex_angle_degrees =
        wb_regular_first_vertex_angle_degrees,
    start_vertex_index = 0,
    notes = str(
        "Mutable Customizer regular-polygon source. Radius mode is ",
        wb_regular_corner_radius_mode,
        "; compact schedules resolve before vertex-polygon compilation."
    )
);

REGULAR_POLYGONS =
    wb_workbench_name == "regular_polygon"
        ? [WORKBENCH_REGULAR_POLYGON]
        : wb_workbench_name == "development"
            ? LABORATORY_REGULAR_POLYGONS
            : [];
