//////////////////////////////////////////////////////////////////////
// LibFile: strap_solid_validation.scad
// Project: Strap Bender
// FileGroup: Strap Solid Validation
// FileSummary: Validates inputs before rendering nominal strap-body geometry.
//////////////////////////////////////////////////////////////////////

module validate_strap_solid_render(
    analytical_path,
    sampled_path,
    material,
    xy_offset = [0, 0],
    clip_bounds = undef,
    z_offset_mm = 0
) {
    validate_analytical_path(analytical_path);
    validate_sampled_path(sampled_path, analytical_path);
    validate_strap_material(material);
    assert(sb_point_valid(xy_offset),
        "Strap-solid XY offset must be a finite two-dimensional point.");
    assert(is_undef(clip_bounds) || sb_bounds_valid(clip_bounds),
        "Strap-solid clip bounds must be undef or valid XY bounds.");
    assert(sb_finite_number(z_offset_mm),
        "Strap-solid Z offset must be finite.");
    assert(strap_material_nominal_width_mm(material) > 0,
        "Strap-solid material width must be positive.");
    assert(strap_material_nominal_thickness_mm(material) > 0,
        "Strap-solid material thickness must be positive.");
    assert(len(sampled_path_points(sampled_path)) >= 2,
        "Strap-solid preview requires at least two sampled path points.");
}
