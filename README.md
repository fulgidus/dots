# dotfiles

Configurazioni personali gestite con [chezmoi](https://chezmoi.io).  
Funzionano su **Linux** (Linuxbrew) e **macOS** (Homebrew) senza modifiche.

## Stack

| Categoria | Tool |
|---|---|
| Shell | [Fish](https://fishshell.com/) 4+ |
| Prompt | [Starship](https://starship.rs/) — tema Tokyo Night custom |
| Terminale | [WezTerm](https://wezfurlong.org/wezterm/) |
| Version manager | [mise](https://mise.jdx.dev/) |
| History sync | [atuin](https://atuin.sh/) |
| Git diff | [delta](https://dandavison.github.io/delta/) |
| Git TUI | [lazygit](https://github.com/jesseduffield/lazygit) |

### CLI moderni

| Alias/comando | Rimpiazza | Tool |
|---|---|---|
| `ls` / `ll` / `lt` | `ls` | [eza](https://eza.rocks/) — icone, git status, tree |
| `cat` | `cat` | [bat](https://github.com/sharkdp/bat) — syntax highlight, man pager |
| `z <path>` | `cd` | [zoxide](https://github.com/ajeetdsouza/zoxide) — frecency |
| `rg` | `grep` | [ripgrep](https://github.com/BurntSushi/ripgrep) |
| `fd` | `find` | [fd](https://github.com/sharkdp/fd) |
| `lg` | — | [lazygit](https://github.com/jesseduffield/lazygit) — TUI git |
| Ctrl+R / Ctrl+T / Alt+C | — | [fzf](https://github.com/junegunn/fzf) — fuzzy finder |

---

## Prompt

Layout a due righe con transient prompt (le righe precedenti collassano a `❯`):

```
╭─ [ os ][ 󰉖 dir ][ branch  status ] ········ [  node ][ ⏱ 3s ][ 12:34 ]
╰─❯ _
```

| Caso | Comportamento |
|---|---|
| Comando + Enter | `❯ comando` (verde/rosso per exit code) poi output |
| Enter vuoto | `❯` |
| Ctrl+C | `❯` — input corrente cancellato (comportamento standard Unix) |

Segmenti destra visibili **solo nella directory del progetto**:
`node`, `python`, `rust`, `go`, `kubernetes` (solo se kubectl configurato)

---

## File tracciati

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                    ← dati machine-specific (nome, email)
├── dot_gitconfig                         ← ~/.gitconfig (con delta)
├── dot_wezterm.lua                       ← ~/.wezterm.lua
├── README.md
└── dot_config/
    ├── starship.toml                     ← ~/.config/starship.toml
    ├── fish/
    │   ├── config.fish                   ← bootstrap minimale (greeting off)
    │   └── conf.d/                       ← caricati in ordine alfabetico
    │       ├── 00_paths.fish             ← Homebrew + PATH (deve stare primo)
    │       ├── 01_env.fish               ← EDITOR, BAT_THEME, fzf backend
    │       ├── 02_aliases.fish           ← ls/cat/lg/cz e altri alias
    │       ├── 10_mise.fish              ← attiva mise (Node, Python, Go…)
    │       ├── 11_zoxide.fish            ← z / zi
    │       ├── 12_fzf.fish               ← Ctrl+R, Ctrl+T, Alt+C
    │       ├── 13_atuin.fish             ← history sync cross-machine
    │       ├── 14_viteplus.fish          ← Vite+ runtime
    │       └── 99_starship.fish          ← prompt + transient (deve stare ultimo)
    ├── Code/User/
    │   └── settings.json                 ← ~/.config/Code/User/settings.json
    └── starship.toml
└── dot_local/share/fonts/
    ├── FiraCode/                         ← FiraCode Nerd Font
    └── Meslo/                            ← Meslo Nerd Font
```

> **Convenzione chezmoi:** `dot_` → `.` · `private_` → permessi 600 · `.tmpl` → template Go

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
# Linux (Linuxbrew)
echo /home/linuxbrew/.linuxbrew/bin/fish | sudo tee -a /etc/shells
chsh -s /home/linuxbrew/.linuxbrew/bin/fish

# macOS (Homebrew)
echo /opt/homebrew/bin/fish | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/fish
```
</details>

### 2. Installa chezmoi e applica i dotfile

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:fulgidus/dots.git
```

Clona il repo, genera il config e copia tutti i file nelle posizioni corrette.  
Aggiorna anche i font (`~/.local/share/fonts/`) e lancia `fc-cache -f`.

### 3. Installa i tool via brew

```bash
brew install fish starship eza bat zoxide fzf ripgrep fd git-delta mise atuin lazygit gh
```

### 4. Configura atuin (history sync tra macchine)

```bash
atuin register -u <username> -e <email> -p <password>   # nuovo account
# oppure
atuin login -u <username> -p <password>                  # account esistente

atuin sync
```

### 5. Installa i runtime con mise

```bash
mise use --global node@lts python@latest   # esempio
mise list                                   # verifica
```

### 6. Aggiorna font cache

```bash
fc-cache -f ~/.local/share/fonts
```

---

## Workflow quotidiano

### Modificare un file

Modifica direttamente nella posizione normale, poi sincronizza:

```bash
chezmoi re-add ~/.config/fish/conf.d/02_aliases.fish
```

### Alias chezmoi

```bash
czd    # chezmoi diff   — mostra differenze tra source e filesystem
cza    # chezmoi apply  — applica source → filesystem
czcd   # chezmoi cd     — entra nella source dir (~/.local/share/chezmoi)
```

### Pull aggiornamenti dal repo

```bash
chezmoi update   # git pull + chezmoi apply in un colpo
```

### Editare nella source dir

```bash
chezmoi edit ~/.config/fish/conf.d/02_aliases.fish
chezmoi apply
```

### Commit e push

```bash
czcd
git add -A && git commit -m "feat: ..." && git push
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

Per email lavoro/personale, proxy aziendale, path diversi tra macchine.

### Converti un file in template

```bash
chezmoi chattr +template ~/.gitconfig   # → dot_gitconfig.tmpl nella source dir
```

### Dati locali (`~/.config/chezmoi/chezmoi.toml`)

Generato da `.chezmoi.toml.tmpl` al primo `init`. Per modificarlo:

```bash
chezmoi edit-config
```

```toml
[data]
    name  = "Alessio Corsi"
    email = "alessio.corsi@gmail.com"
```

### Sintassi template

```
[user]
    name  = {{ .name }}
    email = {{ .email }}
```

```
# Condizionale OS (fish syntax nel template)
{{- if eq .chezmoi.os "darwin" }}
set -gx BROWSER Safari
{{- else }}
set -gx BROWSER google-chrome
{{- end }}

# Condizionale hostname
{{- if eq .chezmoi.hostname "work-laptop" }}
set -gx HTTP_PROXY "http://proxy.azienda.it:8080"
{{- end }}
```

### Variabili disponibili nei template

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
- [fishshell.com/docs](https://fishshell.com/docs/current/) — documentazione fish
- [starship.rs/config](https://starship.rs/config/) — configurazione starship
- [mise.jdx.dev](https://mise.jdx.dev/) — version manager
- [atuin.sh/docs](https://atuin.sh/docs/) — history sync
