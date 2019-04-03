REPO="https://github.com/khuedoan98/dotfiles.git"
GITDIR=$HOME/.dotfiles/
BACKUPDIR=$HOME/.dotfiles_backup/

git clone --bare $REPO $GITDIR

function dotfiles {
   /usr/bin/git --git-dir=$GITDIR --work-tree=$HOME $@
}

dotfiles config status.showUntrackedFiles no

if ! dotfiles checkout; then
    rm -rf $GITDIR
    echo "Please backup or remove the above files and run the script again"
fi
