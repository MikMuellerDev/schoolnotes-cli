#!/bin/bash

init() {
    case "$1" in
        n | normal)
            cp -r /opt/schoolnotes/.templates/normal/* ./|| { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mNotes.\033[0m"
        ;;
        c | complex)
            cp -r /opt/schoolnotes/.templates/complex/* ./ || { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mComplex Work.\033[0m"
        ;;
        m | math)
            cp -r /opt/schoolnotes/.templates/math/* ./ ||  { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mMath.\033[0m"
        ;;
        *)
            echo -e "\033[1;31mPlease provide a valid template name when using init.\nValid templates are:\n    n | normal\n    c | complex\n    m | math\033[0m"
            exit 1
        ;;
    esac
}

clean() {
    rm -v -- *.aux 2> /dev/null
    rm -v -- *.fdb_latexmk 2> /dev/null
    rm -v -- *.fls 2> /dev/null
    rm -rvf -- *.out 2> /dev/null
    rm -v -- *.synctex.gz 2> /dev/null
    rm -v -- *.log 2> /dev/null
    rm -v -- *.lof 2> /dev/null
    rm -v -- *.bbl 2> /dev/null
    rm -v -- *.bcf 2> /dev/null
    rm -v -- *.script 2> /dev/null
    rm -v -- *.dat 2> /dev/null
    rm __latexindent_temp.tex 2> /dev/null
    echo -e "\033[1;34mCleaned LaTeX junk files in current directory.\033[0m"
}

build() {
    echo -e "\033[1;34mBuilding main.tex...\033[0m"
    mkdir out
    if [ "$2" = "silent" ]; then
        lualatex  --halt-on-error --output-directory=out "$1" > /dev/null || { echo -e "\033[1;31mBuilding of $1 failed.\033[0m" && exit 1; }
    else
        lualatex  --halt-on-error --output-directory=out "$1" || { echo -e "\033[1;31mBuilding of $1 failed.\033[0m" && exit 1; }
    fi
    mv out/*.pdf ./ -f  || { echo -e "\033[1;31mBuild failed: Transfering PDF failed.\033[0m" && exit 1; }
    rm -rf out
    echo -e "\033[1;32mBuilding of $1 finished.\033[0m"
}


view() {
    echo -e "\033[1;34mViewing file in current directory.\033[0m"
    if [ -f "main.pdf" ]; then
        okular main.pdf > /dev/null &
    else
        echo -e "\033[1;31mFile not found error: Default file 'main.pdf' does not exist.\033[0m"
    fi
}

if [ -n "$1" ]; then
    while test $# -gt 0; do
        case $1 in
            -i | --init)
                if [ -n "$2" ]; then
                    if [ -n "$(ls -A .)" ]; then
                        echo -e "\033[1;31mDirectory is not empty, aborting.\033[0m"
                        exit 1
                    fi
                else
                    echo -e "\033[1;31mInitialising a new project requires a template name.\033[0m"
                    exit 1
                fi
                init "$2"
                shift
                shift
            ;;
            
            -c | --clean)
                clean
                shift
            ;;
            
            -b | --build | --compile)
                if [ -f "main.tex" ]; then
                    build "main.tex"
                else
                    echo -e "\033[1;31mInput file not found while trying to use default file 'main.tex'.\033[0m"
                    exit 1
                fi
                shift
            ;;
            -v | --view)
                view
                shift
            ;;
            -r | --run)
            build "main.tex" "silent"
            view
            shift
            ;;
            -e | --edit)
                echo -e "\033[1;34mEditing notes in current directory.\033[0m"
                code .
                shift
            ;;
            -n | --new)
                if [ -z "$2" ]; then
                    echo -e "\033[1;31mCreating a new project requires a project name.\033[0m"
                    exit 1
                fi
                
                if [ -z "$3" ]; then
                    echo -e "\033[1;31mCreating a new project requires a project template name.\033[0m"
                    exit 1
                fi
                
                if [ -f "$2" ]; then
                    echo -e "\033[1;31mIt seems like your directory already exists.\033[0m"
                    exit 1
                fi
                mkdir "$2"
                cd "$2" || {  echo -e "\033[1;31mCreating $2 failed: Cd returned an error.\033[0m" && exit 1; }
                init "$3" > /dev/null
                build "main.tex" "silent"
                # cd ..
                echo -e "\033[1;32mSuccessfully created a new Schoolnotes project for\033[0m \033[1;35m$3.\033[0m"
                shift
                shift
                shift
            ;;
            *)
                echo -e "\033[1;31mUnknown option: $1.\033[0m"
                exit 1
            ;;
        esac
    done
else
    echo -e "\033[1;34mLaunching Schoolnotes in VSCode.\033[0m"
    code "$HOME/SchoolNotes"
    echo -e "\033[1;34m"
    echo "___     _             _ _  _     _"
    echo "/ __| __| |_  ___  ___| | \| |___| |_ ___ ___"
    echo "\__ \/ _| ' \/ _ \/ _ \ | . / _ \  _/ -_|_--<"
    echo "|___/\__|_||_\___/\___/_|_|\_\___/\__\___/__/"
    echo -e "\033[0m"
fi