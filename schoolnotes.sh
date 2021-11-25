#!/bin/bash

if [ -n "$1" ]; then
    case $1 in
        -i | --init)
            if [ -n "$2" ]; then
                if [ -f "main.tex" ]; then
                    echo -e "\033[1;31mmain.tex exists, aborting.\033[0m"
                    exit 1
                    elif [ -f "content.tex" ]; then
                    echo -e "\033[1;31mcontent.tex exists, aborting.\033[0m"
                    exit 1
                fi
                case $2 in
                    -n | --normal)
                        cp -r /opt/schoolnotes/.templates/normal/* ./
                        echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mNotes.\033[0m"
                    ;;
                    -c | --complex)
                        cp -r /opt/schoolnotes/.templates/complex/* ./
                        echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mComplex Work.\033[0m"
                    ;;
                    -m | --math)
                        cp -r /opt/schoolnotes/.templates/math/* ./
                        echo -e "\033[1;32mSuccessfully initialised new Schoolnotes template for\033[0m \033[1;35mMath.\033[0m"
                    ;;
                    *)
                        echo -e "\033[1;31mPlease include a valid mode when using init.\nValid modes are:\n     -n | --normal\033[0m"
                        exit 1
                    ;;
                esac
            else
                echo -e "\033[1;31mNo arguments were provided but --init requires 1.\033[0m"
                exit 1
            fi
        ;;
        
        -c | --clean)
            echo -e "\033[1;34mCleaning LaTeX junk files in current directory.\033[0m"
            rm *.aux
            rm *.fdb_latexmk
            rm *.fls
            rm -rf *.out
            rm *.synctex.gz
            rm *.log
            rm *.lof
            rm *.bbl
            rm *.bcf
            rm *.script
            rm *.dat
            rm __latexindent_temp.tex
        ;;
        
        -b | --build | --compile)
            if [ -f "main.tex" ]; then
                echo -e "\033[1;34mBuilding main.tex.\033[0m"
                mkdir out
                lualatex --output-directory=out main.tex
                mv out/main.pdf ./ -f
                echo -e "\033[1;32mBuilding of main.tex finished.\033[0m"
            else
                echo -e "\033[1;31mNo main.tex file found. Building requires a main.tex file.\033[0m"
                exit 1
            fi
        ;;
        -v | --view)
            if [ -f "main.pdf" ]; then
                echo -e "\033[1;34mViewing main.pdf in current directory.\033[0m"
                okular main.pdf
            else
                echo -e "\033[1;31mNo main.pdf file found. Viewing requires a main.pdf file.\033[0m"
                exit 1
            fi
        ;;
        -e | --edit)
            echo -e "\033[1;34mEditing notes in current directory.\033[0m"
            code .
        ;;
        *)
            echo -e "\033[1;31mUnknown option: $1.\033[0m"
            exit 1
        ;;
    esac
else
    echo -e "\033[1;34mLaunching Schoolnotes in VsCode.\033[0m"
    code "$HOME/SchoolNotes"
    echo -e "\033[1;34m"
    echo "___     _             _ _  _     _"
    echo "/ __| __| |_  ___  ___| | \| |___| |_ ___ ___"
    echo "\__ \/ _| ' \/ _ \/ _ \ | . / _ \  _/ -_|_--<"
    echo "|___/\__|_||_\___/\___/_|_|\_\___/\__\___/__/"
    echo -e "\033[0m"
fi