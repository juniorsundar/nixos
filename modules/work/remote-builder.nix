{ pkgs, ... }:

{
  nix.distributedBuilds = true;

  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "ssrc-workhorse";
      protocol = "ssh-ng";

      sshUser = "juniorsundar";
      sshKey = "/root/.ssh/nix-builder";

      system = "x86_64-linux";

      maxJobs = 8;
      speedFactor = 2;

      supportedFeatures = [
        "big-parallel"
      ];
    }
  ];
}
