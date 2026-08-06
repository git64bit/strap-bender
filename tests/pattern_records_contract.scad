//////////////////////////////////////////////////////////////////////
// LibFile: pattern_records_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies pattern constructors, accessors, and validation.
//////////////////////////////////////////////////////////////////////

include <../strap_bender.scad>
include <../patterns/standard_patterns.scad>

pattern = named_record(
    STANDARD_PATTERN_BLOCKS,
    "THREE_SEGMENT_S_WAVE",
    "pattern block"
);
instance = pattern_instance_spec(
    name = "TWO_WAVE_RECORD_TEST",
    pattern_name = pattern_block_name(pattern),
    repeat_count = 2,
    parameters = [
        pattern_parameter_spec("base_segment_mm", 20),
        pattern_parameter_spec("rising_segment_mm", 30),
        pattern_parameter_spec("falling_segment_mm", 40),
        pattern_parameter_spec("turn_angle_degrees", 45),
        pattern_parameter_spec("inside_radius_mm", 2)
    ]
);

validate_pattern_block(pattern);
validate_pattern_instance(instance, pattern);
compilation = compile_pattern_instance(instance, pattern);
validate_pattern_compilation(compilation, instance, pattern);

assert(pattern_block_name(pattern) == "THREE_SEGMENT_S_WAVE" &&
    len(pattern_block_elements(pattern)) == 6,
    "Pattern-block constructor or accessors failed.");
assert(pattern_instance_name(instance) == "TWO_WAVE_RECORD_TEST" &&
    pattern_instance_repeat_count(instance) == 2,
    "Pattern-instance constructor or accessors failed.");
assert(sb_pattern_required_parameter_names(pattern) == [
    "base_segment_mm",
    "rising_segment_mm",
    "falling_segment_mm",
    "turn_angle_degrees",
    "inside_radius_mm"
], "Pattern required-parameter order changed unexpectedly.");
assert(len(shape_commands(
    pattern_compilation_normalized_shape(compilation)
)) == 12, "Two six-element waves must expand to 12 commands.");
assert(len(pattern_compilation_provenance(compilation)) == 12,
    "Pattern compilation must preserve one trace per command.");

echo("STRAP BENDER PATTERN RECORDS CONTRACT: PASS");
