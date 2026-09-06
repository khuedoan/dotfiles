{ config, pkgs, ... }:

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
    home = {
      packages = [
        pkgs.unstable.brave
        pkgs.foot
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
      ];

      pointerCursor = {
        enable = true;
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
