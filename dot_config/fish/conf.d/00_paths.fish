# conf.d/00_paths.fish — PATH management
# fish_add_path è idempotente: non aggiunge duplicati

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
