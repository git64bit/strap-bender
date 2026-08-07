//////////////////////////////////////////////////////////////////////
// LibFile: api_v1_contract.scad
// Project: Strap Bender
// FileGroup: Direct-Open F5 Contract Test
// FileSummary: Verifies the explicit immutable-object API version boundary.
//////////////////////////////////////////////////////////////////////

include <../api/v1.scad>

assert(STRAP_BENDER_API_VERSION == 1,
    "Versioned API wrapper must expose Strap Bender API version 1.");
assert(STRAP_BENDER_CATALOG_OBJECT_CONTRACT_VERSION == 1,
    "Versioned API wrapper must expose Catalog object contract version 1.");
assert(STRAP_BENDER_MANUFACTURING_MANIFEST_CONTRACT_VERSION == 1,
    "Versioned API wrapper must expose manufacturing manifest contract version 1.");

echo("STRAP BENDER API V1 CONTRACT: PASS");
