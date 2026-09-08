{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";

  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;

    buildMachines = [
      {
        hostName = "codeserver";
        sshUser = "khuedoan";
        sshKey = "/var/root/.ssh/nix-builder";
        protocol = "ssh-ng";
        system = "x86_64-linux";
        maxJobs = 4;
        supportedFeatures = [ "big-parallel" ];
      }
    ];
  };
}
