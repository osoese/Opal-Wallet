#!/bin/bash

setup_packages(){
    echo
    echo "-------------------------------------------------------------------"
    echo "Setup required packages"
    echo "-------------------------------------------------------------------"
    echo
    sudo apt-get update
    sudo apt-get -y install git curl nodejs-legacy npm build-essential
    if [ $? != 0 ]; 
    then
        echo "Problems with apt-get." && exit
    fi
}

get_opal() {
    echo
    echo "-------------------------------------------------------------------"
    echo "Download Opal-Alpha-0.0.1"
    echo "-------------------------------------------------------------------"
    echo

    cd ${HOME}

    if [ -d ./Opal-Alpha-0.0.1 ]; then
	    echo "     Removing previous Opal-Alpha-0.0.1 folder"
	    sleep 5  # Waits 5 seconds.
        rm -rf Opal-Alpha-0.0.1 >/dev/null 2>&1
    fi

    git clone https://github.com/TeamEGEM/Opal-Alpha-0.0.1.git
    if [ $? != 0 ]; 
    then
        echo "Problems with cloning the Opal-Alpha-0.0.1 project." && exit
    fi
}

execute_meteor() {
    cd ${HOME}/Opal-Alpha-0.0.1

    if [ -d ./.meteor ]; then
	    echo "     Removing previous .meteor folder"
	    sleep 5  # Waits 5 seconds.
        rm -rf .meteor >/dev/null 2>&1
    fi

    echo
    echo "-------------------------------------------------------------------"
    echo "Install meteor"
    echo "-------------------------------------------------------------------"
    echo
    sudo curl https://install.meteor.com/ | sh
    meteor update --patch

    #
    # Edit body.js file and change jsPDF for jspdf
    #
    sed -i -e 's/jsPDF/jspdf/g' ./imports/ui/body.js

    meteor npm install @babel/runtime@latest
    meteor npm install --save jspdf
    meteor npm install --save-exact @babel/runtime@7.0.0-beta.55
    meteor create .
    meteor add http
    meteor update

    meteor
}

setup_packages

get_opal

execute_meteor
