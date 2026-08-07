//////////////////////////////////////////////////////////////////////
// LibFile: strap_solid.scad
// Project: Strap Bender
// FileGroup: Strap Preview Geometry
// FileSummary: Renders a continuous nominal PET strap body around a sampled path.
//////////////////////////////////////////////////////////////////////

function sb_strap_segment_left_normal(start_point, end_point) =
    let(
        dx = sb_point_x(end_point) - sb_point_x(start_point),
        dy = sb_point_y(end_point) - sb_point_y(start_point),
        distance = sqrt(dx * dx + dy * dy)
    )
    [-dy / distance, dx / distance];

function sb_strap_offset_point(point, normal, distance) = [
    sb_point_x(point) + normal[0] * distance,
    sb_point_y(point) + normal[1] * distance
];

module sb_strap_segment_2d(start_point, end_point, thickness_mm) {
    normal = sb_strap_segment_left_normal(start_point, end_point);
    half_thickness = thickness_mm / 2;
    polygon(points = [
        sb_strap_offset_point(start_point, normal, -half_thickness),
        sb_strap_offset_point(end_point, normal, -half_thickness),
        sb_strap_offset_point(end_point, normal, half_thickness),
        sb_strap_offset_point(start_point, normal, half_thickness)
    ]);
}

module sb_strap_joint_2d(point, thickness_mm) {
    translate(point)
        circle(d = thickness_mm, $fn = 20);
}

module sb_strap_sweep_2d(points, thickness_mm, closure) {
    union() {
        for (segment_index = [0 : len(points) - 2])
            sb_strap_segment_2d(
                points[segment_index],
                points[segment_index + 1],
                thickness_mm
            );

        if (closure == "closed") {
            for (point_index = [0 : len(points) - 2])
                sb_strap_joint_2d(points[point_index], thickness_mm);
        } else if (len(points) > 2) {
            for (point_index = [1 : len(points) - 2])
                sb_strap_joint_2d(points[point_index], thickness_mm);
        }
    }
}

module sb_strap_solid_body(analytical_path, sampled_path, material) {
    points = sampled_path_points(sampled_path);
    thickness_mm = strap_material_nominal_thickness_mm(material);
    width_mm = strap_material_nominal_width_mm(material);

    linear_extrude(height = width_mm, convexity = 10)
        sb_strap_sweep_2d(
            points,
            thickness_mm,
            analytical_path_closure(analytical_path)
        );
}

module render_strap_solid(
    analytical_path,
    sampled_path,
    material,
    xy_offset = [0, 0],
    clip_bounds = undef,
    z_offset_mm = 0
) {
    width_mm = strap_material_nominal_width_mm(material);

    translate([xy_offset[0], xy_offset[1], z_offset_mm])
        if (is_undef(clip_bounds))
            sb_strap_solid_body(analytical_path, sampled_path, material);
        else
            intersection() {
                sb_strap_solid_body(
                    analytical_path, sampled_path, material
                );
                translate([
                    sb_bounds_min_x(clip_bounds),
                    sb_bounds_min_y(clip_bounds),
                    -0.01
                ])
                    cube([
                        sb_bounds_max_x(clip_bounds) -
                            sb_bounds_min_x(clip_bounds),
                        sb_bounds_max_y(clip_bounds) -
                            sb_bounds_min_y(clip_bounds),
                        width_mm + 0.02
                    ]);
            }
}
