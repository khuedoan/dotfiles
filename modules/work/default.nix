{
  config,
  pkgs,
  platform,
  ...
}:

{
  imports = [
    ./${platform.parsed.kernel.name}.nix
  ];

  home-manager.users.${config.primaryUser.username}.home.packages = with pkgs.unstable; [
    # acr-cli
    argocd
    awscli2
    azure-cli
    cmctl
    granted
    istioctl
    jira-cli-go
    kubelogin
    prometheus.cli
    sops
    ssm-session-manager-plugin
    tenv
    tflint
    yq-go
  ];
}
