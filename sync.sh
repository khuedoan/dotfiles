BACKUPDIR=$HOME/.dotfiles/backup

git clone --bare https://github.com/khuedoan98/dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

echo "Checking out dotfiles..."
if ! dotfiles checkout; then
    echo "Found existing dotfiles, backing up...";
    mkdir -p $BACKUPDIR
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
    dotfiles checkout
fi;
echo "Checked out dotfiles.";

dotfiles config status.showUntrackedFiles no
