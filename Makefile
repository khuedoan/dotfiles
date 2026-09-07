.POSIX:
.PHONY: default build switch diff update fmt check install install-pxe clean

default: diff switch

build:
	./scripts/rebuild.py build --flake '.#$(host)'

diff: build
	nix run nixpkgs#dix -- \
		--verbose \
		/nix/var/nix/profiles/system ./result

switch:
	sudo ./scripts/rebuild.py switch --flake '.#$(host)'

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

install-pxe:
	# TODO fix auto address detection in nixie
	sudo env "PATH=$$PATH" nixie \
		--installer path:.#nixosConfigurations.installer \
		--flake path:. \
		--hosts hosts/hosts.json \
		--install-ssh-key "${HOME}/.ssh/id_ed25519" \
		--deployment-ssh-key "${HOME}/.ssh/id_ed25519" \
		--address 192.168.1.28

clean:
	nix-collect-garbage --delete-old --log-format bar
