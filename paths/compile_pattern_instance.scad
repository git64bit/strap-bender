//////////////////////////////////////////////////////////////////////
// LibFile: compile_pattern_instance.scad
// Project: Strap Bender
// FileGroup: Shape Compilation
// FileSummary: Expands one compact repeated pattern to a bend program.
//////////////////////////////////////////////////////////////////////

function sb_pattern_command_label(
    instance,
    repetition_index,
    element
) = str(
    pattern_instance_name(instance),
    "/W", repetition_index + 1,
    "/", pattern_element_label(element)
);

function sb_compile_pattern_element(
    instance,
    element,
    source_index,
    repetition_index,
    resolved_parameters
) = let(
    label = sb_pattern_command_label(
        instance,
        repetition_index,
        element
    )
) pattern_element_kind(element) == "straight"
    ? straight_command(
        source_index = source_index,
        distance = sb_resolved_pattern_parameter_value_at(
            resolved_parameters,
            pattern_element_distance_parameter(element),
            repetition_index
        ),
        label = label
    )
    : bend_command(
        source_index = source_index,
        angle_degrees = sb_resolved_pattern_parameter_value_at(
            resolved_parameters,
            pattern_element_angle_parameter(element),
            repetition_index
        ) * pattern_element_angle_multiplier(element),
        inside_radius = sb_resolved_pattern_parameter_value_at(
            resolved_parameters,
            pattern_element_radius_parameter(element),
            repetition_index
        ),
        label = label
    );

function sb_pattern_expanded_commands(
    instance,
    pattern,
    resolved_parameters
) = let(
    elements = pattern_block_elements(pattern),
    element_count = len(elements),
    repetition_count = pattern_instance_repeat_count(instance)
) [
    for (repetition_index = [0 : repetition_count - 1])
        for (element_index = [0 : element_count - 1])
            sb_compile_pattern_element(
                instance = instance,
                element = elements[element_index],
                source_index = repetition_index * element_count +
                    element_index,
                repetition_index = repetition_index,
                resolved_parameters = resolved_parameters
            )
];

function sb_pattern_command_provenance(instance, pattern) = let(
    elements = pattern_block_elements(pattern),
    element_count = len(elements),
    repetition_count = pattern_instance_repeat_count(instance)
) [
    for (repetition_index = [0 : repetition_count - 1])
        for (element_index = [0 : element_count - 1])
            pattern_command_provenance_spec(
                command_index = repetition_index * element_count +
                    element_index,
                repetition_index = repetition_index,
                local_element_index = element_index,
                local_label = pattern_element_label(
                    elements[element_index]
                )
            )
];

function compile_pattern_instance(instance, pattern) = let(
    resolved_parameters = sb_pattern_resolved_parameters(instance, pattern),
    commands = sb_pattern_expanded_commands(
        instance,
        pattern,
        resolved_parameters
    ),
    normalized_shape = bend_program_shape_spec(
        name = pattern_instance_name(instance),
        commands = commands,
        closure = pattern_instance_closure(instance),
        start_pose = pattern_instance_start_pose(instance),
        notes = str(
            "Normalized from pattern instance '",
            pattern_instance_name(instance), "' using pattern block '",
            pattern_block_name(pattern), "'."
        )
    )
) pattern_compilation_spec(
    source_instance_name = pattern_instance_name(instance),
    source_pattern_name = pattern_block_name(pattern),
    resolved_parameters = resolved_parameters,
    provenance = sb_pattern_command_provenance(instance, pattern),
    normalized_shape = normalized_shape,
    notes = str(
        "Compact repetition intent remains authoritative. Expanded commands ",
        "and parameter lists are derived for execution and diagnostics."
    )
);
