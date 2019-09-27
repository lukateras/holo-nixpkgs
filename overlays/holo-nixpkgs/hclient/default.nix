{ stdenv, fetchFromGitHub, nodejs, npmToNix, utillinux, nodejs-12_x }:

stdenv.mkDerivation rec {
  name = "hclient-${version}";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "Holo-Host";
    repo = "hclient.js";
    rev = "3939abf016f33c0dc36d65da6847e1b278838e91";
    sha256 = "0j7lpcnlk91fw8zn4kdkjxrdz0qgwxriwbpn4gjln8dsjrbmd2qa";
  };

  nativeBuildInputs = [ nodejs-12_x utillinux ];

  preConfigure = ''
    cp -r ${npmToNix { inherit src; }} node_modules
    chmod -R +w node_modules
    patchShebangs node_modules
  '';

  buildPhase = ''
    #node_modules/parcel/bin/cli.js build ./src/index.ts --global hClient -o hClient.js
    npm run build # builds hclient-0.2.8.browser.min.js
  '';

  installPhase = ''
    mv dist $out
  '';
}
