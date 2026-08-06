//////////////////////////////////////////////////////////////////////
// LibFile: pattern_validation.scad
// Project: Strap Bender
// FileGroup: Validation
// FileSummary: Validates pattern blocks, instances, and derived expansion.
//////////////////////////////////////////////////////////////////////

function sb_pattern_element_kind_valid(kind) =
    kind == "straight" || kind == "bend";

function sb_pattern_parameter_record_valid(parameter) =
    is_list(parameter) && len(parameter) == 5 &&
    parameter[PP_RECORD_TYPE] == STRAP_BENDER_PATTERN_PARAMETER_RECORD &&
    sb_schema_version_valid(parameter[PP_SCHEMA_VERSION]) &&
    sb_nonempty_string(pattern_parameter_name(parameter)) &&
    is_string(pattern_parameter_label(parameter));

function sb_pattern_assignment_names_valid(instance, pattern) = let(
    required = sb_pattern_required_parameter_names(pattern),
    assigned = sb_pattern_parameter_names(
        pattern_instance_parameters(instance)
    )
) len(assigned) == len(required) &&
    len(sb_distinct_values(assigned)) == len(assigned) &&
    len([
        for (name = required)
            if (!sb_list_contains(assigned, name)) name
    ]) == 0;

function sb_pattern_values_valid(instance, pattern) = let(
    parameters = pattern_instance_parameters(instance),
    count = pattern_instance_repeat_count(instance),
    distance_names = sb_pattern_distance_parameter_names(pattern),
    radius_names = sb_pattern_radius_parameter_names(pattern)
) len([
    for (parameter = parameters)
        if (!sb_numeric_value_source_valid(
            pattern_parameter_value_source(parameter),
            count
        )) parameter
]) == 0 && len([
    for (name = distance_names)
        for (value = sb_resolve_numeric_value_source(
            pattern_parameter_value_source(
                sb_pattern_parameter_named(parameters, name)
            ),
            count
        ))
            if (!(sb_finite_number(value) && value > 0)) value
]) == 0 && len([
    for (name = radius_names)
        for (value = sb_resolve_numeric_value_source(
            pattern_parameter_value_source(
                sb_pattern_parameter_named(parameters, name)
            ),
            count
        ))
            if (!(sb_finite_number(value) && value > 0)) value
]) == 0;

function sb_pattern_bend_values_valid(instance, pattern) = let(
    count = pattern_instance_repeat_count(instance),
    elements = pattern_block_elements(pattern),
    resolved_parameters = sb_pattern_resolved_parameters(instance, pattern)
) len([
    for (element = elements)
        if (pattern_element_kind(element) == "bend")
            for (repetition_index = [0 : count - 1])
                let(angle = sb_resolved_pattern_parameter_value_at(
                    resolved_parameters,
                    pattern_element_angle_parameter(element),
                    repetition_index
                ) * pattern_element_angle_multiplier(element))
                if (!sb_bend_angle_valid(angle)) angle
]) == 0;

module validate_pattern_element(element) {
    assert(is_list(element) && len(element) == 8,
        "Pattern elements must contain eight fields.");
    assert(element[PT_RECORD_TYPE] == STRAP_BENDER_PATTERN_ELEMENT_RECORD,
        "Invalid pattern-element record type.");
    assert(sb_schema_version_valid(element[PT_SCHEMA_VERSION]),
        "Unsupported pattern-element schema version.");
    assert(sb_pattern_element_kind_valid(pattern_element_kind(element)),
        str("Unknown pattern-element kind: ",
            pattern_element_kind(element)));
    assert(sb_nonempty_string(pattern_element_label(element)),
        "Pattern elements require non-empty local labels.");

    if (pattern_element_kind(element) == "straight") {
        assert(sb_nonempty_string(
            pattern_element_distance_parameter(element)
        ), "Straight pattern elements require a distance parameter.");
        assert(is_undef(pattern_element_angle_parameter(element)) &&
            is_undef(pattern_element_radius_parameter(element)) &&
            is_undef(pattern_element_angle_multiplier(element)),
            "Straight pattern elements may not carry bend fields.");
    } else {
        assert(is_undef(pattern_element_distance_parameter(element)),
            "Bend pattern elements may not carry a distance parameter.");
        assert(sb_nonempty_string(
            pattern_element_angle_parameter(element)
        ), "Bend pattern elements require an angle parameter.");
        assert(sb_nonempty_string(
            pattern_element_radius_parameter(element)
        ), "Bend pattern elements require a radius parameter.");
        assert(sb_finite_number(pattern_element_angle_multiplier(element)) &&
            pattern_element_angle_multiplier(element) != 0,
            "Bend angle multiplier must be finite and nonzero.");
    }
}

module validate_pattern_block(pattern) {
    assert(is_list(pattern) && len(pattern) == 5,
        "Pattern-block records must contain five fields.");
    assert(pattern[PB_RECORD_TYPE] == STRAP_BENDER_PATTERN_BLOCK_RECORD,
        "Invalid pattern-block record type.");
    assert(sb_schema_version_valid(pattern[PB_SCHEMA_VERSION]),
        "Unsupported pattern-block schema version.");
    assert(sb_nonempty_string(pattern_block_name(pattern)),
        "Pattern-block name must be a non-empty string.");
    assert(is_list(pattern_block_elements(pattern)) &&
        len(pattern_block_elements(pattern)) > 0,
        "Pattern blocks require at least one local element.");
    assert(is_string(pattern_block_notes(pattern)),
        "Pattern-block notes must be a string.");

