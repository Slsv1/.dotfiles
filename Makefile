all: dev games audio common
.PHONY = all

core:
	sudo apt update
	sudo apt install flatpak gcc npm
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
.PHONY = core

dev: core dev_packages dev_symlinks dev_cpp
.PHONY = dev

dev_symlinks: dev_packages
	mkdir -p $(HOME)/.config
	ln -sfv $(HOME)/.dotfiles/nvim $(HOME)/.config/nvim
	ln -sfv $(HOME)/.dotfiles/kitty $(HOME)/.config/kitty
	ln -sfv $(HOME)/.dotfiles/.tmux.conf $(HOME)/.tmux.conf
	ln -sfv $(HOME)/.dotfiles/.gitconfig $(HOME)/.gitconfig
	ln -sfv $(HOME)/.dotfiles/.bashrc $(HOME)/.bashrc
.PHONY = dev_symlinks

dev_packages: core
	sudo apt install tmux tree htop kitty tldr
.PHONY = dev_packages

dev_cpp: core
	sudo apt install cmake build-essential libsdl3-dev libsdl3-image-dev libsdl3-ttf-dev
.PHONY = dev_cpp

audio: core
	sudo apt install qpwgraph pipewire-jack pipewire-pulse
.PHONY = audio

games: core
	flatpak install flathub io.mrarm.mcpelauncher
.PHONY = games

common: core
	flatpak install flathub org.mozilla.firefox
.PHONY = common
