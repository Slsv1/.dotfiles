all: dev games

core:
	sudo apt update
	sudo apt install flatpak

dev: core dev_packages dev_symlinks dev_cpp
.PHONY = dev

dev_symlinks: core dev_packages
	mkdir $(HOME)/.config
	ln -sfv $(HOME)/.dotfiles/nvim $(HOME)/.config/nvim
	ln -sfv $(HOME)/.dotfiles/kitty $(HOME)/.config/kitty
	ln -sfv $(HOME)/.dotfiles/.tmux.conf $(HOME)/.tmux.conf
	ln -sfv $(HOME)/.dotfiles/.gitconfig $(HOME)/.gitconfig
	ln -sfv $(HOME)/.dotfiles/.bashrc $(HOME)/.bashrc
.PHONY = dev_symlinks

dev_packages: core
	sudo apt install tmux tree htop kitty tldr
	flatpak install flathub org.mozilla.firefox
.PHONY = dev_packages

dev_cpp: core
	sudo apt install cmake build-essential libsdl3-dev libsdl3-image-dev libsdl3-ttf-dev
.PHONY = dev_cpp


games: core
	flatpak install flathub io.mrarm.mcpelauncher
.PHONY = games
