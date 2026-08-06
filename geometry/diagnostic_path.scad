//////////////////////////////////////////////////////////////////////
// LibFile: diagnostic_path.scad
// Project: Strap Bender
// FileGroup: Diagnostic Geometry
// FileSummary: Renders a sampled analytical reference path and tangencies.
//////////////////////////////////////////////////////////////////////

module sb_diagnostic_polyline_2d(points, path_width_mm) {
    for (segment_index = [0 : len(points) - 2])
        hull() {
            translate(points[segment_index])
                circle(d = path_width_mm, $fn = 16);
            translate(points[segment_index + 1])
                circle(d = path_width_mm, $fn = 16);
        }
}

module sb_diagnostic_tangent_markers_2d(path, marker_diameter_mm) {
    primitives = analytical_path_primitives(path);

    for (primitive = primitives)
        translate(sb_pose_point(primitive_start_pose(primitive)))
            circle(d = marker_diameter_mm, $fn = 20);

    translate(sb_pose_point(analytical_path_end_pose(path)))
        circle(d = marker_diameter_mm, $fn = 20);
}

module render_diagnostic_path(
    analytical_path,
    sampled_path,
    path_width_mm = 0.8,
    path_height_mm = 0.4,
    show_tangent_points = true,
    tangent_marker_diameter_mm = 1.6
) {
    assert(sb_finite_number(path_width_mm) && path_width_mm > 0,
        "Diagnostic path width must be finite and greater than zero.");
    assert(sb_finite_number(path_height_mm) && path_height_mm > 0,
        "Diagnostic path height must be finite and greater than zero.");
    assert(show_tangent_points == true || show_tangent_points == false,
        "Diagnostic tangent-point visibility must be Boolean.");
    assert(sb_finite_number(tangent_marker_diameter_mm) &&
        tangent_marker_diameter_mm > 0,
        "Diagnostic tangent marker diameter must be positive.");

    points = sampled_path_points(sampled_path);

    linear_extrude(height = path_height_mm)
        sb_diagnostic_polyline_2d(points, path_width_mm);

    if (show_tangent_points)
        translate([0, 0, path_height_mm])
            linear_extrude(height = path_height_mm / 2)
                sb_diagnostic_tangent_markers_2d(
                    analytical_path,
                    tangent_marker_diameter_mm
                );
}
