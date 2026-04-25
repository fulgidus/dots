# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

starship init fish | source

# Abilita il transient prompt nativo di starship.
# Fish >= 4.1: usa fish_transient_prompt built-in (set -g fish_transient_prompt 1).
# Il prompt ╭─/╰─ precedente collassa a  ❯ <comando> su:
#   • Enter con comando
#   • Enter vuoto
#   • Ctrl+C
enable_transience

# Transient prompt: ❯ verde su successo, ❯ rosso su errore
function starship_transient_prompt_func
    if test $STARSHIP_CMD_STATUS -eq 0
        printf "\e[1;32m❯\e[0m "   # verde
    else
        printf "\e[1;31m❯\e[0m "   # rosso
    end
end
