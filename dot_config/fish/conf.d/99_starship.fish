# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

starship init fish | source

# enable_transience su fish >= 4.1: set -g fish_transient_prompt 1
# fish 4.1+ gestisce nativamente Enter, Enter vuoto, e Ctrl+C
# NON aggiungere binding manuali per \cc: corrompono il display
enable_transience

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
