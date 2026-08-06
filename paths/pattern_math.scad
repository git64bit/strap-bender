//////////////////////////////////////////////////////////////////////
// LibFile: pattern_math.scad
// Project: Strap Bender
// FileGroup: Pattern Utilities
// FileSummary: Resolves parameter names, assignments, and repetition values.
//////////////////////////////////////////////////////////////////////

function sb_list_contains(values, candidate) =
    len([for (value = values) if (value == candidate) value]) > 0;

function sb_distinct_values(values, index = 0, result = []) =
    index >= len(values)
        ? result
        : sb_distinct_values(
            values,
            index + 1,
            sb_list_contains(result, values[index])
                ? result
                : concat(result, [values[index]])
        );

function sb_pattern_element_parameter_names(element) =
    pattern_element_kind(element) == "straight"
        ? [pattern_element_distance_parameter(element)]
        : [
            pattern_element_angle_parameter(element),
            pattern_element_radius_parameter(element)
        ];

function sb_pattern_distance_parameter_names(pattern) =
    sb_distinct_values([
        for (element = pattern_block_elements(pattern))
            if (pattern_element_kind(element) == "straight")
                pattern_element_distance_parameter(element)
    ]);

function sb_pattern_angle_parameter_names(pattern) =
    sb_distinct_values([
        for (element = pattern_block_elements(pattern))
            if (pattern_element_kind(element) == "bend")
                pattern_element_angle_parameter(element)
    ]);

function sb_pattern_radius_parameter_names(pattern) =
    sb_distinct_values([
        for (element = pattern_block_elements(pattern))
            if (pattern_element_kind(element) == "bend")
                pattern_element_radius_parameter(element)
    ]);

function sb_pattern_required_parameter_names(pattern) =
    sb_distinct_values(concat(
        sb_pattern_distance_parameter_names(pattern),
        sb_pattern_angle_parameter_names(pattern),
        sb_pattern_radius_parameter_names(pattern)
    ));

function sb_pattern_parameter_names(parameters) =
    [for (parameter = parameters) pattern_parameter_name(parameter)];

function sb_pattern_parameters_named(parameters, name) =
    [
        for (parameter = parameters)
            if (pattern_parameter_name(parameter) == name) parameter
    ];

function sb_pattern_parameter_named(parameters, name) =
    let(matches = sb_pattern_parameters_named(parameters, name))
    assert(
        len(matches) == 1,
        str(
            "Expected exactly one pattern parameter named '", name,
            "'; found ", len(matches), "."
        )
    )
    matches[0];

function sb_pattern_parameter_value_at(
    parameters,
    name,
    repetition_index,
    repetition_count
) = sb_resolve_numeric_value_source(
    pattern_parameter_value_source(
        sb_pattern_parameter_named(parameters, name)
    ),
    repetition_count
)[repetition_index];

function sb_resolved_pattern_parameter_value_at(
    resolved_parameters,
    name,
    repetition_index
) = pattern_parameter_value_source(
    sb_pattern_parameter_named(resolved_parameters, name)
)[repetition_index];

function sb_pattern_roles_are_disjoint(pattern) = let(
    distance_names = sb_pattern_distance_parameter_names(pattern),
    angle_names = sb_pattern_angle_parameter_names(pattern),
    radius_names = sb_pattern_radius_parameter_names(pattern)
) len([
    for (name = distance_names)
        if (sb_list_contains(angle_names, name) ||
            sb_list_contains(radius_names, name)) name
]) == 0 && len([
    for (name = angle_names)
        if (sb_list_contains(radius_names, name)) name
]) == 0;

function sb_pattern_resolved_parameters(instance, pattern) = [
    for (name = sb_pattern_required_parameter_names(pattern))
        let(parameter = sb_pattern_parameter_named(
            pattern_instance_parameters(instance),
            name
        ))
        pattern_parameter_spec(
            name = name,
            value_source = sb_resolve_numeric_value_source(
                pattern_parameter_value_source(parameter),
                pattern_instance_repeat_count(instance)
            ),
            label = pattern_parameter_label(parameter)
        )
];
