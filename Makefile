all: dev_symlinks
.PHONY = all

dev_symlinks:
	mkdir -p $(HOME)/.config
	ln -sfv $(HOME)/.dotfiles/nvim $(HOME)/.config/nvim
	ln -sfv $(HOME)/.dotfiles/kitty $(HOME)/.config/kitty
	ln -sfv $(HOME)/.dotfiles/.tmux.conf $(HOME)/.tmux.conf
	ln -sfv $(HOME)/.dotfiles/.gitconfig $(HOME)/.gitconfig
	ln -sfv $(HOME)/.dotfiles/.bashrc $(HOME)/.bashrc
.PHONY = dev_symlinks

