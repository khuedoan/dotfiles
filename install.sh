#!/bin/dash

REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/

git clone --bare $REPO $GITDIR

dotfiles() {
    /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

if ! dotfiles checkout; then
    echo -n "All of the above files will be deleted, are you sure? (y/N) "
    read response
    if [ $response = "y" ]; then
            dotfiles checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I {} rm -v {}
            dotfiles checkout &&
            dotfiles config status.showUntrackedFiles no &&
            dotfiles push --set-upstream origin master &&
            echo "Install completed!"
    else
            rm -rf $GITDIR
            echo "Installation cancelled"
    fi
fi
