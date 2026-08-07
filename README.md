# Strap Bender

Strap Bender is an OpenSCAD project for describing a single continuous PET pallet strap and deriving the geometry and tooling needed to form it.

The project is concerned primarily with two controlled quantities:

- tangent-to-tangent straight-segment lengths;
- the intended radius of each bend.

A shape may be a small closed polygon or a long open path containing many repeated and individually varied bends. A 10–20 foot wave pattern, for example, may assign a 5 mm bend radius to every third complete wave and 1.6 mm to the others while each straight family uses an independent schedule.

## Canonical model

The authoritative description is an ordered bend program:

```text
straight distance
bend direction, angle, and radius
straight distance
bend direction, angle, and radius
...
```

Polygon point lists, regular-polygon generators, wave generators, and other authoring methods are front ends. They compile into the same exact line-and-circular-arc path. Sampled point lists are derived rendering data and are never the source of truth.

## Project boundary

Every finished shape uses one continuous, unbranched strap. The project does not describe shapes made from disconnected pieces, multiple straps, internal cutouts, or branched networks.

The strap path and the bending fixture are separate objects. Batch 015 selects the first software fixture family: an open-top base with one circular inside-form post per analytical bend. Batch 018 adds deterministic sequential segmentation when a full fixture exceeds the configured print envelope. Every component preserves global station and tangent-pose setup datums while rendering at a local print origin. Physical calibration refines tool dimensions later and does not block application development.

## Active workbenches

Open the required entry point directly:

```text
workbenches/bend-program.scad     named arbitrary-length program selection
workbenches/vertex-polygon.scad   named ordered-vertex polygon selection
workbenches/regular-polygon.scad  schedule-capable regular-polygon Customizer
workbenches/wave-pattern.scad     compact repeated S-wave Customizer
workbenches/strap-profile.scad    exact physical strap product report
workbenches/radius-calibration.scad printable experimental radius coupon
workbenches/radius-observation.scad guarded coupon-linked measurement worksheet
workbenches/calibration-evidence.scad persistent evidence-registry audit
workbenches/catalog.scad          read-only accepted-object route
default.scad                      maintainer route
```

The Bend Program workbench does not expose `Bend A`, `Bend B`, or a hard-coded maximum bend count. It selects one complete bend-program record by exact name. The selected record may contain five commands or thousands; `main.scad` consumes the complete resolved command list without reconstructing it.

Mutable example records are registered in:

```text
registries/laboratory_bend_programs.scad
registries/laboratory_vertex_polygons.scad
registries/laboratory_regular_polygons.scad
patterns/standard_patterns.scad
registries/laboratory_pattern_instances.scad
registries/laboratory_strap_materials.scad
registries/laboratory_radius_coupons.scad
registries/laboratory_calibration_trials.scad
```

The bend-program registry contains a small mixed-radius example and a synthetic 36-bend scale example. The vertex-polygon registry contains a rounded square and a concave L-shaped example. The regular-polygon registry contains triangle, square, mixed-radius pentagon, and every-third-radius nonagon examples. Batch 007 adds reusable constant, explicit, periodic, and every-nth numeric schedules.

Batch 008 adds a reusable `THREE_SEGMENT_S_WAVE` topology and compact pattern instances. The Wave Pattern Customizer accepts a repetition count, three independent straight-segment schedules, a wave angle, and a radius schedule resolved once per wave. Its reference instance expands 30 waves to 180 commands and applies 5 mm radii to all three bends in waves 3, 6, 9, and so on. Pattern expansion still enters the shared bend-program, analytical-path, sampling, and diagnostic-rendering pipeline.

Batch 009 begins Phase 4 with the confirmed ULINE S-1655 black PET polyester strap record. Vendor nominal values are 5/8 inch width, .020 inch thickness, 750 lbf break strength, and 2,850 feet per coil. The Strap Profile workbench validates and reports that product identity without treating vendor values as measured calibration data.

