#!/bin/bash
AUTHOR="Mik_Mueller"

logo() {
    echo -e "\033[1;34m"
    echo " ___     _             _ _  _     _"
    echo "/ __| __| |_  ___  ___| | \| |___| |_ ___ ___"
    echo "\__ \/ _| ' \/ _ \/ _ \ | . / _ \  _/ -_|_--<"
    echo "|___/\__|_||_\___/\___/_|_|\_\___/\__\___/__/"
    echo -e "\033[0m"
}

init() {
    case "$1" in
        n | normal)
            cp -r /opt/schoolnotes/templates/normal/* ./|| { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            cp /opt/schoolnotes/templates/normal/.gitignore .
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mNotes.\033[0m"
        ;;
        c | complex)
            cp -r /opt/schoolnotes/templates/complex/* ./ || { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mComplex Work.\033[0m"
        ;;
        m | math)
            cp -r /opt/schoolnotes/templates/math/* ./ ||  { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            cp /opt/schoolnotes/templates/math/.gitignore .
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mMath.\033[0m"
        ;;
        i | it)
            cp -r /opt/schoolnotes/templates/it/* ./ ||  { echo -e "\033[1;31mTemplates folder ist not valid, initialising failed.\033[0m" && exit 1; }
            cp /opt/schoolnotes/templates/it/.gitignore .
            echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mIT.\033[0m"
        ;;
        *)
            echo -e "\033[1;31mPlease provide a valid template name when using init.\033[0m\nValid templates are:\n    n | normal\n    c | complex\n    m | math \n    i | it\033[0m"
            false
        ;;
    esac
}

clean() {
    rm -v -- *.aux 2> /dev/null
    rm -v -- *.out 2> /dev/null
    rm -v -- *.fdb_latexmk 2> /dev/null
    rm -v -- *.fls 2> /dev/null
    rm -v -- *.synctex.gz 2> /dev/null
    rm -v -- *.log 2> /dev/null
    rm -v -- *.lof 2> /dev/null
    rm -v -- *.bbl 2> /dev/null
    rm -v -- *.bcf 2> /dev/null
    rm -v -- *.script 2> /dev/null
    rm -v -- *.dat 2> /dev/null
    rm -v -- *.bak0 2> /dev/null
    rm -v -- *.bak1 2> /dev/null
    rm -v -- *.lol 2> /dev/null
    rm -v -- *.listing 2> /dev/null
    rm __latexindent_temp.tex 2> /dev/null
    
    rm -v -- **/*.aux 2> /dev/null
    rm -v -- **/*.out 2> /dev/null
    rm -v -- **/*.fdb_latexmk 2> /dev/null
    rm -v -- **/*.fls 2> /dev/null
    rm -v -- **/*.synctex.gz 2> /dev/null
    rm -v -- **/*.log 2> /dev/null
    rm -v -- **/*.lof 2> /dev/null
    rm -v -- **/*.bbl 2> /dev/null
    rm -v -- **/*.bcf 2> /dev/null
    rm -v -- **/*.script 2> /dev/null
    rm -v -- **/*.dat 2> /dev/null
    rm -v -- **/*.bak0 2> /dev/null
    rm -v -- **/*.bak1 2> /dev/null
    rm -v -- **/*.lol 2> /dev/null
    rm -v -- **/*.listing 2> /dev/null
    rm __latexindent_temp.tex 2> /dev/null
    echo -e "\033[1;34mCleaned LaTeX junk files in current directory.\033[0m"
}

