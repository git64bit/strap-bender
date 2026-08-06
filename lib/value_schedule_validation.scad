//////////////////////////////////////////////////////////////////////
// LibFile: value_schedule_validation.scad
// Project: Strap Bender
// FileGroup: Validation
// FileSummary: Validates numeric value schedules and consumer resolution.
//////////////////////////////////////////////////////////////////////

function sb_schedule_values_finite(values) =
    is_list(values) && len(values) > 0 &&
    len([for (value = values) if (!sb_finite_number(value)) value]) == 0;

function sb_positive_integer(value) =
    sb_nonnegative_integer(value) && value >= 1;

function sb_value_schedule_kind_valid(kind) =
    kind == "constant" ||
    kind == "explicit" ||
    kind == "periodic" ||
    kind == "every_nth";

function sb_value_schedule_payload_valid(schedule) = let(
    kind = value_schedule_kind(schedule)
) kind == "constant"
    ? sb_schedule_values_finite(value_schedule_values(schedule)) &&
        len(value_schedule_values(schedule)) == 1
    : kind == "explicit" || kind == "periodic"
        ? sb_schedule_values_finite(value_schedule_values(schedule))
        : kind == "every_nth"
            ? sb_finite_number(value_schedule_default_value(schedule)) &&
                sb_finite_number(value_schedule_selected_value(schedule)) &&
                sb_positive_integer(value_schedule_interval(schedule)) &&
                sb_positive_integer(value_schedule_first_position(schedule)) &&
                value_schedule_first_position(schedule) <=
                    value_schedule_interval(schedule)
            : false;

function sb_value_schedule_record_valid(schedule) =
    !sb_is_value_schedule(schedule)
        ? false
        : sb_schema_version_valid(schedule[VS_SCHEMA_VERSION]) &&
            sb_value_schedule_kind_valid(value_schedule_kind(schedule)) &&
            is_string(value_schedule_label(schedule)) &&
            sb_value_schedule_payload_valid(schedule);

function sb_numeric_value_source_valid(source, count) =
    !sb_nonnegative_integer(count)
        ? false
        : sb_finite_number(source)
            ? true
            : sb_is_value_schedule(source)
                ? sb_value_schedule_record_valid(source) &&
                    (
                        value_schedule_kind(source) != "explicit" ||
                        len(value_schedule_values(source)) == count
                    )
                : is_list(source)
                    ? len(source) == count &&
                        len([for (value = source)
                            if (!sb_finite_number(value)) value]) == 0
                    : false;

function sb_numeric_value_source_resolves_positive(source, count) =
    sb_numeric_value_source_valid(source, count) &&
    len([
        for (value = sb_resolve_numeric_value_source(source, count))
            if (!sb_finite_number(value) || value <= 0) value
    ]) == 0;

module validate_value_schedule(
    schedule,
    expected_count = undef,
    require_positive = false
) {
    assert(sb_is_value_schedule(schedule),
        "Value-schedule records must contain nine fields and the correct type.");
    assert(sb_schema_version_valid(schedule[VS_SCHEMA_VERSION]),
        str("Unsupported value-schedule schema version: ",
            schedule[VS_SCHEMA_VERSION]));
    assert(sb_value_schedule_kind_valid(value_schedule_kind(schedule)),
        str("Unsupported value-schedule kind: ",
            value_schedule_kind(schedule)));
    assert(is_string(value_schedule_label(schedule)),
        "Value-schedule label must be a string.");
    assert(sb_value_schedule_payload_valid(schedule),
        "Value-schedule fields are invalid for the selected schedule kind.");

    if (!is_undef(expected_count)) {
        assert(sb_nonnegative_integer(expected_count),
            "Expected schedule count must be a nonnegative integer.");
        assert(value_schedule_kind(schedule) != "explicit" ||
            len(value_schedule_values(schedule)) == expected_count,
            "Explicit schedules must contain exactly one value per consumer.");
        if (require_positive)
            assert(sb_numeric_value_source_resolves_positive(
                schedule,
                expected_count
            ), "The resolved schedule must contain only positive values.");
    }
}