Batch 010 adds the physical radius-observation evidence contract. One observation records specimen dimensions, bend angle, tool radius, forming conditions, post-release rest time, measured finished inside radius, measurement method, date, and stated uncertainty. Direct springback delta and radius ratios are derived from the observation, but no target-to-tool compensation model is fitted yet. No synthetic observation is registered as real calibration data.

Batch 011 adds the first printable calibration tooling: an open inside-form coupon with a designed tool radius, signed bend angle, tangent support lengths, full-width vertical form, and base. The designed tool radius is deliberately not treated as the predicted relaxed PET radius. Reference R1.6 and R5 coupons are Laboratory geometry only.

Batch 012 adds a guarded Radius Observation workbench and a coupon-linked calibration-trial record. A ready trial embeds one radius observation and names the exact calibration coupon used; validation requires the observation material, signed bend angle, and designed tool radius to match that coupon. The default workbench remains a draft and emits no evidence record until `Observation ready` is explicitly enabled.

Batch 013 adds the persistent calibration-evidence registry boundary. The registry is deliberately empty until real measured trials are supplied and reviewed. The Calibration Evidence workbench validates unique trial names, revalidates every registered trial against its strap material and exact source coupon, and reports that empirical compensation fitting is unavailable while no physical evidence is registered. This does not block application development.

Batch 014 adds non-rejecting sharp-source polygon self-intersection diagnostics. Nonadjacent source-edge crossings and touches are reported by stable edge index, while the project-wide policy for unsupported crossing fixtures remains deliberately unresolved.

Batch 015 begins Phase 5 with the first production-shape fixture software family. Every exact analytical arc becomes one cylindrical inside-form post at the exact arc center, with separate target/tool centers and entry/exit tangent datums plus source-command provenance. A rectangular base is derived from the exact path/post bounds plus margin and is rejected if it exceeds the configured print envelope. Until empirical calibration exists, tool radius intentionally equals requested finished inside radius and the entire plan is marked `experimental_uncompensated`.

Batch 016 adds pre-render fixture clearance validation. Exact post/post gaps and exact post/nonlocal-path distances are checked against configurable policy values. Nonlocal path clearance includes the ULINE strap nominal thickness plus an explicit clearance allowance; unsafe full-form fixtures fail before geometry rendering.

Batch 017 adds the first integral retention option: an open-top arc follower outside each bend post. The nominal radial slot equals strap thickness plus configured clearance, and the follower wall tracks only the signed bend sweep so entry and exit remain tangent openings. Exact follower bounds participate in base planning, while clearance checks use a conservative full-circle retention envelope before rendering. The workbenches can still select `none` when retention-free posts are wanted.

Batch 018 begins Phase 6 with deterministic long-form fixture segmentation. `fixture_layout_mode = "auto"` preserves one-piece fixtures when they fit the configured print envelope and automatically partitions oversized paths otherwise. Interior boundaries are generated only inside analytical straight primitives, so no bend post or arc follower is cut. Each printable sequential component has a stable zero-padded ID, exact analytical station range, global XY/heading boundary datums, local print-origin datum coordinates, bend-station manifest, and independently validated base bounds. `fixture_component_index` selects the one component rendered for STL export. The first strategy is explicitly sequential; components are not claimed to be butt-jointed tiles.

Batch 019 adds physical setup aids to those sequential components. Every interior split can receive the same keyed two-hole registration pattern on both neighboring components, derived from the exact split point and tangent heading. A nominal pin diameter plus explicit diametral hole clearance controls the printed holes. Each component also receives a recessed zero-padded index mark in a protected base-margin corner. Registration holes are validated against component bounds and the complete analytical strap path before rendering. They are intended for transfer pins or a common setup surface and do not convert overlapping sequential bases into butt-jointed tiles.

## Tests

Open each file under `tests/` directly and use F5. Every successful contract prints a final `PASS` message in the OpenSCAD console.

