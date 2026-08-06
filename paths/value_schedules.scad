//////////////////////////////////////////////////////////////////////
// LibFile: value_schedules.scad
// Project: Strap Bender
// FileGroup: Authoring Utilities
// FileSummary: Resolves compact numeric value sources to explicit lists.
//////////////////////////////////////////////////////////////////////

function sb_is_value_schedule(value) =
    !is_list(value)
        ? false
        : len(value) != 9
            ? false
            : value[VS_RECORD_TYPE] ==
                STRAP_BENDER_VALUE_SCHEDULE_RECORD;

function sb_value_source_kind(source) =
    is_num(source)
        ? "scalar"
        : sb_is_value_schedule(source)
            ? value_schedule_kind(source)
            : is_list(source)
                ? "explicit_list"
                : "invalid";

function sb_value_schedule_value_at(schedule, zero_based_index) = let(
    kind = value_schedule_kind(schedule)
) kind == "constant"
    ? value_schedule_values(schedule)[0]
    : kind == "explicit"
        ? value_schedule_values(schedule)[zero_based_index]
        : kind == "periodic"
            ? value_schedule_values(schedule)[
                zero_based_index % len(value_schedule_values(schedule))
            ]
            : kind == "every_nth"
                ? let(
                    position = zero_based_index + 1,
                    interval = value_schedule_interval(schedule),
                    first_position = value_schedule_first_position(schedule)
                ) position >= first_position &&
                    (position - first_position) % interval == 0
                        ? value_schedule_selected_value(schedule)
                        : value_schedule_default_value(schedule)
                : undef;

function sb_resolve_numeric_value_source(source, count) =
    count <= 0
        ? []
        : is_num(source)
            ? [for (index = [0 : count - 1]) source]
            : sb_is_value_schedule(source)
                ? [for (index = [0 : count - 1])
                    sb_value_schedule_value_at(source, index)]
                : source;

function sb_vertex_polygon_resolved_corner_radii(polygon) =
    sb_resolve_numeric_value_source(
        vertex_polygon_corner_radii(polygon),
        len(vertex_polygon_vertices(polygon))
    );
