#!/bin/sh

puts ()
{
    printf "\033[1m\033[38;5;%sm[%s]\033[m %s\n\n" "$3" "$1" "$2"
}

error ()
{
    puts ERROR "$1" 9
    exit 1
}

dependencyWarning () 
{
    puts WARNING "$(printf "The command '%s' could not be found.\nPlease make sure it is included in the \$PATH enviroment variable or follow the installation instructions on %s." "$1" "$2")" 3
}

message ()
{
    puts INSTALLER "$1" 2
}

if [ "$(id -u)" -ne "0" ]
then
    error "This script requires administrator-privileges"
fi

if ! [ -x "$(command -v xelatex)" ]
then
    dependencyWarning "xelatex" "https://tug.org/texlive/"
fi

if ! [ -x "$(command -v pdf2svg)" ]
then
    dependencyWarning "pdf2svg" "https://github.com/dawbarton/pdf2svg"
fi

message "Installing tikztosvg(1)"

if [ -f "$HOME/.local/bin/tikztosvg" ]
then
    rm "$HOME/.local/bin/tikztosvg"
fi

wget https://raw.githubusercontent.com/GarkGarcia/tikztosvg/master/tikztosvg -P "$HOME/.local/bin/"\
    && chmod +x "$HOME/.local/bin/tikztosvg"\
    || exit 1

tmp="$(mktemp -d)"
message "Installing manual entry for tikztosvg(1)"
wget https://raw.githubusercontent.com/GarkGarcia/tikztosvg/master/man/tikztosvg.1 -P "$tmp"\
    && install -g 0 -o 0 -m 0644 "$tmp/tikztosvg.1" "$HOME/.local/share/man/man1/"\
    || exit 1

if [ -f "$HOME/.local/share/man/man1/tikztosvg.1.gz" ]
then
    rm "$HOME/.local/share/man/man1/tikztosvg.1.gz"
fi

gzip "$HOME/.local/share/man/man1/tikztosvg.1"
rm "$tmp" -r

