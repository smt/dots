#!/usr/bin/env bash

# Get path to script folder
DIR="$( cd "$( dirname "$0" )" && pwd )"
# Fix path in case of symlinks
DIR=$(cd "$DIR" && pwd -P)

# Check for .dots file and add symlink
dotfiles="$HOME/.dots"
if [ -L $dotfiles ]; then
    echo "Removing existing dotfiles symlink."
    rm $dotfiles
fi
if [ -d $dotfiles ]; then
    echo "Keeping existing $dotfiles folder."
else
    echo "Linking $DIR => $dotfiles"
    ln -s "$DIR" "$dotfiles"
fi

# Recursively map dotfiles/dotdirs to home directory
echo "Installing individual dotfiles..."
while IFS= read -d $'\0' -r file ; do
    b=$(basename $file)
    c="$HOME/$b"
    d="$file"
    if [ -L $c ]; then
        rm $c
    fi
    if [ -f $c -o -d $c ]; then
        echo -e "Kept existing:\t$d"
    else
        ln -s "$d" "$c"
        echo -e "Link created:\t$d"
    fi
done < <(find "$DIR" \( -type f -or -type d \) \( -path "$DIR/*/.vim" -prune -o -path "$DIR/.git" -prune -o -path "$DIR/*/.git" -prune \) -o \( -iname ".*" ! -iname ".gitignore" ! -iname ".gitmodules" ! -iname "*.swp" \) -print0)

# Throw in a localrc if needed
if [ ! -e $HOME/.localrc ]; then
    echo -e "# This is your own .localrc file for your SUPER SECRET STUFF" > $HOME/.localrc
fi

# SPF13
echo "Installing spf13-vim!"
source $DIR/.spf13-vim-3/bootstrap.sh

# OH-MY-ZSH
echo "Installing oh-my-zsh!"
source $DIR/.oh-my-zsh/tools/install.sh
