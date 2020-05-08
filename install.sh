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
    error "This script requires administrative permissions"
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

echo "INSTALLING tikzin(1):"

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
    echo ""
    echo "INSTALLING MANUAL ENTRY FOR tikzin(1):"
    wget https://raw.githubusercontent.com/GarkGarcia/tikzin/master/manpage/tikzin.1 -P "$tmp"
    install -g 0 -o 0 -m 0644 "$tmp/tikzin.1" /usr/local/man/man1/
    gzip /usr/local/man/man1/tikzin.1
    rm "$tmp" -r
    
    if [ "$?" -ne "0" ]; then
        exit 1
    fi
fi

