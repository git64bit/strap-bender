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

Batch 009 identifies the physical strap used for design and later calibration. The versioned product record stores:

- stable record name, manufacturer, and product number;
- material family, color, and surface;
- nominal width and thickness in millimeters;
- nominal break strength in newtons;
- nominal coil length in millimeters;
- recycled-content percentage;
- vendor source title, checked date, and explicit source locator;
- notes separating vendor nominal data from future measurements.

The first confirmed record is ULINE S-1655 black PET polyester strapping: 15.875 mm nominal width, 0.508 mm nominal thickness, 750 lbf nominal break strength, and 2,850 ft nominal coil length. Imperial values are reported through deterministic unit conversions. Measured specimen values and measurement dates use separate calibration records rather than overwriting the product identity.

### Radius observation

Batch 010 adds one immutable evidence record per physical bend observation. It stores the referenced strap-material name, specimen ID, measured width and thickness, bend angle, tool inside radius, forming method and temperature, dwell, cooling restraint, post-release rest time, measured finished inside radius, measurement method, measurement date, stated uncertainty, and notes.

The record can directly derive measured finished-minus-tool radius delta and dimensionless finished/tool or tool/finished ratios. These are summaries of one observation only. They are not a fitted springback law and do not convert a target radius into a tool radius. Synthetic contract-test records are never registered as physical calibration data.

### Calibration trial

Batch 012 adds a thin provenance wrapper around one radius observation. A calibration trial stores a stable trial name, the exact source calibration-coupon name, the embedded observation record, and notes. It does not duplicate coupon dimensions.

Validation resolves the named coupon and requires the embedded observation's strap material, signed bend angle, and tool inside radius to match the coupon. This keeps the generic radius-observation record usable for other controlled tools while preserving exact printed-coupon provenance when the Strap Bender coupon family is used.

No physical trial is registered by Batch 012. The Customizer workbench constructs a transient trial only after an explicit readiness gate is enabled.

### Calibration evidence registry

Batch 013 adds the persistent Laboratory registry for reviewed coupon-linked calibration trials. Registry membership is authoritative evidence provenance: a transient Customizer trial does not become persistent evidence automatically. Every registered trial must have a unique stable name and must pass the complete calibration-trial validation against the active strap-material and calibration-coupon registries.

The initial registry is intentionally empty. Synthetic test trials remain local to contract files and must never be copied into the physical registry. Target-to-tool fitting remains unavailable until real measurements are supplied, reviewed, and explicitly registered. Nominal uncompensated fixture planning may proceed in parallel as application development.

### Radius calibration coupon

Batch 011 adds an experimental printable-tool record for collecting radius observations. It stores stable coupon name, referenced strap material, designed tool inside radius, signed tool bend angle, entry and exit tangent lengths, form depth and height, base thickness and margin, tool-surface chord-error limit, maximum angular facet step, and notes.

The coupon record describes tool geometry only. Its designed radius is not a target-to-tool mapping and does not predict the relaxed finished PET radius. Exact tangent points and the ideal circular radius remain analytical datums; the printable surface is a bounded chordal approximation whose maximum sagitta is reported separately.

### Shape specification

Owns shape identity, open/closed state, start pose, authoring-front-end identity, source program, and shape-schema version.

### Bend-program command

Represents one ordered straight, bend, pattern instance, or other explicitly supported command. Each command has a stable source index for diagnostics and fixture annotations.

### Numeric value schedule

Batch 007 adds a compact, versioned source record for numeric values that must be assigned over an arbitrary consumer count. Supported kinds are:

- `constant`: repeat one value;
- `explicit`: require exactly one listed value per consumer;
- `periodic`: repeat a nonempty value cycle;
- `every_nth`: use a default value except at a one-based recurring position.

An every-nth schedule records default value, selected value, interval, and first selected position. For example, interval 3 and first position 3 selects positions 3, 6, 9, and so on. The source record remains compact; its resolved list is derived data.

### Vertex-polygon source

Batch 005 records a closed polygon name, ordered sharp XY vertices, desired finished inside-radius source, a selected start vertex, and notes. The radius source may be a legacy scalar or explicit list, or a Batch 007 value-schedule record. Geometry compilation always consumes the derived explicit list.

### Regular-polygon source

Batch 006 records a name, integer side count, one governing sharp-dimension kind and value, desired finished inside-radius source, center, first-sharp-vertex angle, selected start vertex, and notes. The radius source accepts a scalar, an exact list, or a Batch 007 compact schedule. Supported governing dimensions are sharp side length, sharp circumradius, and sharp apothem.

### Regular-polygon compilation

