# Strap Bender

Strap Bender is an OpenSCAD project for describing a single continuous PET pallet strap and deriving the geometry and tooling needed to form it.

The project is concerned primarily with two controlled quantities:

- tangent-to-tangent straight-segment lengths;
- the intended radius of each bend.

A shape may be a small closed polygon or a long open path containing many repeated and individually varied bends. A 10–20 foot wave pattern, for example, may repeat one family of segment lengths while assigning a 5 mm radius to every third bend and 1.6 mm to the others.

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

The strap path and the bending fixture are separate objects. One continuous path may require one full-form fixture, several aligned fixture sections, or a reusable sequential bending fixture. The fixture strategy will be selected after the path model and physical forming requirements are established.

## Active workbenches

Open the required entry point directly:

```text
workbenches/bend-program.scad   named arbitrary-length program selection
workbenches/catalog.scad        read-only accepted-object route
default.scad                    maintainer route
```

The Bend Program workbench does not expose `Bend A`, `Bend B`, or a hard-coded maximum bend count. It selects one complete bend-program record by exact name. The selected record may contain five commands or thousands; `main.scad` consumes the complete resolved command list without reconstructing it.

Mutable example records are registered in:

```text
registries/laboratory_bend_programs.scad
```

The registry currently contains a small mixed-radius example and a synthetic 36-bend scale example. Batch 003 compiles either record into exact line and circular-arc primitives with source provenance, poses, stations, arc centers, reference-axis length, and exact XY bounds. Compact wave-pattern, polygon, and other authoring front ends remain later work.

## Tests

Open each file under `tests/` directly and use F5. Every successful contract prints a final `PASS` message in the OpenSCAD console.

The arbitrary-length source-record contract validates a 73-command program containing 36 bends and 37 straights. Every third bend uses a 5 mm finished inside radius; the remaining bends use 1.6 mm.

The analytical contracts verify mixed left/right bends, unequal segment lengths, exact arc centers and bounds, rounded-square closure, and analytical compilation of the complete 73-command scale example.

## Current status

Batch 001 established the design contract. Corrected Batch 002 established the self-contained framework scaffold, versioned native source records, exact-name registries, validation, reporting, and arbitrary-length program routing.

Batch 003 adds the first analytical path kernel. Explicit straight and bend commands compile into exact line and circular-arc primitives with continuous poses and stations, signed bend geometry, exact circular extrema, closure checks, and source-command provenance. The analytical reference axis is the desired finished inside edge. Its reported length is not a neutral-axis developed length or a cut length.

No sampled preview, strap solid, forming compensation, pattern compiler, polygon compiler, or fixture geometry is implemented yet.

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
