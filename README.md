# RishavOS

A colorful, keyboard-driven terminal UI for setting up a fresh macOS machine with Homebrew — all in a single zsh script. Fully made with Claude Code Sonnet 4.6.

```
╔══════════════════════════════════════════════════════════════╗
║              RishavOS — Homebrew Setup TUI                   ║
║         Navigate with arrows · Space to toggle               ║
║              Enter to install · Q to quit                    ║
╚══════════════════════════════════════════════════════════════╝
```

> [!WARN] THIS IS NOT POLISHED
> 
> It is a bit laggy, I know! It was fully vibe coded with Claude without any modifications.

## Features

- **58 curated packages** across 11 categories — Dev Tools, Terminals, Languages, Package Managers, Databases, DevOps, Editors, Productivity, CLI Utils, Media, Networking
- **Category browser** — filter the list down to one category at a time
- **Live search** — fuzzy filter packages by name, formula, or description
- **Select individually or all at once** — per category or across everything
- **Live brew output** — watch each package install in real time with streaming output
- **Install summary** — clean ✓ / ⚠ / ✗ summary screen after all packages finish
- **Colorful TUI** — built with raw ANSI escape codes, no external TUI libraries required
- **Ctrl+C safe** — cleans up the terminal properly on any exit

## Requirements

- macOS (best recommended)
- [Homebrew](https://brew.sh) already installed
- zsh (default shell on macOS since Catalina)


## Usage

Launch the script and use the keyboard to navigate:

| Key | Action |
|-----|--------|
| `↑` / `↓` | Move cursor |
| `Space` | Toggle package selection |
| `A` | Select / deselect all in current view |
| `/` | Search packages |
| `C` | Browse by category |
| `PgUp` / `PgDn` | Scroll 10 at a time |
| `Enter` | Install selected packages |
| `Q` | Quit |

## Packages

<details>
<summary><b>Dev Tools</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| Git | `git` | cli |
| GitHub CLI | `gh` | cli |
| Neovim | `neovim` | cli |
| tmux | `tmux` | cli |
| LazyGit | `lazygit` | cli |
| git-delta | `git-delta` | cli |
| jq | `jq` | cli |
| HTTPie | `httpie` | cli |
| act | `act` | cli |

</details>

<details>
<summary><b>Terminals</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| iTerm2 | `iterm2` | cask |
| Warp | `warp` | cask |
| Alacritty | `alacritty` | cask |
| Fish Shell | `fish` | cli |
| Starship | `starship` | cli |
| zsh-syntax-highlighting | `zsh-syntax-highlighting` | cli |
| zsh-autosuggestions | `zsh-autosuggestions` | cli |

</details>

<details>
<summary><b>Languages</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| Node.js | `node` | cli |
| Python 3.12 | `python@3.12` | cli |
| Go | `go` | cli |
| Rust | `rust` | cli |
| Deno | `deno` | cli |
| Ruby | `ruby` | cli |

</details>

<details>
<summary><b>Package Managers</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| pnpm | `pnpm` | cli |
| Yarn | `yarn` | cli |
| Poetry | `poetry` | cli |
| uv | `uv` | cli |

</details>

<details>
<summary><b>Databases</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| PostgreSQL 16 | `postgresql@16` | cli |
| Redis | `redis` | cli |
| SQLite | `sqlite` | cli |
| DBeaver | `dbeaver-community` | cask |

</details>

<details>
<summary><b>DevOps</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| Docker Desktop | `docker` | cask |
| kubectl | `kubernetes-cli` | cli |
| Terraform | `terraform` | cli |
| AWS CLI | `awscli` | cli |
| Helm | `helm` | cli |
| k9s | `k9s` | cli |

</details>

<details>
<summary><b>Editors</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| VS Code | `visual-studio-code` | cask |
| Cursor | `cursor` | cask |
| Zed | `zed` | cask |
| Sublime Text | `sublime-text` | cask |

</details>

<details>
<summary><b>Productivity</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| Raycast | `raycast` | cask |
| Rectangle | `rectangle` | cask |
| Obsidian | `obsidian` | cask |
| 1Password | `1password` | cask |

</details>

<details>
<summary><b>CLI Utils</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| fzf | `fzf` | cli |
| bat | `bat` | cli |
| eza | `eza` | cli |
| ripgrep | `ripgrep` | cli |
| fd | `fd` | cli |
| htop | `htop` | cli |
| zoxide | `zoxide` | cli |
| tldr | `tldr` | cli |
| ncdu | `ncdu` | cli |

</details>

<details>
<summary><b>Media</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| FFmpeg | `ffmpeg` | cli |
| ImageMagick | `imagemagick` | cli |
| VLC | `vlc` | cask |

</details>

<details>
<summary><b>Networking</b></summary>

| Package | Formula | Type |
|---------|---------|------|
| wget | `wget` | cli |
| nmap | `nmap` | cli |
| mtr | `mtr` | cli |

</details>

## Adding Your Own Packages

Open `rishavos.sh` and add a line to the `PKGS` array:

```bash
"formula|Display Name|cask(0/1)|Description|Category"
```

For example:
```bash
"neofetch|Neofetch|0|System info tool|CLI Utils"
"figma|Figma|1|Collaborative design tool|Productivity"
```

Use `1` for cask installs, `0` for regular formula installs.

## License

MIT
