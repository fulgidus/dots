# dotfiles

Configurazioni personali gestite con [chezmoi](https://chezmoi.io).  
Funzionano su **Linux** (Linuxbrew) e **macOS** (Homebrew) senza modifiche.

## Stack

| Categoria | Tool |
|---|---|
| Shell | [Fish](https://fishshell.com/) 4+ |
| Prompt | [Starship](https://starship.rs/) — tema Tokyo Night |
| Terminale | [WezTerm](https://wezfurlong.org/wezterm/) |
| Version manager | [mise](https://mise.jdx.dev/) |
| History sync | [atuin](https://atuin.sh/) |
| Git diff | [delta](https://dandavison.github.io/delta/) |
| Git TUI | [lazygit](https://github.com/jesseduffield/lazygit) |

### CLI moderni

| Comando | Rimpiazza | Tool |
|---|---|---|
| `ls` / `ll` / `lt` | `ls` | [eza](https://eza.rocks/) |
| `cat` | `cat` | [bat](https://github.com/sharkdp/bat) |
| `z <path>` | `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) |
| `rg` | `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| `fd` | `find` | [fd](https://github.com/sharkdp/fd) |
| Ctrl+R / Ctrl+T | — | [fzf](https://github.com/junegunn/fzf) |

---

## File tracciati

```
~/.local/share/chezmoi/              ← source dir (questo repo)
├── .chezmoi.toml.tmpl               ← dati machine-specific (nome, email)
├── dot_gitconfig                    ← ~/.gitconfig  (con delta)
├── dot_wezterm.lua                  ← ~/.wezterm.lua
├── README.md
└── dot_config/
    ├── starship.toml                ← ~/.config/starship.toml
    ├── fish/
    │   ├── config.fish              ← ~/.config/fish/config.fish
    │   └── conf.d/
    │       ├── 00_paths.fish        ← PATH: bun, pnpm, opencode, zvm
    │       ├── 01_env.fish          ← EDITOR, BAT_THEME, fzf backend
    │       ├── 02_aliases.fish      ← ls/cat/lg/cz e altri alias
    │       ├── 10_mise.fish         ← attiva mise (Node, Python, Go…)
    │       ├── 11_zoxide.fish       ← attiva zoxide (`z`, `zi`)
    │       ├── 12_fzf.fish          ← key bindings fzf (Ctrl+R, Ctrl+T, Alt+C)
    │       ├── 13_atuin.fish        ← history sync cross-machine
    │       ├── 14_viteplus.fish     ← Vite+ runtime
    │       └── 99_starship.fish     ← init prompt (deve stare ultimo)
    └── Code/User/
        └── settings.json           ← ~/.config/Code/User/settings.json
```

> **Convenzione chezmoi:** `dot_` → `.`, `private_` → permessi 600, `.tmpl` → template Go.

---

## Setup su una nuova macchina

### 1. Prerequisiti

<details>
<summary>Linuxbrew (Linux)</summary>

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```
</details>

<details>
<summary>Fish come shell di default</summary>

```bash
# Aggiungi fish a /etc/shells
echo /home/linuxbrew/.linuxbrew/bin/fish | sudo tee -a /etc/shells

# Imposta come default
chsh -s /home/linuxbrew/.linuxbrew/bin/fish
```

Su macOS con Homebrew:
```bash
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```
</details>

### 2. Installa chezmoi e applica i dotfile

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:fulgidus/dots.git
```

Clona il repo, genera il config da `.chezmoi.toml.tmpl` e copia tutti i file nelle posizioni corrette.

### 3. Installa i tool via brew

```bash
brew install fish starship eza bat zoxide fzf ripgrep fd git-delta mise atuin lazygit gh
```

### 4. Configura atuin (history sync)

```bash
# Nuovo account
atuin register -u <username> -e <email> -p <password>

# Oppure login su account esistente
atuin login -u <username> -p <password>

atuin sync
```

### 5. Installa i runtime con mise

```bash
# Esempio: installa Node LTS e Python
mise use --global node@lts python@latest

# Verifica
mise list
```

---

## Workflow quotidiano

### Modificare un file

Modifica il file direttamente nella sua posizione (es. `~/.config/fish/conf.d/02_aliases.fish`), poi:

```bash
chezmoi re-add ~/.config/fish/conf.d/02_aliases.fish
```

### Scorciatoie alias

```bash
czd   # chezmoi diff   — vedi cosa è cambiato
cza   # chezmoi apply  — applica le modifiche dal repo
czcd  # chezmoi cd     — entra nella source dir
```

### Vedere le differenze pendenti

```bash
chezmoi diff    # diff completo tra source dir e filesystem
chezmoi status  # lista file modificati (stile git status)
```

### Aggiornare dal repo (pull)

```bash
chezmoi update  # git pull + chezmoi apply in un colpo
```

### Modificare nella source dir ed editare direttamente

```bash
chezmoi edit ~/.config/fish/conf.d/02_aliases.fish  # apre nell'editor
chezmoi apply                                         # applica
```

### Commit e push

```bash
czcd  # entra in ~/.local/share/chezmoi
git add -A
git commit -m "feat: descrizione"
git push
```

---

## Aggiungere nuovi file

```bash
chezmoi add ~/.config/ghostty/config
czcd
git add -A && git commit -m "feat: add ghostty config" && git push
```

---

## Configurazioni machine-specific (template)

Per valori diversi tra macchine — proxy aziendale, email lavoro/personale, path diversi.

### 1. Converti un file in template

```bash
chezmoi chattr +template ~/.gitconfig
# diventa dot_gitconfig.tmpl nella source dir
```

### 2. Dati locali

Il file `.chezmoi.toml.tmpl` genera `~/.config/chezmoi/chezmoi.toml` al primo `init`.  
Per editarlo su una macchina esistente:

```bash
chezmoi edit-config
```

```toml
[data]
    name  = "Alessio Corsi"
    email = "alessio.corsi@gmail.com"
```

### 3. Sintassi template

```
# dot_gitconfig.tmpl
[user]
    name  = {{ .name }}
    email = {{ .email }}
```

```
# Condizionale OS
{{- if eq .chezmoi.os "darwin" }}
export BROWSER=Safari
{{- else }}
export BROWSER=google-chrome
{{- end }}

# Condizionale hostname
{{- if eq .chezmoi.hostname "work-laptop" }}
set -gx HTTP_PROXY "http://proxy.azienda.it:8080"
{{- end }}
```

### Variabili sempre disponibili

| Variabile | Esempio |
|---|---|
| `.chezmoi.os` | `linux`, `darwin` |
| `.chezmoi.arch` | `amd64`, `arm64` |
| `.chezmoi.hostname` | `latitude` |
| `.chezmoi.username` | `fulgidus` |
| `.chezmoi.homeDir` | `/home/fulgidus` |

---

## Riferimenti

- [chezmoi.io](https://chezmoi.io) — documentazione ufficiale
- [fishshell.com](https://fishshell.com/docs/current/) — documentazione fish
- [starship.rs](https://starship.rs/config/) — configurazione starship
- [mise.jdx.dev](https://mise.jdx.dev/) — version manager
- [atuin.sh](https://atuin.sh/docs/) — history sync