The arbitrary-length source-record contract validates a 73-command program containing 36 bends and 37 straights. Every third bend uses a 5 mm finished inside radius; the remaining bends use 1.6 mm.

The analytical contracts verify mixed left/right bends, unequal segment lengths, exact arc centers and bounds, rounded-square closure, and analytical compilation of the complete 73-command scale example. Sampling contracts verify chord-error control, exact endpoint retention, absence of duplicate primitive-boundary points, convergence toward exact arc length, and diagnostic geometry dispatch. Polygon contracts verify convex and concave classification, source-vertex provenance, tangent-setback feasibility, exact closure, and equivalence with an explicit bend program. Regular-polygon contracts verify triangle generation, dimension authorities, explicit corner-radius preservation, compact schedule resolution, and complete Customizer routing. Pattern contracts verify parameter-slot validation, exact expansion order, repetition and local-element provenance, explicit per-wave segment arrays, every-third-wave radius assignment, and a sampled analytical path between 10 and 20 feet. Strap-material contracts verify exact product identity, canonical metric storage, reversible vendor-unit conversions, explicit vendor-source provenance, validation, exact-name lookup, and the report-only Strap Profile route. Radius-observation contracts verify measured-evidence fields, material provenance, direct springback metrics, and exact-name lookup using explicitly synthetic test records only. Radius-calibration contracts verify the printable coupon record, exact tangent datums, left/right geometry, bounded chordal surface resolution, material provenance, and the exact Customizer wrapper. Calibration-trial contracts verify exact coupon provenance and require the embedded observation to match the selected coupon's strap material, signed bend angle, and designed tool radius. The Radius Observation wrapper defaults to a non-evidence draft state. Calibration-evidence contracts verify an intentionally empty physical registry, unique trial names, full revalidation of locally synthetic trial lists, and the report-only registry audit route. Bend-post fixture contracts verify one post per analytical arc, exact source datums, nominal radius preservation, bounded cylindrical tessellation, base-envelope validation, explicit uncompensated status, solid rendering, and routing from a shape workbench. Strap cut-plan contracts verify nominal mid-thickness and custom-fraction development, exact line/arc decomposition, open-path end allowances, explicit closed-path overlap/joining allowances, and closure-unassigned status. These tests validate software arithmetic only; they do not establish the PET neutral axis.

## Current status

Batch 001 established the design contract. Corrected Batch 002 established the self-contained framework scaffold, versioned native source records, exact-name registries, validation, reporting, and arbitrary-length program routing.

Batch 003 added the first analytical path kernel. Explicit straight and bend commands compile into exact line and circular-arc primitives with continuous poses and stations, signed bend geometry, exact circular extrema, closure checks, and source-command provenance.

Batch 004 adds adaptive arc sampling and a diagnostic preview of the desired finished inside-edge reference path. Sampling is controlled by a requested maximum chord error and a separate maximum angular step. Sampled points remain display-only data; exact analytical length, bounds, stations, and future fixture datums do not depend on preview resolution.

Batch 005 begins Phase 2 with the named vertex-polygon front end. Ordered sharp vertices plus a common or explicit per-corner radius list compile to circular tangent corners and retained straights. Source edge and vertex identities remain attached to normalized command labels and derived compilation records.

Batch 006 adds the regular-polygon front end. Side count plus one governing sharp dimension—side length, circumradius, or apothem—generates counter-clockwise sharp vertices.

Batch 007 adds native numeric value-schedule records. Constant, exact explicit, repeating periodic, and one-based every-nth rules resolve to explicit per-consumer values before polygon geometry is compiled. The included nonagon and Customizer route demonstrate 1.6 mm radii with 5 mm at positions 3, 6, and 9.

Batch 008 begins Phase 3 with named pattern blocks, compact repetition instances, parameter assignments, command-level repetition provenance, and the Wave Pattern Customizer. The 30-wave reference path is approximately 15.6 feet along the finished inside-edge analytical reference and remains compact until execution expansion is required.

