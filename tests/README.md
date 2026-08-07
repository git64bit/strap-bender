# Strap Bender contract tests

Open each `.scad` file in this directory directly and press F5. A successful test prints a final `PASS` message in the OpenSCAD console.

## Foundation and routing

- `public_foundation_contract.scad`
- `bend_program_records_contract.scad`
- `arbitrary_length_program_contract.scad`
- `workbench_registry_contract.scad`
- `workbench_wrapper_contract.scad`
- `strap_material_records_contract.scad`
- `strap_profile_workbench_wrapper_contract.scad`
- `radius_calibration_workbench_wrapper_contract.scad`
- `radius_observation_workbench_wrapper_contract.scad`
- `calibration_evidence_workbench_wrapper_contract.scad`

## Analytical path kernel

- `analytical_path_contract.scad` verifies an unequal-segment, mixed-radius open path, including exact line/arc kinds, bend centers, stations, endpoint pose, and bounds.
- `closed_path_contract.scad` verifies positional and tangent closure plus circular-arc extrema for a rounded square.
- `analytical_scale_contract.scad` compiles the accepted 73-command scale example and verifies arbitrary-length continuity and source provenance.

## Batch 020 analytical path diagnostics

- `analytical_path_diagnostics_contract.scad` verifies exact line/line crossing and near distance, line/arc tangency and near distance, arc/arc crossing, nonadjacent-pair selection, provenance, report validation, and intersection classification.
- The four shape workbench routes enable normalized path diagnostics by default with a configurable near threshold. Adjacent analytical continuity neighbors are excluded.

## Batch 021 nominal strap cut-plan contract

- `strap_cut_plan_contract.scad` verifies nominal mid-thickness development using the ULINE S-1655 vendor nominal thickness, explicit custom-fraction development, open-path start/end allowances, closed-path overlap/joining allowances, and closure-unassigned status.
- All four shape workbenches enable the nominal cut report by default. Every reported cut length is explicitly nominal and uncalibrated; no contract treats the 0.5 default as measured PET behavior.

## Sampled diagnostic path

- `sampled_path_contract.scad` verifies chord-error control, exact endpoint retention, nonduplicated primitive boundaries, and sampling invariance of analytical length.
- `diagnostic_render_contract.scad` renders a closed diagnostic path with analytical tangent-point markers.

The analytical path uses the finished inside edge as its explicit reference axis. Its reported station length is not a neutral-axis developed length or a cut length. The sampled polyline is display-only and its approximate chordal length is not an analytical measurement.

## Batch 023 strap-solid visualization contracts

- `strap_solid_contract.scad` renders synthetic open and closed nominal strap bodies using exact material width/thickness plus the bounded sampled analytical path.
- `strap_solid_workbench_contract.scad` executes the Vertex Polygon route with strap-solid-only rendering and verifies that material routing is available independently of cut-plan, manufacturing-package, and fixture rendering.
- `wave_pattern_segmented_fixture_contract.scad` now also enables strap-solid display while rendering component 0, exercising component-bounds clipping and the shared local XY print translation.

The strap solid is a reference-centered display convention. It does not redefine the analytical finished-inside-edge target, neutral-axis position, cut length, fixture clearances, or empirical radius compensation.

## Batch 005 vertex-polygon contracts

- `vertex_polygon_contract.scad` validates source records, convex turns, tangent setbacks, retained straights, source labels, closure, length, and exact bounds.
- `polygon_equivalence_contract.scad` proves a rounded square authored as vertices produces the same analytical primitives as its explicit bend program.
- `concave_polygon_contract.scad` preserves one concave right turn and its independent radius.
- `polygon_feasibility_contract.scad` detects neighboring tangent setbacks that consume an edge.
- `vertex_polygon_workbench_wrapper_contract.scad` executes the complete named-polygon route through `main.scad`.


## Batch 014 polygon-intersection diagnostic contract

