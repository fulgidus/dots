# conf.d/12_fzf.fish — fuzzy finder key bindings
# Ctrl+R  → history fuzzy search
# Ctrl+T  → file picker
# Alt+C   → directory jump
command -q fzf && fzf --fish | source
