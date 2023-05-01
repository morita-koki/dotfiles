#!/bin/bash -e

# make symbolic link of dotfiles
for f in .??*; do 
	[[ "$f" = ".git" ]] && continue
	[[ "$f" = ".gitignore" ]] && continue
	[ -e ~/"$f" ] && rm -f ~/"$f".bak && mv ~/"$f" ~/"$f".bak
	ln -s "${PWD}"/"$f" ~/
	echo "Made symlink of $f"
done

# make sumbolic link of vim setting files
[ ! -e ~/local/bin ] && mkdir -p ~/local/bin
[ -e ~/.vim ] && rm -rf ~/.vim.bak && mv ~/.vim ~/.vim.bak
[ -e ~/.config/nvim ] && rm -rf ~/config/nvim.bak && mv ~/.config/nvim ~/.config/nvim.bak
[ ! -e ~/.vim/rc ] && mkdir -p ~/.vim/rc
[ ! -e ~/.config ] && mkdir -p ~/.config
ln -s "${PWD}"/vim/dein.toml ~/.vim/rc
ln -s "${PWD}"/vim/dein_lazy.toml ~/.vim/rc
ln -s "${PWD}"/vim/coc-settings.json ~/.vim
ln -s "${PWD}"/vim/UltiSnips ~/.vim
ln -s ~/.vim ~/.config/nvim
ln -s ~/.vimrc ~/.config/nvim/init.vim
echo "Made Symlink of zsh related files."

# copy cool zsh theme 
[ -e ~/.zsh/themes/bullet-train.zsh-theme ] && \
	rm -f ~/.zsh/themes/bullet-train.zsh-theme.bak && \
	mv ~/.zsh/themes/bullet-train.zsh-theme ~/.zsh/themes/bullet-train.zsh-theme.bak
[ ! -e ~/.zsh/themes ] && mkdir -p ~/.zsh/themes
ln -s "$PWD"/themes/bullet-train.zsh-theme ~/.zsh/themes
echo "Made symlink of zsh theme file."

# make symlink to bin
[ ! -e ~/local/bin ] && mkdir ~/local/bin
for bin in "${PWD}"/bin/* ;do
    ln -s "${bin}" ~/local/bin/
done


echo "Sucessfully setup dotfiles."
echo "Next, please run install.sh to install essential tools."









