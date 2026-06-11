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
    aria2
    backblaze-b2
    bat
    btop
    cargo
    dyff
    fd
    ffmpeg
    fzf
    gh
    go
    imagemagick
    inetutils
    jq
    k9s
    kubectl
    kubectl-tree
    kubectx
    kubernetes-helm
    kustomize
    markdown-oxide
    neovim
    nnn
    nodejs
    poppler-utils
    python314
    rbw
    ripgrep
    uv
    yt-dlp
    zk
    zoxide

    (pass.withExtensions (
      ext: with ext; [
        # pass-import # TODO fix build on darwin
        pass-otp
      ]
    ))

    # Language servers
    gopls
    lua-language-server
    nil
    pyright
    rust-analyzer
    terraform-ls
    typescript-language-server

    # AI
    agent-browser
    codex
    mcp-grafana
    opencode
    pi-coding-agent
    playwright-mcp
  ];
}
