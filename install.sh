REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/

git clone --bare $REPO $GITDIR

function dotfiles {
    /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

if ! dotfiles checkout; then
    read -p "All of the above files will be deleted, are you sure? (y/N) " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        dotfiles checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I {} rm {}
        dotfiles checkout
        dotfiles config status.showUntrackedFiles no
        dotfiles push --set-upstream origin master
    else
        rm -rf $GITDIR
    fi
fi
