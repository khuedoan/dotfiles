REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/

git clone --bare $REPO $GITDIR

function dotfiles {
    /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

if ! dotfiles checkout; then
    dotfiles checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs -I {} rm {}
    dotfiles checkout
fi

dotfiles config status.showUntrackedFiles no
