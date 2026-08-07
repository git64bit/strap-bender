# Saved objects

Physically accepted Strap Bender objects will live here as immutable OpenSCAD recipes. A Laboratory manufacturing package is only a Catalog candidate; it does not enter this directory or the Catalog registry merely because the application can generate a valid fixture and export manifest.

An accepted object recipe must:

- include an explicit versioned API such as `../api/v1.scad`;
- assert the required API and object contract versions;
- embed the exact normalized bend-program shape, strap-material record, cut policy, fixture specification, fixture layout mode, and setup-aid specification;
- avoid Customizer state and mutable Laboratory registry lookup;
- retain source-authoring identity and source-commit provenance;
- retain physical acceptance date and acceptance notes;
- call `strap_bender_render_catalog_object_component()` exactly once;
- use a new object revision after any geometry-affecting accepted change.

For a segmented fixture, each printable component receives its own immutable component recipe and STL filename from the manufacturing manifest. All component recipes embed the same accepted object payload and differ only in the fixed component index passed to the public renderer.

Slicer-only settings are not geometry inputs. An accepted object may reference an associated 3MF manufacturing project, but printer profile, support behavior, horizontal expansion, and similar slicer settings remain outside the OpenSCAD geometry recipe.
