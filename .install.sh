#!/bin/sh

install_dotfiles() {
    REPO="https://github.com/khuedoan98/dotfiles.git"
    GITDIR=$HOME/.dotfiles/

    git clone --single-branch --branch cli --bare $REPO $GITDIR

    dotfiles() {
        /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
    }

    if ! dotfiles checkout; then
        echo "All of the above files will be deleted, are you sure? (y/N) "
        read -r response
        if [ "$response" = "y" ]; then
            dotfiles checkout 2>&1 | grep -E "^\s+" | sed -e 's/^[ \t]*//' | xargs -d "\n" -I {} rm -v {}
            dotfiles checkout
            dotfiles config status.showUntrackedFiles no
        else
            rm -rf $GITDIR
            echo "Installation cancelled"
            exit 1
        fi
    else
        dotfiles config status.showUntrackedFiles no
    fi
}