- `polygon_self_intersection_contract.scad` verifies that adjacent shared endpoints are ignored, a simple concave polygon remains non-crossing, and a synthetic crossing polygon reports source edges 1 and 3 without becoming an asserting validation failure.

The diagnostic operates on the ordered sharp source polygon. It does not yet claim complete intersection or near-intersection analysis for the rounded analytical line/arc path.

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

## Batch 009 strap-product contracts

- `strap_material_records_contract.scad` verifies ULINE S-1655 identity, canonical metric values, reversible imperial conversions, explicit source metadata and locator, validation, and exact-name lookup.
- `strap_profile_workbench_wrapper_contract.scad` executes the report-only Strap Profile route through `main.scad`.

The product record contains vendor nominal data. It does not claim measured dimensions, radius compensation, springback, neutral-axis location, or strap cutting length.


## Batch 010 radius-observation contracts

- `radius_observation_contract.scad` verifies specimen measurements, forming-condition fields, material provenance, exact-name lookup, springback delta, and finished/tool radius ratios.

All values in the Batch 010 contract are explicitly synthetic test data. The repository still contains no claimed physical springback measurements and no fitted compensation curve.


## Batch 011 radius-calibration coupon contracts

- `radius_calibration_coupon_contract.scad` verifies material-linked coupon records, R1.6/R5 exact-name lookup, analytical entry/exit tangent datums, negative-angle mirroring, bounded circular-surface tessellation, and renders the printable reference coupon.
- `radius_calibration_workbench_wrapper_contract.scad` executes the exact default Radius Calibration Customizer route through `main.scad`.

The designed tool radius is not a predicted relaxed PET radius. Coupon geometry exists to collect physical evidence for a later compensation model.

## Batch 012 coupon-linked observation contracts

- `calibration_trial_contract.scad` verifies exact source-coupon provenance and cross-checks strap material, signed bend angle, and designed tool radius against a synthetic embedded observation.
- `radius_observation_workbench_wrapper_contract.scad` executes the exact default Radius Observation Customizer wrapper and proves it remains gated as a draft.
- `radius_observation_ready_workbench_contract.scad` supplies explicitly synthetic values, enables the readiness gate, and executes the complete coupon-linked trial route through `main.scad`.

No Batch 012 test value is physical PET evidence. The readiness switch requests transient evidence construction. A non-fatal completeness gate first requires every mandatory worksheet value to be valid; only then do the strict calibration-record validators run. This does not validate the experimental process or measurement method itself.



## Batch 013 persistent calibration-evidence contracts

- `calibration_trial_registry_contract.scad` proves the delivered physical registry is empty, verifies unique-name detection, and validates a locally constructed synthetic one-trial registry without persisting it.
- `calibration_evidence_workbench_wrapper_contract.scad` executes the report-only Calibration Evidence route and confirms that zero physical trials are registered.

The synthetic record in the registry contract is test-local only. Batch 013 persists no PET springback measurement and therefore provides no basis for target-to-tool compensation.

## Batch 015 bend-post fixture contracts

- `bend_post_fixture_contract.scad` compiles the accepted rounded-square source, derives four exact bend stations, verifies nominal R10 posts, exact base bounds, bounded post-surface tessellation, uncompensated status, and renders the complete fixture solid.
- `bend_post_fixture_workbench_contract.scad` executes `bend_post_fixture` rendering through the regular-polygon → vertex-polygon → bend-program → analytical-path pipeline.

The Batch 015 fixture is a software-completion family, not a calibrated PET prediction. In `nominal_target` mode the printed post radius intentionally equals the requested finished inside radius and reports `experimental_uncompensated`. Pending coupon measurements do not block further fixture, segmentation, or Catalog software development.



## Batch 016 fixture-clearance contracts

- `bend_post_clearance_contract.scad` verifies post/post and post/nonlocal-path distances, preserves the retention-free Batch 016 policy, and exercises a deliberately strict post-gap issue list.