build() {
    echo -e "\033[1;34mBuilding main.tex...\033[0m"
    if [ "$2" = "silent" ]; then
        lualatex  --halt-on-error "$1" > /dev/null || { echo -e "\033[1;31mBuilding of $1 failed.\033[0m" && exit 1; }
    else
        lualatex  --halt-on-error "$1" || { echo -e "\033[1;31mBuilding of $1 failed.\033[0m" && exit 1; }
    fi
    clean > /dev/null
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

watch() {
    # run every interval in seconds
    timeinterval=2;
    
    # Main files and folders
    maindir='./'
    main="$maindir/main.tex"
    content="$maindir/content.tex"
    chksum1=`find $content $main -type f -printf "%T@ %p\n" | md5sum | cut -d " " -f 1`;
    while [[ true ]]; do
        chksum2=`find $content $main -type f -printf "%T@ %p\n" | md5sum | cut -d " " -f 1`;
        if [[ $chksum1 != $chksum2 ]] ; then
            build 'main.tex' 'silent'
            echo -e "Waiting for changes ..."
            chksum1=$chksum2
            elif [ -f "main.aux" ]; then
            clean
        fi
        #echo "$chksum2 $chksum1";
        sleep $timeinterval;
    done
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
            -r | --rename)
                if [ -f "main.pdf" ]; then
                    mv main.pdf "$(basename "$(pwd)")_$AUTHOR".pdf
                else
                    echo -e "\033[1;33m'main.pdf' not found, running build before renaming.\033[0m"
                    build "main.tex" "silent"
                    mv main.pdf "$(basename "$(pwd)")_$AUTHOR".pdf
                fi
                clean
                echo -e "\033[1;32mSuccessfully renamed 'main.pdf' to\033[0m \033[1;35m$(basename "$(pwd)")_$AUTHOR.pdf\033[0m"
                shift
            ;;
            -e | --edit)
                echo -e "\033[1;34mEditing notes in current directory.\033[0m"
                code . 2> /dev/null || codium .
                shift
            ;;
            -u | --update)
                echo -e "\033[1;31mUpdating SchoolNotes will remove your templates.\033[0m"
                echo -e "If you want to keep them, backup your templates. You can find them in \033[1;34m/opt/schoolnotes/templates\033[0m."
                echo -e "\033[1;35mNote: Some updates of Schoolnotes involve changes to templates.\n-> Be aware that your old templates might not work in a newer version.\033[0m"
                while true; do
                    read -p  "Do you want to remove all templates and continue the update? [N/y]" yn
                    case $yn in
                        [Yy]* )
                            wget https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/install.sh
                            sudo bash install.sh r
                            sudo bash install.sh i
                            break
                        ;;
                        * )
                            echo -e "\033[1;34mUpdate canceled by user.\033[0m"
                        exit 1;;
                    esac
                done
                shift
            ;;
            -w | --watch)
                echo -e "\033[1;34mWatching for filechanges in current directory.\033[0m"
                watch
                shift
            ;;
            -n | --new)
                input=$2
                
                if [ -z "${input// /_}" ]; then
                    echo -e "\033[1;31mCreating a new project requires a project name.\033[0m"
                    exit 1
                fi
                
                if [ -z "$3" ]; then
                    echo -e "\033[1;31mCreating a new project requires a project template name.\033[0m"
                    exit 1
                fi
                
                if [ -f "${input// /_}" ]; then
                    echo -e "\033[1;31mIt seems like your directory already exists.\033[0m"
                    exit 1
                fi
                mkdir "${input// /_}" || exit 1
                cd "${input// /_}" || {  echo -e "\033[1;31mCreating ${input// /_} failed: Cd returned an error.\033[0m" && exit 1; }
                init "$3" || { cd ".." &&  rm -rf "${input// /_}" && echo -e "\033[1;31mCreating ${input// /_} failed: init returned an error.\n\033[1;34mAll changes were reverted.\033[0m" && exit 1; }
                # printf '\n\def\documenttitle{%s}' "$2" >> ./preamble/config.tex
                sed -i -E "s/Thema/$2/" ./preamble/config.tex
                build "main.tex" "silent"
                
                if [ -z "$4" ]; then
                    echo -e "\033[1;34mRunning in headless mode: Use \033[1;35m '-o' or '--open'\033[0m \033[1;34mto open the notebook after creation.\033[0m"
                else
                    case $4 in
                        -o | --open)
                            echo -e "\033[1;34mLaunching new notebook in VSCode.\033[0m"
                            code .
                        ;;
                        *)
                            echo -e "Expected -o | --open \n\033[1;31mUnknown option: $4.\033[0m"
                    esac
                fi
                
                echo -e "\033[1;32mSuccessfully created a new Schoolnotes project for\033[0m \033[1;35m$3.\033[0m"
                shift
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
    logo
fi
