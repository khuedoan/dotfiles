REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/
BACKUPDIR=$HOME/.dotfiles_backup/

git clone --bare $REPO $GITDIR

function dotfiles {
   /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

function mv () {
    dir="$2"
    tmp="$2"; tmp="${tmp: -1}"
    [ "$tmp" != "/" ] && dir="$(dirname "$2")"
    [ -a "$dir" ] ||
    mkdir -p "$dir" &&
    mv "$@"
}

echo "Checking out dotfiles..."
if ! dotfiles checkout; then
    echo "Found existing dotfiles, backing up...";
    mkdir -p $BACKUPDIR
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv -p {} $BACKUPDIR{}
    dotfiles checkout
    echo "Checked out dotfiles.";
else
    echo "Checked out dotfiles.";
fi;

dotfiles config status.showUntrackedFiles no
