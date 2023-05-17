{ stdenv, lib, fetchurl, unzip }:

{ sources, ... } @ args:
let
  # Keys by which to search the package's "sources" set for the host platform.
  hostOsKeys = with stdenv.hostPlatform; [
    system
    parsed.kernel.name
    parsed.cpu.name
    "all"
  ];

  platformKey = lib.findFirst
    (k: builtins.hasAttr k sources)
    (throw "Unsupported system: ${stdenv.hostPlatform.system}")
    hostOsKeys;

  src = sources.${platformKey};

in
(fetchurl ({
  inherit (builtins.trace src src) url;
  sha1 = if builtins.hasAttr "sha1" src then src.sha1 else null;
  sha256 = if builtins.hasAttr "sha256" src then src.sha256 else null;
} // removeAttrs args [ "sources" ]))
