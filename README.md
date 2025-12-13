# Dotfiles

## Getting started

### Install Linuxbrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```bash
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
```
```bash
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
```bash
echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
```
### Install Git
```bash
brew install git
```
### Install Zsh
```bash
brew install zsh
```
Add `/home/linuxbrew/.linuxbrew/bin/zsh` to the end of file
```bash
sudo sh -c 'echo "/home/linuxbrew/.linuxbrew/bin/zsh" >> /etc/shells'
```
Set default shell
```bash
chsh -s $(which zsh)
```
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
### Install Powerlevel10k theme
```bash
brew install powerlevel10k
```
```bash
echo "\n# Source theme\nsource $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```
### Clone this repository and install dotfiles
```bash
git clone git@github.com:fulgidus/dots.git
```
```bash
cd dots
```
```bash
brew install stow
```
```bash
stow zsh fonts vscode git
```
### Install Ghostty
```bash
cd
```
```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

