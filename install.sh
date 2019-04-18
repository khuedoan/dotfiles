REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/
BACKUPDIR=$HOME/.dotfilesbackup/

git clone --bare $REPO $GITDIR

function dotfiles {
    /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

function mvp ()
{
    dir="$2"
    tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -a "$dir" ] ||
    mkdir -p "$dir" &&
    mv "$@"
}

if ! dotfiles checkout; then
    dotfiles checkout 2>&1 | egrep "\s+" | awk {'print $1'} | xargs -I{} mvp {} $BACKUPDIR{}
    dotfiles checkout
fi

dotfiles config status.showUntrackedFiles no
