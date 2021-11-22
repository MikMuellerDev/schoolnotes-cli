#!/bin/bash

echo "$1"

if [ -n "$1" ]; then
    case $1 in 
        -i | --init)
        echo "case <init>"
        if [ -n "$2" ]; then
        echo "init is valid"
        if [[ "$2" == "-n" || "$2" == "--normal" ]]; then
            echo "initialising normal"
        fi
        fi
        ;;

        -c | --clear)
        echo  "case <clear>"
        ;;

        -b | --build | --compile)
        echo "case <compile>"
        ;;
    esac
fi