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

## Current status

Batch 001 establishes design documentation only. It contains no OpenSCAD implementation and no fixture geometry.

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

Strap Bender adopts the organizational lessons of Grid Stack and Polygon Stack. It is a self-contained project and will not depend at runtime on either repository.
