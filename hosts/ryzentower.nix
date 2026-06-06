{ config, lib, ... }:

{
  imports = [
    ../modules/cli
    ../modules/dotfiles
    ../modules/gui
    ../modules/personal
  ];

  primaryUser.username = "khuedoan";
  primaryUser.authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5ue4np7cF34f6dwqH1262fPjkowHQ8irfjVC156PCG"
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBHpnKoOldKbNVElb8ve6ZQ8ArcipbyZBYsgNH8rJnqp0i/2RzOGEBJbDwnCrHuWXuS3BbsmmwoG/RlnqAyJdn4E="
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEtp6vl/snmGvkfoy42OwxSSWhd4PvlCxX4bx4NgXgvpXuITfq1NpRc7YTqn5LAWobyVEQ3/zKARI3aXH/YW0/s="
  ];

  networking = {
    hostName = "ryzentower";
  };

  hardware = {
    graphics = {
      enable32Bit = true;
    };
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      rocmSupport = true;
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-unwrapped"
        ];
    };
  };

  programs = {
    steam = {
      enable = true;
    };
  };

  services = {
    kanata = {
      enable = false;
      keyboards = {
        maxfit67 = {
          devices = [
            "/dev/input/by-id/usb-RONGYUAN_2.4G_Wireless_Device-if02-event-kbd"
          ];
          config = ''
            (defalias
              xcp (tap-hold-press 10 200 esc lctl)
              fn  (layer-toggle function)

              mau (movemouse-accel-up    5 800 1 30)
              mal (movemouse-accel-left  5 800 1 30)
              mad (movemouse-accel-down  5 800 1 30)
              mar (movemouse-accel-right 5 800 1 30)

              mwu (mwheel-up   50 120)
              mwd (mwheel-down 50 120)
            )

            (defsrc
              esc  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rctl
            )

            (deflayer default
              grv  _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              @xcp _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    lalt lmet           _              @fn  (layer-switch gaming)
            )

            (deflayer function
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    mmid @mau @mwu _    _    _    _    _    _    _    _    _
              _    mlft @mal @mad @mar mrgt @mal @mad @mau @mar _    _    _
              _    _    _    _    @mwd _    _    mlft mmid mrgt _    _
              _    _    _              @fn            _    _
            )

            (deflayer gaming
              esc  _    _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _    _    _
              lctl _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _              _              _    (layer-switch default)
            )
          '';
        };
      };
    };
  };

  home-manager.users.${config.primaryUser.username}.home.file.".config/sway/config.d/hardware".text =
    ''
      output "DP-3" {
        mode 2560x1440@180Hz
      }
      output "HDMI-A-1" {
        scale 2
      }
    '';
}
