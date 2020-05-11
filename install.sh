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

printf "INSTALLING tikztosvg(1):\n\n"

if [ -f $HOME/.local/bin/tikztosvg ]; then
    rm $HOME/.local/bin/tikztosvg
fi

wget https://raw.githubusercontent.com/GarkGarcia/tikztosvg/master/bin/tikztosvg -P $HOME/.local/bin/

if [ "$?" -ne "0" ]; then
    exit 1
fi

chmod +x $HOME/.local/bin/tikztosvg

man "tikztosvg" > /dev/null 2>&1
if [ "$?" -ne "0" ]; then
    tmp="$(mktemp -d)"
    printf "INSTALLING MANUAL ENTRY FOR tikztosvg(1):\n\n"
    wget https://raw.githubusercontent.com/GarkGarcia/tikztosvg/master/man/tikztosvg.1 -P "$tmp"
    install -g 0 -o 0 -m 0644 "$tmp/tikztosvg.1" $HOME/.local/share/man/man1/
    
    if [ "$?" -ne "0" ]; then
        exit 1
    fi

    if [ -f $HOME/.local/share/man/man1/tikztosvg.1.gz ]; then
        rm $HOME/.local/share/man/man1/tikztosvg.1.gz
    fi

        gzip $HOME/.local/share/man/man1/tikztosvg.1
    rm "$tmp" -r
    
    if [ "$?" -ne "0" ]; then
        exit 1
    fi
fi

