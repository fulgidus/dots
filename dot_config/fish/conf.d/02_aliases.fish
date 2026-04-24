# conf.d/02_aliases.fish — alias per i tool moderni

# eza → ls
alias ls  'eza --icons=always'
alias ll  'eza --icons=always -la --git'
alias la  'eza --icons=always -a'
alias lt  'eza --icons=always --tree --level=2'
alias ltt 'eza --icons=always --tree'

# bat → cat  (usa `command cat` per bypassare l'alias se serve)
alias cat 'bat'

# lazygit
alias lg 'lazygit'

# chezmoi shortcuts
alias cz   'chezmoi'
alias cza  'chezmoi apply'
alias czd  'chezmoi diff'
alias czcd 'chezmoi cd'
