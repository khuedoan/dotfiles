# My ~

Minimal, performance-focused dotfiles. Extremely snappy without sacrificing convenience.

![Screenshot](https://github.com/user-attachments/assets/baab84b5-d5cd-46a1-813a-8004a95d2ccf)

## Usage

My `$HOME` directory is basically just a Git repository that ignores untracked files by default,
allowing me to manage my dotfiles like any other projects.

```ini
; ~/.git/config
[status]
    showUntrackedFiles = no
```

I also have an automated setup that can configure everything from scratch using Nix,
which is available at [khuedoan/nixos-setup](https://github.com/khuedoan/nixos-setup).

My dotfiles are optimized for Linux, but since they are POSIX compliant, they should
work on macOS or BSD as well (as long as the necessary packages are available).

Please feel free to copy bits and pieces that you like ;)

## Performance

I always try to lazy load where possible.
This section attempts to demonstrate how snappy it is.

> - Last updated: December 7, 2023
> - Hardware: Ryzen 5 5600X, 32GB of RAM, running NixOS 23.11

Opening Zsh:

`time zsh -i -c exit` (47ms)

```
zsh -i -c exit  0.04s user 0.01s system 100% cpu 0.047 total
```

Opening the terminal (including waiting for the shell):

`time foot zsh -i -c exit` (67ms)

```
foot zsh -i -c exit  0.05s user 0.02s system 103% cpu 0.067 total
```

Opening Neovim with 32 plugins:

`:Lazy profile` (15ms)

```
Startuptime: 15.46ms

Based on the actual CPU time of the Neovim process till UIEnter.
This is more accurate than `nvim --startuptime`.
  LazyStart 4.97ms
  LazyDone  10.65ms (+5.68ms)
  UIEnter   15.46ms (+4.81ms)
```

## Acknowledgements

- [LunarVim/LunarVim Neovim config](https://github.com/ChristianChiarulli/LunarVim)
- [LunarVim/nvim-basic-ide Neovim config](https://github.com/LunarVim/nvim-basic-ide)
- [siduck76/NvChad Neovim config](https://github.com/siduck76/NvChad)
- [nvim-lua/kickstart.nvim config](https://github.com/nvim-lua/kickstart.nvim)
- [mattydebie/bitwarden-rofi script](https://github.com/mattydebie/bitwarden-rofi)
- [LazyVim/LazyVim config and lazy loading](https://github.com/LazyVim/LazyVim)
- [Vim statusline without a plugin](https://shapeshed.com/vim-statuslines)
- [Microphone tuning guide by Paul W. Frields](https://fedoramagazine.org/tune-up-your-sound-with-pulseeffects-microphones), [EasyEffects preset by MateusRodCosta](https://gist.github.com/MateusRodCosta/a10225eb132cdcb97d7c458526f93085) and the [modified version by jtrv](https://github.com/jtrv/.cfg/blob/morpheus/.config/easyeffects/input/fifine_male_voice_noise_reduction.json)
- [Swap two containers in Sway](https://www.reddit.com/r/swaywm/comments/z6t24k/comment/iy6mqxs)
- [How core Git developers configure Git](https://blog.gitbutler.com/how-git-core-devs-configure-git)
