{ ... }:

{
  homebrew = {
    casks = [
      "discord"
      "iina"
      "signal"
      "zen"
    ];
    masApps = {
      # Need to be signed into the Mac App Store
      "Bitwarden" = 1352778147;
      "WireGuard" = 1451685025;
    };
  };
}
