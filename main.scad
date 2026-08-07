//////////////////////////////////////////////////////////////////////
// LibFile: main.scad
// Project: Strap Bender
// FileGroup: Shared Workbench Orchestrator
// FileSummary: Routes source front ends through one analytical path pipeline.
//////////////////////////////////////////////////////////////////////

include <strap_bender.scad>
include <config/defaults.scad>
include <registries/laboratory_projects.scad>
include <registries/catalog_projects.scad>
include <registries/laboratory_bend_programs.scad>
include <registries/laboratory_vertex_polygons.scad>
include <registries/laboratory_regular_polygons.scad>
include <patterns/standard_patterns.scad>
include <registries/laboratory_pattern_instances.scad>
include <registries/laboratory_strap_materials.scad>
include <registries/laboratory_radius_coupons.scad>
include <registries/laboratory_calibration_trials.scad>
include <config/projects.scad>
include <config/programs.scad>
include <config/polygons.scad>
include <config/regular_polygons.scad>
include <config/patterns.scad>
include <config/materials.scad>
include <config/calibration_coupons.scad>
include <config/calibration_trials.scad>
include <config/calibration_evidence.scad>
include <config/workbenches.scad>

module run_normalized_shape_pipeline(shape) {
    validate_bend_program_shape(shape);
    report_bend_program_shape(shape, wb_report_level);
    echo("STRAP BENDER NORMALIZED BEND-PROGRAM VALIDATION: PASS");

    analytical_path = compile_bend_program(shape);
    validate_analytical_path(analytical_path);
    report_analytical_path(analytical_path, wb_report_level);
    echo("STRAP BENDER ANALYTICAL PATH VALIDATION: PASS");

    if (wb_render_mode == "diagnostic_path") {
        validate_sampling_parameters(
            wb_sample_chord_error_mm,
            wb_sample_max_angle_step_degrees
        );
        sampled_path = sample_analytical_path(
            analytical_path,
            wb_sample_chord_error_mm,
            wb_sample_max_angle_step_degrees
        );
        validate_sampled_path(sampled_path, analytical_path);
        report_sampled_path(
            sampled_path,
            analytical_path,
            wb_report_level
        );
        echo("STRAP BENDER SAMPLED PATH VALIDATION: PASS");

        render_diagnostic_path(
            analytical_path = analytical_path,
            sampled_path = sampled_path,
            path_width_mm = wb_diagnostic_path_width_mm,
            path_height_mm = wb_diagnostic_path_height_mm,
            show_tangent_points = wb_show_tangent_points,
            tangent_marker_diameter_mm =
                wb_tangent_marker_diameter_mm
        );
        echo("STRAP BENDER DIAGNOSTIC PATH RENDER: PASS");
    }
}

module run_vertex_polygon_pipeline(polygon) {
    validate_vertex_polygon(polygon);
    report_vertex_polygon(polygon, wb_report_level);
    echo("STRAP BENDER VERTEX-POLYGON SOURCE VALIDATION: PASS");

    compilation = compile_vertex_polygon(polygon);
    validate_polygon_compilation(compilation, polygon);
    report_polygon_compilation(compilation, wb_report_level);
    echo("STRAP BENDER POLYGON COMPILATION VALIDATION: PASS");

    run_normalized_shape_pipeline(
        polygon_compilation_normalized_shape(compilation)
    );
}

module run_regular_polygon_pipeline(polygon) {
    validate_regular_polygon(polygon);
    report_regular_polygon(polygon, wb_report_level);
    echo("STRAP BENDER REGULAR-POLYGON SOURCE VALIDATION: PASS");

    compilation = compile_regular_polygon(polygon);
    validate_regular_polygon_compilation(compilation, polygon);
    report_regular_polygon_compilation(compilation, wb_report_level);
    echo("STRAP BENDER REGULAR-POLYGON COMPILATION VALIDATION: PASS");

    run_vertex_polygon_pipeline(
        regular_polygon_compilation_vertex_polygon(compilation)
    );
}

module run_pattern_pipeline(instance, pattern) {
    validate_pattern_instance(instance, pattern);
    report_pattern_block(pattern, wb_report_level);
    report_pattern_instance(instance, pattern, wb_report_level);
    echo("STRAP BENDER PATTERN SOURCE VALIDATION: PASS");

    compilation = compile_pattern_instance(instance, pattern);
    validate_pattern_compilation(compilation, instance, pattern);
    report_pattern_compilation(
        compilation,
        instance,
        pattern,
        wb_report_level
    );
    echo("STRAP BENDER PATTERN COMPILATION VALIDATION: PASS");

