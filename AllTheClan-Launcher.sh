#!/bin/bash

# ======================================================================================================
# USER CONFIGURATION
# ======================================================================================================

MODPACK_NAME="AllTheClan"
MODPACK_URL="https://github.com/OOClan/AllTheClan/archive/data.zip"
CORNSTONE_VERSION_URL="https://raw.githubusercontent.com/OOClan/AllTheClan/data/.cornstone"

CORNSTONE_FILE="$PWD/$MODPACK_NAME-cornstone"
LAUNCHER_DIR="$PWD/$MODPACK_NAME-multimc"
SERVER_DIR="$PWD/$MODPACK_NAME-server"

# ======================================================================================================

function MENU {
    clear

    echo ""
    echo "..............................................."
    echo " $MODPACK_NAME Launcher"
    echo "..............................................."
    echo ""
    echo " 1 - Install or update"
    echo " 2 - Play"
    echo " 3 - Reset"
    echo " 4 - Install or update server"
    echo " 5 - Exit"
    echo ""
    read -p $'Type a number then press ENTER: ' CHOICE

    clear

    case $CHOICE in
        "1")
            INSTALL ;;
        "2")
            PLAY ;;
        "3")
            RESET ;;
        "4")
            SERVER ;;
        "5")
            EXIT ;;
        "9")
            DEV ;;
        *) ;;
    esac
}

function GET_CORNSTONE {
    echo "Downloading cornstone..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        CORNSTONE_OS="darwin"
    else
        CORNSTONE_OS="linux"
    fi
    CORNSTONE_VERSION=$(curl -sfL "${CORNSTONE_VERSION_URL}") || ERROR
    CORNSTONE_URL="https://github.com/MinecraftMachina/cornstone/releases/download/v${CORNSTONE_VERSION}/cornstone_${CORNSTONE_VERSION}_${CORNSTONE_OS}_amd64"
    curl -sfL "$CORNSTONE_URL" -o "$CORNSTONE_FILE" || ERROR
    chmod +x "$CORNSTONE_FILE" || ERROR
}

function INSTALL {
    GET_CORNSTONE || ERROR
    if [ ! -d "$LAUNCHER_DIR" ]; then
        "$CORNSTONE_FILE" multimc -m "$LAUNCHER_DIR" init || ERROR
    fi
    "$CORNSTONE_FILE" multimc -m "$LAUNCHER_DIR" install -n "$MODPACK_NAME" -i "$MODPACK_URL" || ERROR
    pause
}

function PLAY {
    "$CORNSTONE_FILE" multimc -m "$LAUNCHER_DIR" run || ERROR
    EXIT
}

function DEV {
    "$CORNSTONE_FILE" multimc -m "$LAUNCHER_DIR" dev || ERROR
    pause
}

function RESET {
    echo ""
    echo "WARNING: This will delete the modpack with all your data!"
    echo ""
    pause
    rm -rf "$LAUNCHER_DIR" || ERROR
    INSTALL
}

function SERVER {
    GET_CORNSTONE || ERROR
    "$CORNSTONE_FILE" server -s "$SERVER_DIR" install -i "$MODPACK_URL" || ERROR
    pause
}

function EXIT {
    exit 1
}

function ERROR {
    echo "Failed with error $?"
    pause
    EXIT
}

function pause {
    read -n1 -r -p "Press any key to continue..." key
}

while true
do
    MENU
done
