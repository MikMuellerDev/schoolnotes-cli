#!/bin/bash
if [ "$EUID" -ne 0 ]
then echo -e "\033[1;31mPlease run this script as root.\033[0m"
    exit
fi

logo() {
    echo -e "\033[1;34m"
    echo " ___     _             _ _  _     _"
    sleep 0.1s
    echo "/ __| __| |_  ___  ___| | \| |___| |_ ___ ___"
    sleep 0.1s
    echo "\__ \/ _| ' \/ _ \/ _ \ | . / _ \  _/ -_|_--<"
    sleep 0.1s
    echo "|___/\__|_||_\___/\___/_|_|\_\___/\__\___/__/"
    echo -e "\033[0m"
    sleep 0.1s
}

install() {
    cd /opt || { echo -e "\033[1;31mCould not access /opt directory. (Maybe check permissions?)\033[0m" && exit 1; }
    if [ -d "schoolnotes" ]; then
        which schoolnotes || { uninstall && install && exit 0; }
        echo -e "\033[1;35mSchoolnotes folder already present, upgrading CLI.\033[0m"
        cd schoolnotes || exit 1
        wget 'https://raw.githubusercontent.com/MikMuellerDev/schoolnotes-cli/main/schoolnotes.sh' || { echo -e "\033[1;31mError during fetching of newer schoolnotes-CLI.\033[0m" && exit 1; }
        cp schoolnotes.sh "$(which schoolnotes)" || exit 1
        echo -e "\033[1;32mSuccessfully updated\033[0m \033[1;35mSchoolnotes-CLI.\033[0m"
        exit 0
        elif [ -d "schoolnotes-cli" ]; then
        echo -e "\033[1;31mThe previous schoolnotes installer seems to have failed, cleaning up.\033[0m"
        rm -rf schoolnotes-cli || exit 42
    else
        git clone 'https://github.com/MikMuellerDev/schoolnotes-cli' || {
            mv schoolnotes-cli schoolnotes-cli-old || { echo -e "\033[1;31mThere is already a schoolnotes-cli-old folder.\033[0m" && exit 1; }
            install
        }
        mv schoolnotes-cli schoolnotes || exit 1
        cd schoolnotes || exit 1
        mv schoolnotes.sh /bin/schoolnotes || exit 1
        echo -e "\033[1;32mSuccessfully installed\033[0m \033[1;35mSchoolnotes-CLI.\033[0m"
    fi
}

uninstall() {
    cd /opt || { echo -e "\033[1;31mCould not access /opt directory. (Maybe check permissions?)\033[0m" && exit 1; }
    rm -rf schoolnotes || { echo -e "\033[1;31mSchoolnotes-CLI is not installed on this system.\033[0m" && exit 1; }
    rm "$(which schoolnotes)" || { echo -e "\033[1;31mSchoolnotes-CLI is not installed on this systems /bin path.\033[0m Proceeding anyways."; }
    echo -e "\033[1;32mSuccessfully uninstalled\033[0m \033[1;35mSchoolnotes-CLI.\033[0m"
}

logo
case "$1" in
    i | install)
        install
    ;;
    r | remove)
        uninstall
    ;;
    *)
        echo -e "\033[1;31mInvalid argument: valid arguments are <i | install> and <r | remove>.\033[0m"
        exit 1
    ;;
esac