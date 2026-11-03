{ ... }:

{
  homebrew = {
    casks = [
      "aws-vpn-client"
      "azure-cli" # TODO back to Nix when python3Packages.fabric is fixed
      "claude"
      "claude-code@latest"
      "royal-tsx"
      "tailscale-app"
    ];
  };
}
