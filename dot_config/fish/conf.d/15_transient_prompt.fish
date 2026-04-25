# conf.d/15_transient_prompt.fish
#
# Transient prompt: quando viene eseguito un comando, risale di 2 righe
# (╭─ e ╰─) e le sovrascrive con un semplice ❯, esattamente come
# POWERLEVEL9K_TRANSIENT_PROMPT=always in p10k.
#
# Meccanismo: fish_preexec è l'evento che scatta dopo Enter, prima
# dell'esecuzione. A quel punto il cursore è sulla riga vuota sotto ╰─❯.
# Escape ANSI usati:
#   \033[2A  → su di 2 righe
#   \033[J   → cancella dal cursore a fine schermo
#   \n       → scendi di 1 (per lasciare spazio all'output del comando)

function _transient_prompt --on-event fish_preexec
    printf '\033[2A\033[J'
    set_color --bold '#9ece6a'
    printf '❯'
    set_color normal
    printf '\n'
end