A generated compilation record stores the source identity, resolved sharp circumradius, apothem, side length, counter-clockwise sharp vertices, and generated vertex-polygon record. It is derived execution data. The regular-polygon source remains the authoring authority.

### Polygon corner and edge derivations

Generated corner records preserve source-vertex index, signed turn, orientation-independent convex/concave classification, radius, tangent setback, entry/exit tangent points, and normalized bend-command index. Generated edge records preserve source-edge index, tangent endpoints, retained straight length, heading, and normalized straight-command index.

### Polygon compilation

A generated compilation record groups the source name, derived corners, derived edges, and the normalized closed bend-program shape. It is diagnostic execution data, not a second authoritative shape definition.

### Pattern element and block

Batch 008 records reusable local topology as named pattern blocks. Each local element is either a straight referencing one distance parameter or a bend referencing angle and radius parameters plus a signed multiplier. Stable local labels support diagnostics. Parameter names may be reused by multiple elements of the same value role but may not serve conflicting distance, angle, and radius roles.

### Pattern parameter and instance

A pattern parameter assignment maps one required name to a scalar, explicit list, or compact value schedule. A pattern instance records source identity, pattern-block name, positive repetition count, complete parameter assignments, closure policy, start pose, and notes. Parameters resolve once per repetition, allowing every local bend in one wave to share one scheduled radius.

### Pattern compilation and provenance

Pattern compilation is derived execution data containing the source identities, resolved one-value-per-repetition parameter lists, normalized bend-program shape, and one trace per expanded command. Each trace records normalized command index, repetition index, local element index, and local label. The block and instance remain authoritative.

### Analytical path primitive

A derived line or circular arc containing exact geometric state and source provenance. Batch 003 records primitive kind, source-command index, label, exact start and end poses, cumulative start and end stations, and arc center, signed angle, and desired finished inside radius where applicable. Analytical primitives are generated, not hand-edited Catalog data.

### Analytical path

A generated ordered container for analytical primitives. Batch 003 records the source shape name, closure policy, explicit `finished_inside_edge` reference axis, start and end poses, exact XY bounds, and notes identifying the limits of the reference-axis length. It does not claim neutral-axis developed length or cut length.

### Sampled display path

A generated, non-authoritative container for a display polyline. Batch 004 records the source path name, reference axis, closure policy, sampled XY points, requested maximum chord error, maximum angular step, and explanatory notes. It deliberately does not duplicate exact analytical bounds, stations, or length. Changing sampling resolution may change point count and approximate polyline length without changing the analytical path.

### Forming calibration

Relates target geometry to fixture geometry for one physical strap and forming process. Expected fields include:

- strap-spec identity;
- target-radius range;
- tool-radius observations or mapping;
- forming temperature or cold-form condition;
- dwell and cooling/restraint conditions;
- measurement method;
- revision and qualification status.

### Bend-post fixture specification

Batch 015 implements the first concrete production-shape fixture source record. It stores a stable fixture name, exact strap-material name, radius policy, base thickness and margin, post height, maximum printable base width/depth, tool-surface chord-error and angular-step limits, retention mode, and notes. The initial supported values are `radius_mode = nominal_target` and `retention_mode = none`.

The source record does not contain target vertices or bend commands. It is applied to an already validated analytical path.

### Derived bend-post station

One station is created for every analytical arc. It stores source-command index and label, global start/end station, target center, tool center, signed bend angle, requested finished inside radius, resolved tool radius, target tangent entry/exit points, and tool tangent entry/exit points. In the Batch 015 nominal mode, tool radius, center, and tangent datums equal their target counterparts.

### Derived bend-post fixture plan

The plan stores fixture identity, source analytical-path identity and reference axis, explicit status, ordered bend stations, derived base bounds, and notes. `experimental_uncompensated` is mandatory for the nominal policy. Base bounds cover both the analytical target bounds and complete post circles, then add the configured margin. The plan is transient derived data; it does not replace either the target path or the fixture source specification.

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
resolved value schedules
        ↓
expanded ordered commands
        ↓
normalized analytical line/arc primitives
        ↓
sampled display path and fixture geometry
```

Diagnostics can trace a normalized primitive to its expanded command index. Batch 008 maps that command to the source pattern instance, repetition index, local element index, and local label through the pattern-compilation provenance list.

## Mutable and immutable boundaries

- Laboratory and generator workbench records are mutable.
- Named OpenSCAD Customizer presets preserve useful experiments but are not accepted products.
- Catalog objects are read-only and immutable after physical acceptance.
- Changing an accepted geometry creates a new object revision rather than rewriting the old record.

## External-library boundary

No public record may require a BOSL2 data structure or a source file from Grid Stack or Polygon Stack. External libraries may implement internal operations behind Strap Bender-native constructors and accessors.