    run_normalized_shape_pipeline(
        pattern_compilation_normalized_shape(compilation)
    );
}

module run_strap_material_pipeline(material) {
    validate_strap_material(material);
    report_strap_material(material, wb_report_level);
    echo("STRAP BENDER STRAP MATERIAL VALIDATION: PASS");
}

module run_radius_calibration_coupon_pipeline(coupon) {
    validate_radius_calibration_coupon(coupon, STRAP_MATERIALS);
    report_radius_calibration_coupon(coupon, wb_report_level);
    echo("STRAP BENDER RADIUS CALIBRATION COUPON VALIDATION: PASS");

    if (wb_render_mode == "calibration_coupon") {
        render_radius_calibration_coupon(coupon);
        echo("STRAP BENDER RADIUS CALIBRATION COUPON RENDER: PASS");
    }
}

module run_calibration_trial_pipeline(trial, coupon) {
    validate_calibration_trial(
        trial,
        STRAP_MATERIALS,
        RADIUS_CALIBRATION_COUPONS
    );
    report_calibration_trial(trial, coupon, wb_report_level);
    echo("STRAP BENDER CALIBRATION TRIAL VALIDATION: PASS");
}

module run_calibration_evidence_pipeline(trials) {
    validate_calibration_trial_registry(
        trials,
        STRAP_MATERIALS,
        RADIUS_CALIBRATION_COUPONS
    );
    report_calibration_trial_registry(
        trials,
        RADIUS_CALIBRATION_COUPONS,
        wb_report_level
    );
    echo("STRAP BENDER CALIBRATION EVIDENCE REGISTRY VALIDATION: PASS");
}

module report_calibration_trial_draft(coupon) {
    validate_radius_calibration_coupon(coupon, STRAP_MATERIALS);
    echo("STRAP BENDER RADIUS OBSERVATION: DRAFT");
    echo(str("  selected source coupon: ", radius_coupon_name(coupon)));
    echo(str("  designed tool radius/angle: ",
        radius_coupon_tool_inside_radius_mm(coupon), " mm / ",
        radius_coupon_bend_angle_degrees(coupon), " deg"));
    echo("  no radius-observation evidence record emitted");
    echo(str(
        "  replace all specimen, process, and measurement fields, then set ",
        "Observation ready = true"
    ));
}

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
        echo("STRAP BENDER BEND-PROGRAM SOURCE VALIDATION: PASS");
        run_normalized_shape_pipeline(program);
    } else if (project_kind(project) == "vertex_polygon") {
        polygon = named_record(
            VERTEX_POLYGONS,
            wb_polygon_name,
            "vertex polygon"
        );
        run_vertex_polygon_pipeline(polygon);
    } else if (project_kind(project) == "regular_polygon") {
        regular_polygon = named_record(
            REGULAR_POLYGONS,
            wb_regular_polygon_name,
            "regular polygon"
        );
        run_regular_polygon_pipeline(regular_polygon);
    } else if (project_kind(project) == "strap_material") {
        material = named_record(
            STRAP_MATERIALS,
            wb_strap_material_name,
            "strap material"
        );
        run_strap_material_pipeline(material);
    } else if (project_kind(project) == "pattern") {
        pattern_instance = named_record(
            PATTERN_INSTANCES,
            wb_pattern_instance_name,
            "pattern instance"
        );
        pattern = named_record(
            PATTERN_BLOCKS,
            pattern_instance_pattern_name(pattern_instance),
            "pattern block"
        );
        run_pattern_pipeline(pattern_instance, pattern);
    } else if (project_kind(project) == "radius_calibration") {
        coupon = named_record(
            RADIUS_CALIBRATION_COUPONS,
            wb_radius_coupon_name,
            "radius calibration coupon"
        );
        run_radius_calibration_coupon_pipeline(coupon);
    } else if (project_kind(project) == "calibration_trial") {
        coupon = named_record(
            RADIUS_CALIBRATION_COUPONS,
            wb_calibration_trial_coupon_name,
            "radius calibration coupon"
        );
        if (wb_calibration_trial_ready) {
            run_calibration_trial_pipeline(
                WORKBENCH_CALIBRATION_TRIAL,
                coupon
            );
        } else {
            report_calibration_trial_draft(coupon);
        }
    } else if (project_kind(project) == "calibration_evidence") {
        run_calibration_evidence_pipeline(CALIBRATION_TRIALS);
    } else {
        echo("Strap Bender Catalog contains no accepted geometry.");
    }

    echo("STRAP BENDER PROJECT VALIDATION: PASS");
}

run_strap_bender_project();
