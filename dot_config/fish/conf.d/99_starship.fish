# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

starship init fish | source

# enable_transience su fish >= 4.1: set -g fish_transient_prompt 1
# fish 4.1+ gestisce nativamente Enter, Enter vuoto, e Ctrl+C
# NON aggiungere binding manuali per \cc: corrompono il display
enable_transience

# Ctrl+C — transient manuale via ANSI (fish_transient_prompt non copre Ctrl+C)
# Al momento del binding, il cursore è sulla riga ╰─❯ (NON su riga nuova sotto).
# \r      → col 0 della riga corrente (╰─❯)
# \e[1A   → su di 1 riga (╭─)
# \e[J    → cancella da qui a fine schermo (╭─ + ╰─❯)
# poi cancel-commandline senza repaint (repaint corrompe il cursore)
function __transient_cancel
    printf '\r\e[1A\e[J\e[1;32m❯\e[0m'
    commandline -f cancel-commandline
end
bind --user \cc __transient_cancel
bind --user -M insert \cc __transient_cancel

# Transient prompt: ❯ verde su successo, ❯ rosso su errore
# Il valore di exit code arriva come --status=N negli $argv, non in $STARSHIP_CMD_STATUS
function starship_transient_prompt_func
    argparse --ignore-unknown 'status=' -- $argv 2>/dev/null
    if test "$_flag_status" = "0" -o -z "$_flag_status"
        printf "\e[1;32m❯\e[0m "
    else
        printf "\e[1;31m❯\e[0m "
    end
end
