# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load php-version
if [[ -s "$(brew --prefix php-version)" ]]; then
    export PHP_VERSIONS="/usr/bin/php"
    source "$(brew --prefix php-version)/php-version.sh"
    # php-version 5
fi
