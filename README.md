# dotfiles

Configurazioni personali gestite con [chezmoi](https://chezmoi.io).  
Funzionano su **Linux** (Linuxbrew) e **macOS** (Homebrew) senza modifiche.

## File tracciati

| File sorgente | Destinazione | Contenuto |
|---|---|---|
| `dot_zshrc` | `~/.zshrc` | Shell principale (oh-my-zsh + p10k) |
| `dot_zshenv` | `~/.zshenv` | Variabili d'ambiente pre-shell |
| `dot_p10k.zsh` | `~/.p10k.zsh` | Configurazione prompt Powerlevel10k |
| `dot_wezterm.lua` | `~/.wezterm.lua` | Configurazione terminale WezTerm |
| `dot_gitconfig` | `~/.gitconfig` | Configurazione Git globale |
| `dot_config/Code/User/settings.json` | `~/.config/Code/User/settings.json` | Settings VSCode |

> **Convenzione chezmoi:** i file nella source dir usano il prefisso `dot_` al posto del `.`
> e `private_` per i file con permessi 600. Il suffisso `.tmpl` attiva il motore di template Go.

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
<summary>Zsh + oh-my-zsh + Powerlevel10k</summary>

```bash
brew install zsh
sudo sh -c 'echo "/home/linuxbrew/.linuxbrew/bin/zsh" >> /etc/shells'
chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew install powerlevel10k
```
</details>

<details>
<summary>WezTerm (Ubuntu/Debian)</summary>

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```
</details>

### 2. Installa chezmoi e applica i dotfile

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:fulgidus/dots.git
```

Questo comando fa tutto in un colpo: installa chezmoi, clona il repo e copia i file nelle posizioni corrette.

---

## Workflow quotidiano

### Modificare un file

Modifica direttamente il file nella sua posizione normale (es. `~/.zshrc`), poi sincronizza la modifica nella source dir:

```bash
chezmoi re-add ~/.zshrc
```

### Vedere cosa è cambiato

```bash
chezmoi diff          # diff tra source dir e filesystem
chezmoi status        # lista file modificati (come git status)
```

### Applicare le modifiche dal repo (pull)

```bash
chezmoi update        # git pull + chezmoi apply in un comando
```

### Modificare direttamente nella source dir

```bash
chezmoi edit ~/.zshrc      # apre il file sorgente nell'editor
chezmoi apply ~/.zshrc     # applica solo quel file
```

### Commit e push

```bash
chezmoi cd             # entra in ~/.local/share/chezmoi
git add -A
git commit -m "feat: descrizione modifica"
git push
# oppure: exit per tornare alla dir precedente
```

---

## Aggiungere nuovi file

```bash
chezmoi add ~/.config/ghostty/config   # aggiunge il file alla source dir
chezmoi cd
git add -A && git commit -m "feat: add ghostty config" && git push
```

---

## Configurazioni machine-specific (template)

Per valori diversi tra macchine (es. email lavoro vs personale, proxy aziendale, percorsi diversi),
chezmoi supporta template Go.

### 1. Converti un file in template

```bash
chezmoi chattr +template ~/.gitconfig
# il file diventa dot_gitconfig.tmpl nella source dir
```

### 2. Definisci i dati locali

Chezmoi chiede i valori al primo `init`. Per aggiungerli/modificarli manualmente:

```bash
chezmoi edit-config
```

Struttura del config (`~/.config/chezmoi/chezmoi.toml`):

```toml
[data]
    name  = "Alessio Corsi"
    email = "alessio.corsi@gmail.com"
```

### 3. Usa i valori nel template

```
# dot_gitconfig.tmpl
[user]
    name  = {{ .name }}
    email = {{ .email }}
```

### Condizionali per OS o hostname

```
{{- if eq .chezmoi.os "darwin" }}
# Solo su macOS
export BROWSER=Safari
{{- else }}
# Solo su Linux
export BROWSER=google-chrome
{{- end }}

{{- if eq .chezmoi.hostname "work-laptop" }}
export HTTP_PROXY="http://proxy.azienda.it:8080"
{{- end }}
```

Variabili chezmoi sempre disponibili nei template:

| Variabile | Esempio |
|---|---|
| `.chezmoi.os` | `linux`, `darwin` |
| `.chezmoi.arch` | `amd64`, `arm64` |
| `.chezmoi.hostname` | `latitude` |
| `.chezmoi.username` | `fulgidus` |
| `.chezmoi.homeDir` | `/home/fulgidus` |

---

## Struttura del repository

```
~/.local/share/chezmoi/        ← source dir (questo repo)
├── .chezmoi.toml.tmpl         ← template del config chezmoi
├── dot_zshrc                  ← ~/.zshrc
├── dot_zshenv                 ← ~/.zshenv
├── dot_p10k.zsh               ← ~/.p10k.zsh
├── dot_wezterm.lua            ← ~/.wezterm.lua
├── dot_gitconfig              ← ~/.gitconfig
└── dot_config/
    └── Code/User/
        └── settings.json     ← ~/.config/Code/User/settings.json
```

---

## Riferimenti

- [chezmoi.io — documentazione ufficiale](https://chezmoi.io)
- [chezmoi quick start](https://chezmoi.io/quick-start/)
- [template reference (Go text/template)](https://pkg.go.dev/text/template)
