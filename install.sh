REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/
BACKUPDIR=$HOME/.dotfiles_backup/

git clone --bare $REPO $GITDIR

function dotfiles {
   /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

echo "Checking out dotfiles..."
if ! dotfiles checkout; then
    echo "Found existing dotfiles, backing up...";
    mkdir -p $BACKUPDIR
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $BACKUPDIR{}
    dotfiles checkout
fi;
echo "Checked out dotfiles.";

dotfiles config status.showUntrackedFiles no
