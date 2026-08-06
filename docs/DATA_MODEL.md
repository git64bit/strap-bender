# Data model

## Record style

Strap Bender will use the shared Grid Stack / Polygon Stack record discipline:

- indexed OpenSCAD arrays;
- named constructors;
- named index constants;
- exact-name registry lookup;
- explicit schema versions;
- validation separated from rendering.

Field layouts are not defined by positional literals scattered through geometry files.

## Record families

### Strap specification

Identifies the physical strap used for design and calibration. Expected fields include:

- exact product identity and revision;
- material family;
- nominal width;
- nominal thickness;
- surface or embossing notes;
- measured values and measurement date when available.

The exact ULINE product record is pending confirmation.

### Shape specification

Owns shape identity, open/closed state, start pose, authoring-front-end identity, source program, and shape-schema version.

### Bend-program command

Represents one ordered straight, bend, pattern instance, or other explicitly supported command. Each command has a stable source index for diagnostics and fixture annotations.

### Pattern definition

Defines a reusable ordered command block. It may declare parameter slots for segment length, bend radius, bend angle, and other values.

### Pattern instance

References one pattern definition, repetition count, and value schedules. It preserves compact authoring intent even when the normalized path contains hundreds of primitives.

### Analytical path primitive

A derived line or circular arc containing exact geometric state and source provenance. Batch 003 records primitive kind, source-command index, label, exact start and end poses, cumulative start and end stations, and arc center, signed angle, and desired finished inside radius where applicable. Analytical primitives are generated, not hand-edited Catalog data.

### Analytical path

A generated ordered container for analytical primitives. Batch 003 records the source shape name, closure policy, explicit `finished_inside_edge` reference axis, start and end poses, exact XY bounds, and notes identifying the limits of the reference-axis length. It does not claim neutral-axis developed length or cut length.

### Forming calibration

Relates target geometry to fixture geometry for one physical strap and forming process. Expected fields include:

- strap-spec identity;
- target-radius range;
- tool-radius observations or mapping;
- forming temperature or cold-form condition;
- dwell and cooling/restraint conditions;
- measurement method;
- revision and qualification status.

### Fixture specification

Identifies the fixture family and its geometry-affecting settings without redefining the target strap path. Possible settings include clearance, engagement depth, retention strategy, segmentation policy, datum system, and printable envelope.

### Accepted object

A future immutable Catalog object embeds every geometry-affecting record needed to reproduce the target path and fixture. It records required API and schema versions, source release, accepted source commit, lifecycle status, and notes.

## Derived data rule

The following are derived and must not be maintained as independent authoritative fields:

- end poses;
- tangent-point coordinates;
- arc centers;
- analytical primitive lengths;
- total developed length;
- sampled point lists;
- bounds;
- fixture tile count;
- preview mesh.

Derived data may be echoed in reports or cached internally but must be reproducible from the authoritative records.

## Source and normalized forms

Both forms are retained during execution:

```text
authoring records
        ↓
expanded ordered commands
        ↓
normalized analytical line/arc primitives
        ↓
sampled display path and fixture geometry
```

Diagnostics must be able to trace any normalized primitive back to its source command, pattern instance, repetition index, and local pattern element.

## Mutable and immutable boundaries

- Laboratory and generator workbench records are mutable.
- Named OpenSCAD Customizer presets preserve useful experiments but are not accepted products.
- Catalog objects are read-only and immutable after physical acceptance.
- Changing an accepted geometry creates a new object revision rather than rewriting the old record.

## External-library boundary

No public record may require a BOSL2 data structure or a source file from Grid Stack or Polygon Stack. External libraries may implement internal operations behind Strap Bender-native constructors and accessors.
