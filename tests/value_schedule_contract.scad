//////////////////////////////////////////////////////////////////////
// LibFile: value_schedule_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies constant, explicit, periodic, and every-nth schedules.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>

constant_schedule = value_schedule_constant(2.5, "constant test");
explicit_schedule = value_schedule_explicit(
    [1, 2, 3, 4],
    "explicit test"
);
periodic_schedule = value_schedule_periodic(
    [1.6, 1.6, 5],
    "periodic test"
);
every_third_schedule = value_schedule_every_nth(
    default_value = 1.6,
    selected_value = 5,
    interval = 3,
    first_position = 3,
    label = "every third test"
);

validate_value_schedule(constant_schedule, 4, true);
validate_value_schedule(explicit_schedule, 4, true);
validate_value_schedule(periodic_schedule, 8, true);
validate_value_schedule(every_third_schedule, 8, true);

assert(value_schedule_kind(constant_schedule) == "constant" &&
    value_schedule_values(constant_schedule) == [2.5],
    "Constant schedule constructor or accessors failed.");
assert(sb_resolve_numeric_value_source(constant_schedule, 4) ==
    [2.5, 2.5, 2.5, 2.5],
    "Constant schedule resolution failed.");
assert(sb_resolve_numeric_value_source(explicit_schedule, 4) ==
    [1, 2, 3, 4],
    "Explicit schedule resolution failed.");
assert(sb_resolve_numeric_value_source(periodic_schedule, 8) ==
    [1.6, 1.6, 5, 1.6, 1.6, 5, 1.6, 1.6],
    "Periodic schedule resolution failed.");
assert(sb_resolve_numeric_value_source(every_third_schedule, 8) ==
    [1.6, 1.6, 5, 1.6, 1.6, 5, 1.6, 1.6],
    "Every-third schedule must use one-based positions 3, 6, and so on.");
assert(!sb_numeric_value_source_valid(
    value_schedule_explicit([1, 2]),
    3
), "An explicit schedule with the wrong count must be rejected.");
assert(!sb_value_schedule_record_valid(
    value_schedule_every_nth(1.6, 5, 3, 4)
), "First selected position beyond the interval must be rejected.");

report_value_schedule(periodic_schedule, 8, "Periodic contract schedule");
echo("STRAP BENDER VALUE-SCHEDULE CONTRACT: PASS");
