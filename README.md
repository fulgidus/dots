# Dotfiles

## Getting started

### Install Linuxbrew
```bash
test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
```
```bash
test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
### Install Zsh
```bash
brew install zsh
```
```bash
chsh -s $(which zsh)
```
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
stow zsh
```
```bash
stow fonts
```
### Install Ghostty
```bash
cd
```
```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```
