#!/bin/bash -e

PYTHON3_VERSION=3.8.10

# check and install dependencies
if [ -e /etc/lsb-release ];then
    required_packages="build-essential libssl-dev zlib1g-dev libbz2-dev
        libreadline-dev libsqlite3-dev llvm libncurses5-dev libncursesw5-dev
        xz-utils tk-dev liblzma-dev python-openssl lua5.2 liblua5.2-dev luajit libevent-dev
        make git zsh wget curl xclip xsel gawk fd-find ripgrep nkf jq"
    install_packages=""
    installed_packages=$(COLUMNS=200 dpkg -l | awk '{print $2}' | sed -e "s/\:.*$//g")
    for package in ${required_packages}; do
        echo -n "check ${package}..."
        # shellcheck disable=SC2086
        if echo "${installed_packages}" | grep -xq ${package}; then
            echo "OK."
        else
            echo "Not installed."
            install_packages="${install_packages} ${package}"
        fi
    done
    if [ -n "${install_packages}" ]; then
        echo "following packages will be installed: ${install_packages}"
        sudo apt update -y
        # shellcheck disable=SC2086
        sudo apt install -y ${install_packages}
    fi
elif [ -e /etc/redhat-release ]; then
    required_packages="gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel
        openssl-devel xz xz-devel findutils lua-devel luajit-devel ncurses-devel perl-ExtUtils-Embed
        ncurses-devel libevent-devel make git zsh wget curl xclip xsel"
    install_packages=""
    installed_packages=$(yum list installed | awk '{print $1}' | sed -e "s/\..*$//g")
    for package in ${required_packages}; do
        echo -n "check ${package}..."
        # shellcheck disable=SC2086
        if echo "${installed_packages}" | grep -xq ${package}; then
            echo "OK."
        else
            echo "Not installed."
            install_packages="${install_packages} ${package}"
        fi
    done
    if [ -n "${install_packages}" ]; then
        echo "following packages will be installed: ${install_packages}"
        # shellcheck disable=SC2086
        sudo yum install -y ${install_packages}
    fi
else
    echo "WARNING: It seems that your environment is not tested."
fi




# install zplug
if [ ! -e ~/.zplug ]; then
	echo "Installing zplug..."
	git clone https://github.com/zplug/zplug.git ~/.zplug
fi

# install tpm
if [ ! -e ~/.tmux/plugins/tpm ]; then
	echo "Installing tpm..."
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# install fzf
if [ ! -e ~/.fzf ]; then
	echo "Installing fzf..."
	git clone https://github.com/junegunn/fzf.git ~/.fzf
	workdir=${PWD}
	cd ~/.fzf && ./install --key-bindings --no-completion --no-update-rc
	cd ${workdir}
fi

#install volta
if [ ! -e ~/.volta ]; then
	echo "installing volta..."
	curl https://get.volta.sh | bash
fi

# install pyenv
if [ ! -e ~/.pyenv ]; then
	echo "Installing pyenv..."
	git clone https://github.com/yyuu/pyenv.git -b v2.0.6 ~/.pyenv
fi

# pyenv init
export PATH="${HOME}/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

if [ ! -e "${HOME}/.pyenv/versions/${PYTHON3_VERSION}" ]; then
	echo "Installing python${PYTHON3_VERSION}..."
	pyenv install ${PYTHON3_VERSION}
else
	echo "Python ${PYTHON3_VERSION} is already installed."
fi

# set python
pyenv shell --unset
pyenv global ${PYTHON3_VERSION}

# check python version
python3_version=$(python3 --version 2>&1)
if [ "${python3_version}" = "Python ${PYTHON3_VERSION}" ]; then
	echo "Python3 version check is OK."
else
	echo "Python 3 version check is failed."
	exit 1
fi

# install python library
python -m pip install -U pip
python -m pip install -U setuptools
python -m pip install -r requirements.txt



# install vim
ROOTDIR=$PWD
TMPDIR=$(mktemp -d /tmp/XXXXX)

# install nvim
if [ ! -e "${HOME}"/local/bin/nvim ]; then
	echo "Installing neovim..."
	cd "${HOME}"/local/bin
	wget https://github.com/neovim/neovim/releases/download/v0.8.1/nvim.appimage
	chmod u+x nvim.appimage
	if ./nvim.appimage --version >& /dev/null; then
		ln -s ./nvim.appimage nvim
	else
		./nvim.appimage --appimage-extract
		mv -v squashfs-root ../nvim
		ln -s ../nvim/AppRun nvim
		rm nvim.appimage
	fi
fi


#install tmux
if [ ! -e "${HOME}"/local/bin/tmux ]; then
	echo "Installing tumux..."
	cd "$TMPDIR"
	wget https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
	tar -xzf tmux-2.6.tar.gz
	cd tmux-2.6
	./configure --prefix="${HOME}"/local
	make -j && make install
fi

#install starship
if [! -e /usr/local/bin/starship ]; then
    echo "Installing starship..."
    cd "$TMPDIR"
    curl -sS https://starship.rs/install.sh | sh
fi

# clean up
cd $ROOTDOR
[ -e "$TMPDIR" ] && rm -rf "$TMPDIR"


# install vim plugins
echo "Installing vim plugins..."
export PATH="${HOME}/local/bin:$PATH"
[ ! -e ~/.cache/dein/repos/github.com/Shougo/dein.vim ] && \
	git clone https://github.com/Shougo/dein.vim ~/.cache/dein/repos/github.com/Shougo/dein.vim
nvim -c "try | call dein#install() | finally | qall! | endtry" -N -u "${HOME}"/.vim/init.vim -Vl -es
nvim -c "try | call dein#update() | finally | qall! | enctry" -N -u "${HOME}"/.vim/init.vim -Vl -es

echo ""
echo "Successfully installed essential tools."
echo "Please run following command \"exec zsh -l\" to run zsh."







