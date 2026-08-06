//////////////////////////////////////////////////////////////////////
// LibFile: pattern_schema.scad
// Project: Strap Bender
// FileGroup: Data Model
// FileSummary: Constructors for reusable pattern and expansion records.
//////////////////////////////////////////////////////////////////////

STRAP_BENDER_PATTERN_ELEMENT_RECORD = "strap_bender_pattern_element";
STRAP_BENDER_PATTERN_BLOCK_RECORD = "strap_bender_pattern_block";
STRAP_BENDER_PATTERN_PARAMETER_RECORD = "strap_bender_pattern_parameter";
STRAP_BENDER_PATTERN_INSTANCE_RECORD = "strap_bender_pattern_instance";
STRAP_BENDER_PATTERN_PROVENANCE_RECORD = "strap_bender_pattern_provenance";
STRAP_BENDER_PATTERN_COMPILATION_RECORD =
    "strap_bender_pattern_compilation";

function pattern_straight_element(
    distance_parameter,
    label,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_ELEMENT_RECORD,
    schema_version,
    "straight",
    distance_parameter,
    undef,
    undef,
    undef,
    label
];

function pattern_bend_element(
    angle_parameter,
    radius_parameter,
    angle_multiplier,
    label,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_ELEMENT_RECORD,
    schema_version,
    "bend",
    undef,
    angle_parameter,
    radius_parameter,
    angle_multiplier,
    label
];

function pattern_block_spec(
    name,
    elements,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_BLOCK_RECORD,
    schema_version,
    name,
    elements,
    notes
];

function pattern_parameter_spec(
    name,
    value_source,
    label = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_PARAMETER_RECORD,
    schema_version,
    name,
    value_source,
    label
];

function pattern_instance_spec(
    name,
    pattern_name,
    repeat_count,
    parameters,
    closure = "open",
    start_pose = start_pose_spec(),
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_INSTANCE_RECORD,
    schema_version,
    name,
    pattern_name,
    repeat_count,
    parameters,
    closure,
    start_pose,
    notes
];

function pattern_command_provenance_spec(
    command_index,
    repetition_index,
    local_element_index,
    local_label,
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_PROVENANCE_RECORD,
    schema_version,
    command_index,
    repetition_index,
    local_element_index,
    local_label
];

function pattern_compilation_spec(
    source_instance_name,
    source_pattern_name,
    resolved_parameters,
    provenance,
    normalized_shape,
    notes = "",
    schema_version = STRAP_BENDER_SCHEMA_VERSION
) = [
    STRAP_BENDER_PATTERN_COMPILATION_RECORD,
    schema_version,
    source_instance_name,
    source_pattern_name,
    resolved_parameters,
    provenance,
    normalized_shape,
    notes
];
