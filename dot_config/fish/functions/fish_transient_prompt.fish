# fish_transient_prompt — fish 4.0+ feature
# Sostituisce il prompt ╭─/╰─ dei comandi precedenti con un semplice ❯
# Equivalente di POWERLEVEL9K_TRANSIENT_PROMPT=always
function fish_transient_prompt
    set_color --bold '#9ece6a'
    echo -n '❯'
    set_color normal
    echo -n ' '
end