## Batch 017 arc-follower retention contracts

- `bend_post_retention_contract.scad` verifies nominal strap-slot width, follower inner/outer radii, exact follower-aware base bounds, bounded follower tessellation, conservative retention clearance envelopes, right-turn follower construction, and renders a retained rounded-square fixture.
- `bend_post_fixture_contract.scad` now renders the default retained fixture with four R10 posts and four open-top arc followers.
- `bend_post_fixture_workbench_contract.scad` verifies the Customizer route preserves `arc_follower` mode and follower wall thickness.

The arc follower is still nominal/uncompensated. Its slot is derived from the vendor nominal strap thickness plus configured clearance; it does not imply a calibrated springback result.

### Corrected Batch 017 regression contracts

- `fixture_material_routing_contract.scad` verifies that any `bend_post_fixture` render route receives the registered ULINE strap material, independent of the shape-authoring workbench.
- `radius_observation_incomplete_workbench_contract.scad` sets `Observation ready = true` with incomplete worksheet values and verifies that the workbench reports actionable incompleteness without emitting an evidence record or terminating on an assertion.
- `radius_observation_ready_workbench_contract.scad` remains the strict ready-state proof: once every required field is valid, the transient trial is constructed and the existing calibration validators run unchanged.

The correction does not weaken evidence validation. It adds a non-fatal completeness gate before strict validation and fixes dependency routing for physical fixture generation.

## Batch 018 long-form fixture segmentation contracts

- `fixture_segmentation_contract.scad` expands the accepted 30-wave source, proves the one-piece retained fixture exceeds a 220 x 220 mm print envelope, partitions it into deterministic sequential components, validates exact contiguous station coverage, shared split poses, one-time bend assignment, independently printable bounds, stable component IDs, and renders component 0 at a local print origin.
- `wave_pattern_segmented_fixture_contract.scad` executes the complete 30-wave Customizer source through `main.scad` with `fixture_layout_mode = "segmented"` and component 0 selected for render.

Interior segmentation boundaries are generated only inside analytical straight primitives, never through a bend post or arc follower. The first long-form strategy is sequential: component records preserve exact global station/XY/heading setup datums, while each printable component is translated to its own local XY origin. These components are not represented as mechanically butt-jointed tiles in Batch 018.

## Batch 019 segmented fixture setup-aid contracts

- `fixture_setup_aid_contract.scad` verifies the default 3 mm pin / 3.3 mm printed-hole policy, exact shared registration pairs across all 22 interior boundaries of the 23-component long-wave reference, base/path clearance validation, deterministic `001` through `023` physical index marks, and setup-aid rendering on component 0.
- `wave_pattern_segmented_fixture_contract.scad` now also verifies that the complete Customizer route preserves `pin_pair` registration and recessed component marking before rendering the selected segmented component.

Batch 019 registration holes are sequential transfer/common-board datums. They do not represent a butt-jointed or simultaneously assembled tile strategy.


## Batch 022 manufacturing and Catalog packaging contracts

- `manufacturing_manifest_contract.scad` verifies deterministic one-piece and segmented export manifests, including the 23-component long-wave case and stable SCAD/STL filenames.
- `catalog_object_contract.scad` verifies exact embedding of geometry-affecting records, candidate non-acceptance semantics, accepted-state provenance requirements, and deterministic regeneration of manufacturing plans. All accepted-state values in this contract are explicitly synthetic test data.
- `api_v1_contract.scad` verifies the explicit saved-object API/version boundary.
- `manufacturing_workbench_contract.scad` proves manufacturing packaging can be enabled independently of cut-plan display and fixture rendering while still routing the required strap material.

Batch 022 creates no physical Catalog object. `registries/catalog_projects.scad` remains the accepted-object stub until a real fixture/strap result is physically approved and an immutable recipe is explicitly added.
