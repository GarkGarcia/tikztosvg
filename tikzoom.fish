function tikzoom -a argv
    function puts -a prompt msg color
        set_color $color --bold
        printf "[%s]" $prompt
        
        set_color normal
        printf " %s\n" $msg
    end
    
    function error -a msg code
        puts "ERROR" "$msg" red

        switch "$code"
            case 0 ""
                exit 1

            case *
                exit $code
        end
    end

    function message -a msg
        puts "TIKZOOM" "$msg" green
    end

    function create_latex -a input output packages
        echo "\documentclass[crop,tikz,multi=false]{standalone}" > $output
        
        for package in $packages
            echo "\usepackage{$package}" >> $output
        end
        
        echo "\begin{document}" >> $output
        echo "\huge" >> $output
        
        cat $input >> $output
        echo "\end{document}" >> $output
    end

    if test -z ""(command -s xelatex)
        error "xelatex could not be found"
    end

    if test -z ""(command -s pdf2svg)
        error "pdf2svg could not be found"
    end

    argparse -i h/help q/quiet o/output= p/package=+ -- $argv
    
    if test -n "$_flag_help"
        man tikzoom
    end
    
    switch (count $argv)
        case 0
            error "No input path provided"
        case 1
            set input $argv[1]
        case *
            error "Too many arguments: \""$argv[1..-1]"\""
    end

    if test -z "$_flag_output"
        set output (echo (basename $input) | cut  -d "." -f1)".svg"
    else
        set output "$_flag_output"
    end
    
    set temp_dir (mktemp -d)
    
    create_latex $input "$temp_dir/tmp.tex" $_flag_package

    if test -z "$_flag_quiet"
        message "Rendering the LaTeX document. . ."
        xelatex -output-directory=$temp_dir "$temp_dir/tmp.tex"
    else
        xelatex -halt-on-error -output-directory=$temp_dir "$temp_dir/tmp.tex" 1> /dev/null 2>1
    end

    set s $status
    if test $s -ne 0
        rm $temp_dir -r
        error "xelatex exited with code $s" $s
    end
    
    if test -z "$_flag_quiet"
        message "Converting the output to SVG. . ."
    end
    
    pdf2svg "$temp_dir/tmp.pdf" $output 1
    
    set s $status
    if test $s -ne 0
        rm $temp_dir -r
        error "pdf2svg exited with code $s" $s
    end
    
    if test -z "$_flag_quiet"
        message "Done!"
    end
    
    rm $temp_dir -r
end

