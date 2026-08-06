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
validation and reporting
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

## Candidate workbenches

The initial workbench set is a design proposal, not implemented in this batch:

```text
workbenches/bend-program.scad      explicit ordered straights and bends
workbenches/regular-polygon.scad   regular polygon convenience generator
workbenches/wave-pattern.scad      repeated long-form pattern generator
workbenches/catalog.scad           read-only accepted-object route
```

Additional shape-specific workbenches should exist only when they provide a focused interface. They must compile to the same native shape records rather than introducing separate geometry engines.

## Proposed repository areas

```text
api/          versioned public constructors and execution modules
config/       defaults and active workbench selection
lib/          record accessors, mathematics, validation, reporting
geometry/     strap preview and fixture solids
paths/        bend-program compilation and analytical path operations
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

## Shape boundary

All authoring front ends terminate at one Strap Bender analytical path contract. Regular polygons, vertex polygons, waves, and explicit bend sequences may not bypass this boundary and directly generate unrelated fixture solids.

## Exact geometry and rendering boundary

Line and circular-arc primitives are authoritative. Sampled points exist only for consumers that require them. Preview resolution must not alter validation, measurements, or fixture datum positions.

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
- Geometry renders the strap or fixture.

A render module must not be the only place where an invalid path is detected.

## Catalog boundary

Laboratory presets are mutable. After physical testing, an accepted path, strap specification, calibration, fixture specification, and provenance record may be embedded in an immutable Catalog object with a versioned API.