    for (element = pattern_block_elements(pattern))
        validate_pattern_element(element);

    labels = [
        for (element = pattern_block_elements(pattern))
            pattern_element_label(element)
    ];
    assert(len(sb_distinct_values(labels)) == len(labels),
        "Pattern local element labels must be unique.");
    assert(sb_pattern_roles_are_disjoint(pattern),
        "One pattern parameter name may not serve multiple value roles.");
}

module validate_pattern_instance(instance, pattern) {
    assert(is_list(instance) && len(instance) == 9,
        "Pattern-instance records must contain nine fields.");
    assert(instance[PI_RECORD_TYPE] == STRAP_BENDER_PATTERN_INSTANCE_RECORD,
        "Invalid pattern-instance record type.");
    assert(sb_schema_version_valid(instance[PI_SCHEMA_VERSION]),
        "Unsupported pattern-instance schema version.");
    assert(sb_nonempty_string(pattern_instance_name(instance)),
        "Pattern-instance name must be a non-empty string.");
    assert(pattern_instance_pattern_name(instance) ==
        pattern_block_name(pattern),
        "Pattern-instance reference must match the selected block.");
    assert(sb_nonnegative_integer(pattern_instance_repeat_count(instance)) &&
        pattern_instance_repeat_count(instance) > 0,
        "Pattern repetition count must be a positive integer.");
    assert(is_list(pattern_instance_parameters(instance)),
        "Pattern parameters must be a list.");
    assert(sb_closure_valid(pattern_instance_closure(instance)),
        "Pattern-instance closure must be open or closed.");
    assert(is_string(pattern_instance_notes(instance)),
        "Pattern-instance notes must be a string.");

    validate_start_pose(pattern_instance_start_pose(instance));
    validate_pattern_block(pattern);

    for (parameter = pattern_instance_parameters(instance))
        assert(sb_pattern_parameter_record_valid(parameter),
            "Invalid pattern-parameter assignment record.");

    assert(sb_pattern_assignment_names_valid(instance, pattern),
        "Pattern instance must assign every required parameter exactly once.");
    assert(sb_pattern_values_valid(instance, pattern),
        "Pattern distance, angle, and radius sources must resolve finitely.");
    assert(sb_pattern_bend_values_valid(instance, pattern),
        "Expanded bend angles must be nonzero and below 360 degrees.");
}

module validate_pattern_compilation(compilation, instance, pattern) {
    assert(is_list(compilation) && len(compilation) == 8,
        "Pattern-compilation records must contain eight fields.");
    assert(compilation[PCX_RECORD_TYPE] ==
        STRAP_BENDER_PATTERN_COMPILATION_RECORD,
        "Invalid pattern-compilation record type.");
    assert(sb_schema_version_valid(compilation[PCX_SCHEMA_VERSION]),
        "Unsupported pattern-compilation schema version.");
    assert(pattern_compilation_source_instance_name(compilation) ==
        pattern_instance_name(instance),
        "Pattern compilation lost the source instance identity.");
    assert(pattern_compilation_source_pattern_name(compilation) ==
        pattern_block_name(pattern),
        "Pattern compilation lost the source block identity.");

    resolved = pattern_compilation_resolved_parameters(compilation);
    commands = shape_commands(
        pattern_compilation_normalized_shape(compilation)
    );
    provenance = pattern_compilation_provenance(compilation);
    repetition_count = pattern_instance_repeat_count(instance);
    elements = pattern_block_elements(pattern);
    element_count = len(elements);
    expected_count = repetition_count * element_count;

    assert(len(resolved) ==
        len(sb_pattern_required_parameter_names(pattern)),
        "Pattern compilation resolved the wrong parameter count.");
    assert(sb_pattern_parameter_names(resolved) ==
        sb_pattern_required_parameter_names(pattern),
        "Pattern compilation changed resolved parameter identity or order.");
    assert(len(commands) == expected_count,
        "Pattern compilation emitted the wrong command count.");
    assert(len(provenance) == expected_count,
        "Pattern compilation emitted the wrong provenance count.");

    for (parameter = resolved) {
        assert(sb_pattern_parameter_record_valid(parameter),
            "Resolved pattern parameter is invalid.");
        assert(is_list(pattern_parameter_value_source(parameter)) &&
            len(pattern_parameter_value_source(parameter)) ==
                pattern_instance_repeat_count(instance),
            "Resolved pattern parameter must contain one value per repeat.");
    }

    for (command_index = [0 : expected_count - 1]) {
        trace = provenance[command_index];
        assert(is_list(trace) && len(trace) == 6 &&
            trace[PV_RECORD_TYPE] ==
                STRAP_BENDER_PATTERN_PROVENANCE_RECORD &&
            sb_schema_version_valid(trace[PV_SCHEMA_VERSION]),
            "Invalid pattern command provenance record.");
        assert(pattern_provenance_command_index(trace) == command_index,
            "Pattern provenance command index mismatch.");
        assert(pattern_provenance_repetition_index(trace) ==
            floor(command_index / element_count),
            "Pattern provenance repetition index mismatch.");
        assert(pattern_provenance_local_element_index(trace) ==
            command_index % element_count,
            "Pattern provenance local element index mismatch.");
        assert(pattern_provenance_local_label(trace) ==
            pattern_element_label(elements[command_index % element_count]),
            "Pattern provenance local label mismatch.");
        assert(command_source_index(commands[command_index]) == command_index,
            "Expanded command source index mismatch.");
    }

    validate_bend_program_shape(
        pattern_compilation_normalized_shape(compilation)
    );
}
