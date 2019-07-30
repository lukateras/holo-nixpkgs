{
  imports = [ ../. ../master.nix ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      maxJobs = 2;
      supportedFeatures = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
      system = "x86_64-linux";
    }
  ];

  services.hydra.hydraURL = "https://private-hydra.holo.host";

  services.nginx.virtualHosts.hydra = {
    basicAuthFile = "/etc/nixos/htpasswd";
    serverName = "private-hydra.holo.host";
  };
}
