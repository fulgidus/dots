# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

starship init fish | source

# enable_transience su fish >= 4.1 fa solo: set -g fish_transient_prompt 1
# → gestisce Enter (con e senza comando)
# → NON gestisce Ctrl+C (non bindato)
enable_transience

# Ctrl+C: setta TRANSIENT=1, fa repaint (mostra ❯), poi cancella la riga
function __transient_cancel
    set -g TRANSIENT 1
    set -g RIGHT_TRANSIENT 1
    commandline -f repaint
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
