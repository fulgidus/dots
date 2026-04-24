# conf.d/01_env.fish — variabili d'ambiente

set -gx EDITOR "code --wait"
set -gx VISUAL $EDITOR

# bat: tema compatibile con Tokyo Night (WezTerm)
set -gx BAT_THEME "TwoDark"

# bat come pager per man
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

# fzf: usa ripgrep come backend (più veloce, rispetta .gitignore)
set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --glob '!.git'"
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
