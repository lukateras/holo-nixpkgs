{ config, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  services.hydra = {
    enable = true;
    extraConfig = ''
      max_output_size = 17179869184
    '';
    logo = ./logo.png;
    notificationSender = "hydra@holo.host";
    useSubstitutes = true;
  };

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts.hydra = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://localhost:${toString config.services.hydra.port}";
    };
  };
}
