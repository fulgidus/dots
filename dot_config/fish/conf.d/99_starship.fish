# conf.d/99_starship.fish — prompt (deve stare ULTIMO)

command -q starship || return

# 1. Init starship (definisce fish_prompt)
starship init fish | source

# ── Transient prompt ─────────────────────────────────────────────────────────
# Collassa il prompt ╭─/╰─ precedente — tutti e tre i casi:
#   • comando eseguito  → fish_preexec  → ❯ <comando>
#   • Enter vuoto       → fish_prompt   → ❯
#   • Ctrl+C            → fish_prompt   → ❯
#
# Meccanismo escape ANSI:
#   \033[2A = risali di 2 righe (╭─ e ╰─)
#   \033[J  = cancella dal cursore a fine schermo

# Backup della fish_prompt di starship prima di sovrascriverla
functions -c fish_prompt _starship_prompt_inner

set -g _fish_cmd_ran    0
set -g _fish_first_prompt 1

# ── Caso 1: comando reale ─────────────────────────────────────────────────────
function _transient_preexec --on-event fish_preexec
    set -g _fish_cmd_ran 1
    printf '\033[2A\033[J'
    set_color --bold '#9ece6a'
    printf '❯'
    set_color normal
    printf ' %s\n' $argv[1]   # ← mostra il comando eseguito
end

# ── Caso 2 & 3: Enter vuoto o Ctrl+C ─────────────────────────────────────────
function fish_prompt
    if test $_fish_first_prompt -eq 0; and test $_fish_cmd_ran -eq 0
        # Nessun comando eseguito: collassa il prompt precedente (senza \n —
        # ci pensa add_newline=true di starship a spaziare prima del nuovo ╭─)
        printf '\033[2A\033[J'
        set_color --bold '#9ece6a'
        printf '❯'
        set_color normal
    end
    # Se _fish_cmd_ran=1, fish_preexec ha già collassato — non fare nulla

    set -g _fish_first_prompt 0
    set -g _fish_cmd_ran      0
    _starship_prompt_inner
end