Batch 009 begins Phase 4 with a versioned physical strap product record and the confirmed ULINE S-1655 nominal product data.

Batch 010 adds the schema, validation, reporting, exact-name support, and direct derived metrics needed to preserve individual physical radius observations. It deliberately registers no fabricated calibration measurements and does not yet fit a target-to-tool radius mapping.

Batch 011 adds a small printable inside-form radius-calibration coupon family and dedicated workbench so real bend observations can be collected against known designed tool geometry. It does not add retention, process recommendations, empirical measurements, or a compensation curve.

Batch 012 adds the guarded measurement-entry route that ties one ready observation to one named coupon without registering any synthetic result as physical evidence. Real measurements are still required before target-to-tool mapping can begin.

Batch 013 adds the explicit persistence boundary for reviewed calibration trials and a report-only audit workbench. The delivered physical trial registry is empty, so the software cannot yet derive or claim any target-to-tool radius compensation.

Batch 014 adds sharp-source polygon self-intersection detection and reporting without changing source acceptance policy. Batch 020 adds the normalized analytical-path diagnostic layer: every nonadjacent line/arc primitive pair is screened by exact analytical bounds, candidate pairs receive exact line/line, line/arc, or arc/arc minimum-distance evaluation, and intersections or near passes within a configurable threshold retain primitive and source-command provenance. Adjacent continuity neighbors are intentionally excluded and the diagnostic remains non-rejecting while crossing policy is unresolved.

Batch 021 adds nominal developed-length and cut-length planning to all four shape workbenches. The default model places the development axis at one-half of vendor nominal strap thickness outward from the finished inside edge; an explicit custom fraction is also available. Start allowance, end allowance, closure overlap, and joining allowance are independent user-entered values with zero defaults. Closed paths may select `none`, `butt`, or `overlap`; `none` leaves the physical seam explicitly unassigned rather than inventing a joining method. Every result is marked nominal and uncalibrated.

Batch 022 adds Catalog-ready object packaging and deterministic manufacturing/export manifests. Any of the four shape workbenches can package its normalized bend program together with the exact strap record, cut policy, fixture specification, layout mode, and setup-aid specification. The package remains `laboratory_candidate` and cannot claim physical acceptance. A derived manifest lists the nominal cut length plus one deterministic SCAD/STL filename per printable fixture component. Oversized long paths reuse the existing sequential segmentation plan, so the 30-wave reference produces 23 stable component exports. `api/v1.scad` is the first explicit versioned immutable-object API boundary, and `objects/README.md` defines the promotion rules. No accepted Catalog geometry is registered by Batch 022.
The first nominal production-shape fixture family, long-form segmentation, sequential setup registration, normalized analytical-path collision diagnostics, nominal cutting plan, deterministic manufacturing/export manifests, Catalog-ready recipe packaging, and versioned object API are implemented. Remaining major application work is strap-solid visualization plus a final completion/consistency pass. Physical Catalog registrations still require actual acceptance, while fitted forming compensation and calibrated neutral-axis correction remain later evidence-dependent refinements.

## Design documents

- `docs/PROJECT_SCOPE.md`
- `docs/SHAPE_DESCRIPTION.md`
- `docs/GEOMETRY_CONVENTIONS.md`
- `docs/DATA_MODEL.md`
- `docs/ARCHITECTURE.md`
- `docs/FIXTURE_DESIGN_BOUNDARY.md`
- `docs/VALIDATION_CONTRACT.md`
- `docs/OPEN_DECISIONS.md`
- `docs/ROADMAP.md`
- `docs/DEVELOPMENT_WORKFLOW.md`
- `docs/PROVENANCE.md`
- `docs/GLOSSARY.md`

## Framework lineage

Strap Bender adopts the organizational lessons of Grid Stack and Polygon Stack. It is a self-contained project and does not depend at runtime on either repository.
