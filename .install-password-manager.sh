#!/bin/sh

# exit immediately if 1Password CLI (op) is already in $PATH
type op >/dev/null 2>&1 && exit

case "$(uname -s)" in
Darwin)
    # Install op on macOS using Homebrew
    if command -v brew >/dev/null 2>&1; then
        brew install 1password-cli
    else
        echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
        exit 1
    fi
    ;;
Linux)
    # Check for Debian/Ubuntu
    if [ -f /etc/debian_version ]; then
        # Install op on Debian/Ubuntu using 1Password's official repo
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
            gpg --dearmor | sudo tee /usr/share/keyrings/1password-archive-keyring.gpg >/dev/null

        echo "deb [signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] \
https://downloads.1password.com/linux/debian/amd64 stable main" | \
            sudo tee /etc/apt/sources.list.d/1password.list

        sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
        curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
            sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol >/dev/null

        sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
        curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
            gpg --dearmor | sudo tee /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg >/dev/null

        sudo apt update && sudo apt install -y 1password-cli
    else
        echo "Unsupported Linux distribution (only Debian/Ubuntu are supported)."
        exit 1
    fi
    ;;
*)
    echo "Unsupported OS"
    exit 1
    ;;
esac

