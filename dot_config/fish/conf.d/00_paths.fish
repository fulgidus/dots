# conf.d/00_paths.fish — inizializza Homebrew e PATH
#
# !! Questo file deve stare PRIMO (00_) !!
# Fish non legge .zshenv/.profile, quindi brew va inizializzato qui.
# Tutti gli altri tool (starship, mise, zoxide...) sono installati via brew
# e non sarebbero trovati senza questo blocco.

# ── Homebrew ──────────────────────────────────────────────────────────────────
if test -x /home/linuxbrew/.linuxbrew/bin/brew          # Linux
    set -gx HOMEBREW_PREFIX /home/linuxbrew/.linuxbrew
    fish_add_path /home/linuxbrew/.linuxbrew/bin
    fish_add_path /home/linuxbrew/.linuxbrew/sbin
else if test -x /opt/homebrew/bin/brew                  # macOS Apple Silicon
    set -gx HOMEBREW_PREFIX /opt/homebrew
    fish_add_path /opt/homebrew/bin
    fish_add_path /opt/homebrew/sbin
else if test -x /usr/local/bin/brew                     # macOS Intel
    set -gx HOMEBREW_PREFIX /usr/local
    fish_add_path /usr/local/bin
    fish_add_path /usr/local/sbin
end

# ── Altri tool ────────────────────────────────────────────────────────────────
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.opencode/bin

# bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# pnpm
set -gx PNPM_HOME $HOME/.local/share/pnpm
fish_add_path $PNPM_HOME

# zvm (Zig version manager) — migrazione a mise quando pronto
set -gx ZVM_INSTALL $HOME/.zvm/self
fish_add_path $HOME/.zvm/bin
fish_add_path $ZVM_INSTALL
