.POSIX:
.PHONY: default build switch diff update fmt check install clean

default: diff switch

build:
	./scripts/rebuild.py build --flake '.#$(host)'

diff: build
	nix run nixpkgs#dix -- \
		--verbose \
		/nix/var/nix/profiles/system ./result

switch:
	sudo ./scripts/rebuild.py switch --flake '.#$(host)'

# TODO find a better way to do this
~/.config/emacs:
	git clone --depth 1 https://github.com/doomemacs/core ~/.config/emacs
	~/.config/emacs/bin/doom install

update:
	nix flake update

fmt:
	nix run nixpkgs#nixfmt-tree

check:
	nix flake check

install:
	# This consumes significant memory on the live USB because dependencies are
	# downloaded to tmpfs. The configuration must be small, or the machine must
	# have a lot of RAM.
	sudo disko-install \
		--write-efi-boot-entries \
		--flake '.#$(host)' \
		--disk main '$(disk)'

clean:
	nix-collect-garbage --delete-old --log-format bar
