# Architecture

## Framework principle

Strap Bender adopts the self-contained workbench framework demonstrated by Grid Stack and Polygon Stack. Generic organization may be copied and adapted, but Strap Bender will not include or use files from either sibling repository at runtime.

## Proposed execution route

Each executable workbench assigns Customizer-visible values and includes `main.scad`.

```text
Customizer workbench
        ↓
config/defaults.scad resolves stable wb_* values
        ↓
active workbench registry and exact-name lookup
        ↓
record construction
        ↓
validation and compact schedule resolution
        ↓
shape compiler
        ↓
normalized analytical path
        ↓
preview, measurement, or fixture planner
        ↓
geometry dispatch
```

`default.scad` will remain a maintainer-oriented route rather than the primary user workbench.

## Workbench plan

The Bend Program, Vertex Polygon, Regular Polygon, Wave Pattern, and Catalog routes are implemented:

```text
workbenches/bend-program.scad      explicit ordered straights and bends
workbenches/vertex-polygon.scad    named ordered vertices and corner radii
workbenches/regular-polygon.scad   schedule-capable regular polygon generator
workbenches/wave-pattern.scad      compact repeated S-wave generator
workbenches/catalog.scad           read-only accepted-object route
```

Additional shape-specific workbenches should exist only when they provide a focused interface. They must compile to the same native shape records rather than introducing separate geometry engines.

## Proposed repository areas

```text
api/          versioned public constructors and execution modules
config/       defaults and active workbench selection
lib/          record accessors, schedule validation, validation, reporting
geometry/     diagnostic preview, future strap preview, and fixture solids
paths/        schedule resolution, shape compilation, analytical operations
registries/   exact-name registries
objects/      immutable accepted recipes
patterns/     reusable bend-program pattern definitions
calibration/  strap and forming calibration records
fixtures/     fixture-family planners and component geometry
workbenches/  executable Customizer entry points
tests/        direct-open F5 contract tests
docs/         project contracts and decisions
```

Folders should be created only when the first implementation requires them.

## Schedule boundary

Batch 007 introduces compact numeric schedules as authoring records, not geometry. A consumer validates its count and value domain, then resolves the schedule to an explicit list before tangent setbacks, bend commands, or analytical primitives are calculated. Source position is one-based for human-facing every-nth rules; derived arrays remain zero-based internally. Reordering a normalized polygon command sequence does not renumber source schedule positions.

Batch 008 applies the same schedule records to pattern parameters. Each parameter resolves once per repetition. A local pattern element may reuse that repetition value, so the three bends in one S-wave can share one radius while the next wave receives another. Segment parameter schedules remain independent; explicit lists can assign a different base, rising, and falling straight length to every wave.

## Shape boundary

All authoring front ends terminate at one Strap Bender analytical path contract. Batch 005 demonstrates this by normalizing a vertex polygon to the existing ordered bend-program record before analytical compilation. Batch 006 inserts regular-polygon generation one stage earlier. Batch 007 resolves compact radius schedules before either polygon front end calculates tangent geometry. Batch 008 adds the parallel pattern route: compact instance → per-repetition parameter resolution → expanded commands with provenance → normalized bend program → analytical path. Waves and explicit bend sequences may not bypass this boundary and directly generate unrelated fixture solids.

## Pattern expansion boundary

A pattern block owns only reusable local topology and named parameter slots. A pattern instance owns the repetition count, parameter value sources, start pose, and closure policy. Compilation produces contiguous bend-program source indexes plus a separate provenance record for every expanded command containing:

- source pattern instance;
- zero-based repetition index;
- zero-based local element index;
- stable local element label.

The compact block and instance remain authoritative. Expanded commands and resolved parameter lists are derived execution data and are not maintained as a second editable source.

## Exact geometry and rendering boundary

Line and circular-arc primitives are authoritative. Batch 003 implements this boundary for explicit bend programs using the desired finished inside edge as the named analytical reference axis. Batch 004 adds a sampled-path consumer controlled by maximum chord error and maximum angular step, plus a thin diagnostic renderer. The sampled record is derived display data. Preview resolution may change point count and chordal display length, but it must not alter analytical validation, measurements, exact bounds, stations, or fixture datum positions.

## Target and fixture boundary

The target strap path is independent of:

- springback compensation;
- fixture clearance;
- strap retention;
- fixture segmentation;
- printer envelope;
- assembly hardware.

The fixture planner consumes the target path plus strap, calibration, and fixture records. It does not rewrite the target definition.

## Long-path performance

A 10–20 foot shape may contain hundreds or thousands of bends. The implementation should therefore:

- preserve compact pattern instances until expansion is required;
- use analytical primitives for length and bounds;
- sample arcs adaptively and only for visible or printable geometry;
- support diagnostic modes that do not render the entire fixture;
- keep fixture segmentation independent from command expansion;
- avoid constructing one enormous high-resolution polygon merely to calculate measurements.

## BOSL2 boundary

BOSL2 is a candidate implementation library for path and geometry operations. The dependency decision is deferred. Whether native or BOSL2 operations are used, the public model and saved objects remain Strap Bender-native and exact line/arc semantics remain visible.

## Validation, reporting, and rendering separation

- Validation returns contract failures and diagnostics.
- Reporting explains resolved records and derived measurements.
- Mathematics compiles and measures paths.
- Geometry renders diagnostic paths, future strap solids, or fixtures.

A render module must not be the only place where an invalid path is detected.

## Catalog boundary

Laboratory presets are mutable. After physical testing, an accepted path, strap specification, calibration, fixture specification, and provenance record may be embedded in an immutable Catalog object with a versioned API.
