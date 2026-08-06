# Strap Bender contract tests

Open each `.scad` file in this directory directly and press F5. A successful test prints a final `PASS` message in the OpenSCAD console.

## Foundation and routing

- `public_foundation_contract.scad`
- `bend_program_records_contract.scad`
- `arbitrary_length_program_contract.scad`
- `workbench_registry_contract.scad`
- `workbench_wrapper_contract.scad`

## Analytical path kernel

- `analytical_path_contract.scad` verifies an unequal-segment, mixed-radius open path, including exact line/arc kinds, bend centers, stations, endpoint pose, and bounds.
- `closed_path_contract.scad` verifies positional and tangent closure plus circular-arc extrema for a rounded square.
- `analytical_scale_contract.scad` compiles the accepted 73-command scale example and verifies arbitrary-length continuity and source provenance.

## Sampled diagnostic path

- `sampled_path_contract.scad` verifies chord-error control, exact endpoint retention, nonduplicated primitive boundaries, and sampling invariance of analytical length.
- `diagnostic_render_contract.scad` renders a closed diagnostic path with analytical tangent-point markers.

The analytical path uses the finished inside edge as its explicit reference axis. Its reported station length is not a neutral-axis developed length or a cut length. The sampled polyline is display-only and its approximate chordal length is not an analytical measurement.

## Batch 005 vertex-polygon contracts

- `vertex_polygon_contract.scad` validates source records, convex turns, tangent setbacks, retained straights, source labels, closure, length, and exact bounds.
- `polygon_equivalence_contract.scad` proves a rounded square authored as vertices produces the same analytical primitives as its explicit bend program.
- `concave_polygon_contract.scad` preserves one concave right turn and its independent radius.
- `polygon_feasibility_contract.scad` detects neighboring tangent setbacks that consume an edge.
- `vertex_polygon_workbench_wrapper_contract.scad` executes the complete named-polygon route through `main.scad`.


## Batch 006 regular-polygon contracts

- `regular_polygon_contract.scad` verifies equilateral-triangle generation, resolved sharp dimensions, convex turns, and exact closure.
- `regular_polygon_dimension_modes_contract.scad` proves equivalent side-length, circumradius, and apothem authorities generate the same rounded square and analytical path.
- `regular_polygon_radius_schedule_contract.scad` preserves an explicit mixed-radius pentagon through vertex and bend-command provenance.
- `regular_polygon_workbench_wrapper_contract.scad` executes the complete scalar Customizer route through `main.scad`.

## Batch 007 value-schedule contracts

- `value_schedule_contract.scad` verifies constant, explicit, periodic, and one-based every-nth resolution and rejects invalid counts and positions.
- `polygon_periodic_radius_contract.scad` routes compact schedules through explicit vertex and regular-polygon front ends, preserves resolved radii in normalized bends, and verifies closure.
- `regular_polygon_scheduled_workbench_contract.scad` executes the every-third Customizer configuration through `main.scad`.

Value schedules are compact authoring intent. Resolved lists are derived for a known consumer count; they are not maintained as a second source of truth.

## Batch 008 pattern and long-wave contracts

- `pattern_records_contract.scad` verifies pattern element, block, parameter, instance, compilation, and provenance records.
- `pattern_expansion_contract.scad` verifies exact per-wave segment arrays, angle multipliers, every-nth wave radii, labels, and local provenance.
- `long_wave_contract.scad` expands the 30-wave Laboratory instance to 180 commands, verifies all three bends in every third wave use R5, checks the approximately 15.6-foot analytical length, and exercises bounded sampling.
- `wave_pattern_scheduled_workbench_contract.scad` executes exact Customizer segment arrays and every-third-wave radius routing through `main.scad`.
- `wave_pattern_workbench_wrapper_contract.scad` executes the default compact Wave Pattern wrapper.

Pattern schedules resolve once per repetition. Expanded commands and resolved lists remain derived execution data; the named block and compact instance are authoritative.
