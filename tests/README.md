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
