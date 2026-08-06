//////////////////////////////////////////////////////////////////////
// LibFile: main.scad
// Project: Strap Bender
// FileGroup: Shared Workbench Orchestrator
// FileSummary: Routes wrappers through validation and analytical compilation.
//////////////////////////////////////////////////////////////////////

include <strap_bender.scad>
include <config/defaults.scad>
include <registries/laboratory_projects.scad>
include <registries/catalog_projects.scad>
include <registries/laboratory_bend_programs.scad>
include <config/projects.scad>
include <config/programs.scad>
include <config/workbenches.scad>

module run_strap_bender_project() {
    validate_workbench_selection(
        wb_workbench_name,
        wb_project_name,
        PROJECTS,
        wb_render_mode
    );

    project = named_record(PROJECTS, wb_project_name, "project");
    validate_project(project);
    report_project(project, wb_report_level);

    if (project_kind(project) == "bend_program") {
        program = named_record(
            BEND_PROGRAMS,
            wb_program_name,
            "bend program"
        );

        validate_bend_program_shape(program);
        report_bend_program_shape(program, wb_report_level);
        echo("STRAP BENDER BEND-PROGRAM RECORD VALIDATION: PASS");

        analytical_path = compile_bend_program(program);
        validate_analytical_path(analytical_path);
        report_analytical_path(analytical_path, wb_report_level);
        echo("STRAP BENDER ANALYTICAL PATH VALIDATION: PASS");
    } else {
        echo("Strap Bender Catalog contains no accepted geometry.");
    }

    echo("STRAP BENDER PROJECT VALIDATION: PASS");
}

run_strap_bender_project();
