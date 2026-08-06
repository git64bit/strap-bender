//////////////////////////////////////////////////////////////////////
// LibFile: regular_polygon_math.scad
// Project: Strap Bender
// FileGroup: Regular-Polygon Front End
// FileSummary: Resolves regular-polygon dimensions and sharp vertices.
//////////////////////////////////////////////////////////////////////

function sb_regular_polygon_dimension_kind_valid(kind) =
    kind == "side_length" ||
    kind == "circumradius" ||
    kind == "apothem";

function sb_regular_polygon_circumradius_from_values(
    side_count,
    dimension_kind,
    dimension_value
) =
    dimension_kind == "circumradius"
        ? dimension_value
        : dimension_kind == "side_length"
            ? dimension_value / (2 * sin(180 / side_count))
            : dimension_value / cos(180 / side_count);

function sb_regular_polygon_side_length_from_circumradius(
    side_count,
    circumradius
) = 2 * circumradius * sin(180 / side_count);

function sb_regular_polygon_apothem_from_circumradius(
    side_count,
    circumradius
) = circumradius * cos(180 / side_count);

function sb_regular_polygon_resolved_circumradius(polygon) =
    sb_regular_polygon_circumradius_from_values(
        regular_polygon_side_count(polygon),
        regular_polygon_dimension_kind(polygon),
        regular_polygon_dimension_value(polygon)
    );

function sb_regular_polygon_resolved_side_length(polygon) =
    sb_regular_polygon_side_length_from_circumradius(
        regular_polygon_side_count(polygon),
        sb_regular_polygon_resolved_circumradius(polygon)
    );

function sb_regular_polygon_resolved_apothem(polygon) =
    sb_regular_polygon_apothem_from_circumradius(
        regular_polygon_side_count(polygon),
        sb_regular_polygon_resolved_circumradius(polygon)
    );

function sb_regular_polygon_vertex_angle_degrees(polygon, vertex_index) =
    regular_polygon_first_vertex_angle_degrees(polygon) +
    vertex_index * 360 / regular_polygon_side_count(polygon);

function sb_regular_polygon_vertex(polygon, vertex_index) = let(
    center = regular_polygon_center(polygon),
    circumradius = sb_regular_polygon_resolved_circumradius(polygon),
    angle = sb_regular_polygon_vertex_angle_degrees(polygon, vertex_index)
) [
    sb_point_x(center) + circumradius * cos(angle),
    sb_point_y(center) + circumradius * sin(angle)
];

function sb_regular_polygon_vertices(polygon) = [
    for (vertex_index = [0 : regular_polygon_side_count(polygon) - 1])
        sb_regular_polygon_vertex(polygon, vertex_index)
];

function sb_regular_polygon_resolved_corner_radii(polygon) =
    sb_resolve_numeric_value_source(
        regular_polygon_corner_radii(polygon),
        regular_polygon_side_count(polygon)
    );
