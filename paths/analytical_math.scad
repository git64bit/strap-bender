//////////////////////////////////////////////////////////////////////
// LibFile: analytical_math.scad
// Project: Strap Bender
// FileGroup: Analytical Path Kernel
// FileSummary: Deterministic planar pose, angle, and station mathematics.
//////////////////////////////////////////////////////////////////////

SB_PI = 3.14159265358979323846;
SB_NUMERIC_POSITION_TOLERANCE_MM = 0.0000001;
SB_NUMERIC_STATION_TOLERANCE_MM = 0.0000001;
SB_NUMERIC_ANGLE_TOLERANCE_DEGREES = 0.0000001;
SB_CLOSURE_POSITION_TOLERANCE_MM = 0.001;
SB_CLOSURE_ANGLE_TOLERANCE_DEGREES = 0.001;

function sb_point_x(point) = point[0];
function sb_point_y(point) = point[1];
function sb_pose_point(pose) = [pose_x(pose), pose_y(pose)];

function sb_degrees_to_radians(angle_degrees) =
    angle_degrees * SB_PI / 180;

function sb_point_distance(first, second) =
    sqrt(
        pow(sb_point_x(second) - sb_point_x(first), 2) +
        pow(sb_point_y(second) - sb_point_y(first), 2)
    );

function sb_pose_position_distance(first, second) =
    sb_point_distance(sb_pose_point(first), sb_pose_point(second));

function sb_positive_mod(value, modulus = 360) =
    ((value % modulus) + modulus) % modulus;

function sb_normalized_heading_degrees(angle_degrees) =
    sb_positive_mod(angle_degrees, 360);

function sb_smallest_angle_delta_degrees(first, second) =
    let(delta = sb_positive_mod(second - first + 180, 360) - 180)
    abs(delta);

function sb_near(first, second, tolerance) =
    abs(first - second) <= tolerance;

function sb_pose_near(
    first,
    second,
    position_tolerance = SB_NUMERIC_POSITION_TOLERANCE_MM,
    angle_tolerance = SB_NUMERIC_ANGLE_TOLERANCE_DEGREES
) =
    sb_pose_position_distance(first, second) <= position_tolerance &&
    sb_smallest_angle_delta_degrees(
        pose_heading_degrees(first),
        pose_heading_degrees(second)
    ) <= angle_tolerance;

function sb_advance_straight_pose(pose, distance) =
    start_pose_spec(
        x = pose_x(pose) +
            distance * cos(pose_heading_degrees(pose)),
        y = pose_y(pose) +
            distance * sin(pose_heading_degrees(pose)),
        heading_degrees = pose_heading_degrees(pose)
    );

function sb_bend_turn_sign(angle_degrees) =
    angle_degrees > 0 ? 1 : -1;

function sb_bend_center(start_pose, angle_degrees, radius) =
    let(
        turn_sign = sb_bend_turn_sign(angle_degrees),
        heading = pose_heading_degrees(start_pose)
    )
    [
        pose_x(start_pose) - turn_sign * radius * sin(heading),
        pose_y(start_pose) + turn_sign * radius * cos(heading)
    ];

function sb_rotate_point_about(point, center, angle_degrees) =
    let(
        relative_x = sb_point_x(point) - sb_point_x(center),
        relative_y = sb_point_y(point) - sb_point_y(center)
    )
    [
        sb_point_x(center) +
            relative_x * cos(angle_degrees) -
            relative_y * sin(angle_degrees),
        sb_point_y(center) +
            relative_x * sin(angle_degrees) +
            relative_y * cos(angle_degrees)
    ];

function sb_advance_bend_pose(start_pose, angle_degrees, radius) =
    let(
        center = sb_bend_center(start_pose, angle_degrees, radius),
        end_point = sb_rotate_point_about(
            sb_pose_point(start_pose),
            center,
            angle_degrees
        )
    )
    start_pose_spec(
        x = sb_point_x(end_point),
        y = sb_point_y(end_point),
        heading_degrees =
            pose_heading_degrees(start_pose) + angle_degrees
    );

function sb_arc_length(radius, angle_degrees) =
    radius * abs(sb_degrees_to_radians(angle_degrees));

function sb_list_sum(values, index = 0, accumulated = 0) =
    index >= len(values)
        ? accumulated
        : sb_list_sum(values, index + 1, accumulated + values[index]);

function sb_bounds_min_x(bounds) = bounds[0];
function sb_bounds_min_y(bounds) = bounds[1];
function sb_bounds_max_x(bounds) = bounds[2];
function sb_bounds_max_y(bounds) = bounds[3];
function sb_bounds_width(bounds) =
    sb_bounds_max_x(bounds) - sb_bounds_min_x(bounds);
function sb_bounds_height(bounds) =
    sb_bounds_max_y(bounds) - sb_bounds_min_y(bounds);
