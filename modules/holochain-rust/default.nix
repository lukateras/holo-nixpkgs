{  pkgs, rust_overlay ? builtins.fetchTarball "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz"}:
let
  nixpkgs = import <nixpkgs> {
    overlays = [ rust_overlay ];
  };

  date = "2019-01-24";
  wasmTarget = "wasm32-unknown-unknown";
  rust-build = (nixpkgs.rustChannelOfTargets "nightly" date [ wasmTarget ]);

  nodejs-8_13 = nixpkgs.nodejs-8_x.overrideAttrs(oldAttrs: rec {
    name = "nodejs-${version}";
    version = "8.13.0";
    src = pkgs.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1qidcj4smxsz3pmamg3czgk6hlbw71yw537h2jfk7iinlds99a9a";
    };
  });
in
with nixpkgs;
stdenv.mkDerivation rec {

 name = "holochain-rust-environment";

  buildInputs = [

    # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
    binutils gcc gnumake openssl pkgconfig coreutils

    cmake
    python
    pkgconfig
    rust-build

    nodejs-8_13
    yarn
    zeromq4
   ];
}
