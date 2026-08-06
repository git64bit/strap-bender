//////////////////////////////////////////////////////////////////////
// LibFile: pattern_reporting.scad
// Project: Strap Bender
// FileGroup: Reporting
// FileSummary: Reports compact pattern intent and derived expansion.
//////////////////////////////////////////////////////////////////////

module report_pattern_block(pattern, report_level = "full") {
    elements = pattern_block_elements(pattern);
    echo("--- Strap Bender pattern block ---");
    echo(str("Pattern: ", pattern_block_name(pattern)));
    echo(str("Local elements per repetition: ", len(elements)));
    echo(str("Required parameters: ",
        sb_pattern_required_parameter_names(pattern)));

    if (report_level == "full") {
        for (element_index = [0 : len(elements) - 1]) {
            element = elements[element_index];
            if (pattern_element_kind(element) == "straight")
                echo(str(
                    "Element ", element_index, ": straight '",
                    pattern_element_label(element), "' from parameter ",
                    pattern_element_distance_parameter(element)
                ));
            else
                echo(str(
                    "Element ", element_index, ": bend '",
                    pattern_element_label(element), "' angle parameter ",
                    pattern_element_angle_parameter(element), " x ",
                    pattern_element_angle_multiplier(element),
                    ", radius parameter ",
                    pattern_element_radius_parameter(element)
                ));
        }
        echo(str("Notes: ", pattern_block_notes(pattern)));
    }
}

module report_pattern_instance(instance, pattern, report_level = "full") {
    parameters = pattern_instance_parameters(instance);
    repeat_count = pattern_instance_repeat_count(instance);

    echo("--- Strap Bender pattern instance ---");
    echo(str("Instance: ", pattern_instance_name(instance)));
    echo(str("Pattern block: ", pattern_instance_pattern_name(instance)));
    echo(str("Repetitions: ", repeat_count));
    echo(str("Parameter assignments: ", len(parameters)));
    echo(str("Expanded command count: ", repeat_count *
        len(pattern_block_elements(pattern))));
    echo(str("Closure: ", pattern_instance_closure(instance)));

    for (parameter = parameters) {
        source = pattern_parameter_value_source(parameter);
        resolved = sb_resolve_numeric_value_source(source, repeat_count);
        echo(str(
            "Parameter ", pattern_parameter_name(parameter),
            ": ", sb_value_source_kind(source),
            ", range ", min(resolved), " to ", max(resolved)
        ));
    }

    if (report_level == "full") {
        for (parameter = parameters) {
            source = pattern_parameter_value_source(parameter);
            if (sb_is_value_schedule(source))
                report_value_schedule(
                    source,
                    repeat_count,
                    str("Pattern parameter ",
                        pattern_parameter_name(parameter))
                );
            else
                echo(str("Resolved ", pattern_parameter_name(parameter),
                    ": ", sb_resolve_numeric_value_source(
                        source,
                        repeat_count
                    )));
        }
        echo(str("Notes: ", pattern_instance_notes(instance)));
    }
}

module report_pattern_compilation(
    compilation,
    instance,
    pattern,
    report_level = "full"
) {
    shape = pattern_compilation_normalized_shape(compilation);
    commands = shape_commands(shape);
    straight_count = len([
        for (command = commands)
            if (command_kind(command) == "straight") command
    ]);
    bend_count = len(commands) - straight_count;

    echo("--- Strap Bender pattern compilation ---");
    echo(str("Source instance: ",
        pattern_compilation_source_instance_name(compilation)));
    echo(str("Source pattern: ",
        pattern_compilation_source_pattern_name(compilation)));
    echo(str("Repetitions: ", pattern_instance_repeat_count(instance)));
    echo(str("Commands: ", len(commands), " (", straight_count,
        " straight, ", bend_count, " bend)"));
    echo(str("Provenance records: ",
        len(pattern_compilation_provenance(compilation))));
    echo("Schedule convention: one resolved value per repetition/wave");

    if (report_level == "full") {
        resolved = pattern_compilation_resolved_parameters(compilation);
        for (parameter = resolved)
            echo(str(
                "Resolved ", pattern_parameter_name(parameter), ": ",
                pattern_parameter_value_source(parameter)
            ));
        echo(str("Notes: ", pattern_compilation_notes(compilation)));
    }
}
