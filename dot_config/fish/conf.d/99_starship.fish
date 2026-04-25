# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

starship init fish | source

# enable_transience su fish >= 4.1: set -g fish_transient_prompt 1
# fish 4.1+ gestisce nativamente Enter, Enter vuoto, e Ctrl+C
# NON aggiungere binding manuali per \cc: corrompono il display
enable_transience

# Ctrl+C — simula un Enter su riga vuota (che fish_transient_prompt gestisce già)
# commandline --replace '' svuota il buffer senza toccare il terminale
# commandline -f execute triggera il meccanismo transient nativo di fish 4.1+
# (niente ANSI, niente repaint — fish gestisce tutto internamente)
function __transient_cancel
    commandline -f beginning-of-line  # vai all'inizio (fish aggiorna il cursore internamente)
    commandline -f kill-line           # cancella fino a fine riga (fish aggiorna display + buffer)
    commandline -f execute             # esegui riga vuota → transient nativo
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
