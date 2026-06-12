{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.zsh.loginShellInit = ''
    if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
      exec sway
    fi
  '';

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
    sway = {
      enable = true;
      wrapperFeatures = {
        gtk = true;
      };
      extraPackages = with pkgs; [
        autotiling
        brightnessctl
        feh
        foot
        grim
        i3status-rust
        libnotify
        mako
        mpv
        pavucontrol
        pcmanfm
        rofi
        slurp
        soteria
        swayidle
        swaylock
        wl-clipboard
        xdg-utils
        zathura
      ];
    };
    dconf.enable = true;
    virt-manager = {
      enable = true;
    };
    gpu-screen-recorder.enable = pkgs.stdenv.hostPlatform.isx86_64;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
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
    home = {
      packages =
        with pkgs.unstable;
        [
          gnome-sound-recorder
          kdePackages.kdeconnect-kde
        ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
          brave
          gpu-screen-recorder
          onlyoffice-desktopeditors
          piper
        ];

      pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    services.easyeffects.enable = true;

    gtk = {
      enable = true;
      colorScheme = "dark";
    };
  };
}
