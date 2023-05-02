## Environment

Ubuntu 20.04 on WSL2(Windows11)


## Setup

```bash
$ git clone https://github.com/morita-koki/dotfiles
cd dotfiles

# setup dotfiles
$ ./setup.sh

# install essential tools ( required sudo)
$ ./install.sh

# enable zsh environment
$ exec zsh -l
```


## Note

nvimを実行して変なワーニングが表示されたら
```
:call dein#install()
:call dein#update()
```
を実行