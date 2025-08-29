SHELL := /bin/bash

BREWFILE := $(HOME)/.dotfiles/dot-Brewfile

.PHONY: setup bundle help

help: ## Show this help
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'
	@echo ""

setup: ## Install Homebrew (if missing) and apply Brewfile
	@echo ">>>>> Installing Homebrew (if missing)"
	@command -v brew >/dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" </dev/null
	@echo ">>>>> Applying Brewfile"
	@brew bundle --file="$(BREWFILE)"

stow: ## Restore files with GNU stow
	@stow --dotfiles .

bundle: ## Dump current global Brewfile (overwrite, with descriptions)
	@brew bundle dump --global --force --describe

