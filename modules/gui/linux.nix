{
  config,
  inputs,
  pkgs,
  ...
}:

{
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-bamboo
        ];
        settings = {
          inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us";
              "DefaultIM" = "keyboard-us";
            };
            "Groups/0/Items/0" = {
              "Name" = "keyboard-us";
            };
            "Groups/0/Items/1" = {
              "Name" = "bamboo";
            };
          };
          globalOptions = {
            "Behavior" = {
              "ShowInputMethodInformation" = "False";
            };
            "Hotkey/TriggerKeys" = { };
            "Hotkey/EnumerateForwardKeys" = {
              "0" = "Control+Shift+space";
            };
          };
          addons = {
            bamboo = {
              globalSection = {
                InputMethod = "Telex 2";
              };
            };
          };
        };
      };
    };
  };

  programs = {
    dconf.enable = true;
    virt-manager = {
      enable = true;
    };
    gpu-screen-recorder.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };
  };

  home-manager.users.${config.primaryUser.username} = {
    # TODO use stable option when available and remove this
    imports = [ "${inputs.home-manager-unstable}/modules/services/voxtype.nix" ];

    home = {
      packages = [
        pkgs.unstable.brave
        pkgs.unstable.gnome-sound-recorder
        pkgs.unstable.kdePackages.kdeconnect-kde
        pkgs.libnotify
        pkgs.mpv
        pkgs.unstable.onlyoffice-desktopeditors
        pkgs.pavucontrol
        pkgs.pcmanfm
        pkgs.unstable.piper
        pkgs.xdg-utils
        pkgs.zathura
        pkgs.unstable.zed-editor
        pkgs.unstable.kitty
      ];

      pointerCursor = {
        enable = true;
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    services = {
      easyeffects.enable = true;

      voxtype = {
        enable = true;
        package = pkgs.unstable.voxtype-onnx;
        loadModels = [ "parakeet-unified-en-0.6b" ];
        settings = {
          engine = "parakeet";
          hotkey.enabled = false;
          parakeet = {
            model = "parakeet-unified-en-0.6b";
            streaming = true;
            # Streaming requires multiples of 80ms
            streaming_chunk_secs = 0.48;
            streaming_left_context_secs = 1.6;
            streaming_right_context_secs = 0.48;
          };
        };
      };
    };
  };
}
