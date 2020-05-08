error ()
{
    echo "ERROR: $1"
    exit 1
}

dependecyError () 
{
    echo "ERROR: The command '$1' could not be found."
    echo "Please make sure it is included in the \$PATH enviroment variable or follow the installation instructions on $2."
    exit 1
}

if [ "$(id -u)" -ne "0" ]; then
    error "This script requires administrator-privileges"
fi

if [ -z "$(which fish)" ]; then
    dependencyError "fish" "https://fishshell.com/"
fi

if [ -z "$(which xelatex)" ]; then
    dependencyError "xelatex" "https://tug.org/texlive/"
fi

if [ -z "$(which pdf2svg)" ]; then
    dependencyError "pdf2svg" "https://github.com/dawbarton/pdf2svg"
fi

printf "INSTALLING tikzin(1):\n\n"

if [ -f $HOME/.local/bin/tikzin ]; then
    rm $HOME/.local/bin/tikzin
fi

wget https://raw.githubusercontent.com/GarkGarcia/tikzin/master/tikzin -P $HOME/.local/bin/

if [ "$?" -ne "0" ]; then
    exit 1
fi

chmod +x $HOME/.local/bin/tikzin

man "tikzin" > /dev/null 2>&1
if [ "$?" -ne "0" ]; then
    tmp="$(mktemp -d)"
    printf "INSTALLING MANUAL ENTRY FOR tikzin(1):\n\n"
    wget https://raw.githubusercontent.com/GarkGarcia/tikzin/master/manpage/tikzin.1 -P "$tmp"
    install -g 0 -o 0 -m 0644 "$tmp/tikzin.1" $HOME/.local/share/man/man1/
    
    if [ "$?" -ne "0" ]; then
        exit 1
    fi

    if [ -f $HOME/.local/share/man/man1/tikzin.1.gz ]; then
        rm $HOME/.local/share/man/man1/tikzin.1.gz
    fi

    gzip $HOME/.local/share/man/man1/tikzin.1
    rm "$tmp" -r
    
    if [ "$?" -ne "0" ]; then
        exit 1
    fi
fi

