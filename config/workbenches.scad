//////////////////////////////////////////////////////////////////////
// LibFile: workbenches.scad
// Project: Strap Bender
// FileGroup: Workbench Routing
// FileSummary: Defines development, Bend Program, and Catalog routes.
//////////////////////////////////////////////////////////////////////

WORKBENCH_NAMES = ["development", "bend_program", "catalog"];

function workbench_name_valid(name) =
    len([for (candidate = WORKBENCH_NAMES)
        if (candidate == name) candidate]) == 1;

function workbench_render_mode_allowed(name, mode) =
    name == "catalog"
        ? mode == "report_only"
        : (name == "development" || name == "bend_program") &&
            (mode == "report_only" || mode == "diagnostic_path");

module validate_workbench_selection(
    workbench_name,
    project_name,
    project_registry,
    render_mode
) {
    assert(workbench_name_valid(workbench_name),
        str("Unknown Strap Bender workbench: ", workbench_name));
    assert(len(records_named(project_registry, project_name)) == 1,
        str("Project '", project_name,
            "' is not registered in workbench '", workbench_name, "'."));
    assert(workbench_render_mode_allowed(workbench_name, render_mode),
        str("Render mode '", render_mode,
            "' is not allowed in workbench '", workbench_name, "'."));
    echo(str("STRAP BENDER WORKBENCH: ", workbench_name));
    echo("STRAP BENDER WORKBENCH VALIDATION: PASS");
}
