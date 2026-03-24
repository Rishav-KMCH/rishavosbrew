#!/bin/zsh
# ╔══════════════════════════════════════════════════════════════╗
# ║              RishavOS — Homebrew Setup TUI                   ║
# ║         Navigate with arrows · Space to toggle               ║
# ║              Enter to install · Q to quit                    ║
# ╚══════════════════════════════════════════════════════════════╝

setopt KSH_ARRAYS

# ── Colors ────────────────────────────────────────────────────────────────────
R=$'\e[0m';        BOLD=$'\e[1m';       DIM=$'\e[2m'
FG_RED=$'\e[31m';  FG_GRN=$'\e[32m';   FG_YLW=$'\e[33m'
FG_CYN=$'\e[36m';  FG_WHT=$'\e[37m';   FG_BRT=$'\e[97m'
FG_ORG=$'\e[38;5;214m'; FG_PNK=$'\e[38;5;205m'; FG_TL=$'\e[38;5;43m'
FG_PRP=$'\e[38;5;141m'; FG_SKY=$'\e[38;5;117m'; FG_LIME=$'\e[38;5;154m'
FG_MUTED=$'\e[38;5;244m'; FG_DIM2=$'\e[38;5;238m'
BG_HDR=$'\e[48;5;18m';   BG_SEL2=$'\e[48;5;24m'

# ── Terminal helpers ──────────────────────────────────────────────────────────
hide_cursor()  { printf '\e[?25l'; }
show_cursor()  { printf '\e[?25h'; }
clear_screen() { printf '\e[2J\e[H'; }
move()         { printf "\e[%d;%dH" "$1" "$2"; }
clear_line()   { printf '\e[2K'; }
get_term_size(){ ROWS=$(tput lines); COLS=$(tput cols); }

cleanup() {
  show_cursor
  tput rmcups 2>/dev/null || true
  tput cnorm  2>/dev/null || true
  printf '\n'
}
trap 'cleanup; exit 0' INT TERM
trap 'cleanup' EXIT

# ── Category helpers ──────────────────────────────────────────────────────────
cat_color() {
  case "$1" in
    "Dev Tools")    printf '%s' "$FG_CYN"  ;;
    "Terminals")    printf '%s' "$FG_GRN"  ;;
    "Languages")    printf '%s' "$FG_YLW"  ;;
    "PkgMgrs")      printf '%s' "$FG_ORG"  ;;
    "Databases")    printf '%s' "$FG_PRP"  ;;
    "DevOps")       printf '%s' "$FG_SKY"  ;;
    "Editors")      printf '%s' "$FG_PNK"  ;;
    "Productivity") printf '%s' "$FG_TL"   ;;
    "CLI Utils")    printf '%s' "$FG_LIME" ;;
    "Media")        printf '%s' "$FG_ORG"  ;;
    "Networking")   printf '%s' "$FG_SKY"  ;;
    *)              printf '%s' "$FG_CYN"  ;;
  esac
}

cat_icon() {
  case "$1" in
    "Dev Tools")    printf '*' ;;
    "Terminals")    printf '>' ;;
    "Languages")    printf '~' ;;
    "PkgMgrs")      printf '#' ;;
    "Databases")    printf '=' ;;
    "DevOps")       printf '^' ;;
    "Editors")      printf 'E' ;;
    "Productivity") printf '@' ;;
    "CLI Utils")    printf '+' ;;
    "Media")        printf '&' ;;
    "Networking")   printf '-' ;;
    *)              printf '>' ;;
  esac
}

# ── Packages ──────────────────────────────────────────────────────────────────
# "brew_formula|Display Name|cask(0/1)|Description|Category"
PKGS=(
  "git|Git|0|Distributed version control system|Dev Tools"
  "gh|GitHub CLI|0|Official GitHub command-line tool|Dev Tools"
  "neovim|Neovim|0|Hyperextensible Vim-based text editor|Dev Tools"
  "tmux|tmux|0|Terminal multiplexer, split panes and sessions|Dev Tools"
  "lazygit|LazyGit|0|Simple terminal UI for git commands|Dev Tools"
  "git-delta|git-delta|0|Syntax-highlighting pager for git diff|Dev Tools"
  "jq|jq|0|Lightweight command-line JSON processor|Dev Tools"
  "httpie|HTTPie|0|Modern user-friendly HTTP client|Dev Tools"
  "act|act|0|Run GitHub Actions locally|Dev Tools"
  "iterm2|iTerm2|1|Replacement for Terminal with powerful features|Terminals"
  "warp|Warp|1|AI-powered terminal built in Rust|Terminals"
  "alacritty|Alacritty|1|GPU-accelerated terminal emulator|Terminals"
  "fish|Fish Shell|0|Smart and user-friendly command-line shell|Terminals"
  "starship|Starship|0|Minimal blazing-fast customizable prompt|Terminals"
  "zsh-syntax-highlighting|zsh-syntax-hl|0|Syntax highlighting for Zsh|Terminals"
  "zsh-autosuggestions|zsh-autosuggest|0|Autosuggestions for Zsh|Terminals"
  "node|Node.js|0|JavaScript runtime built on Chrome V8|Languages"
  "python@3.12|Python 3.12|0|Powerful scripting and general-purpose language|Languages"
  "go|Go|0|Open source language for reliable software|Languages"
  "rust|Rust|0|Systems language focused on safety and performance|Languages"
  "deno|Deno|0|Secure runtime for JavaScript and TypeScript|Languages"
  "ruby|Ruby|0|Dynamic open source programming language|Languages"
  "pnpm|pnpm|0|Fast disk-efficient Node.js package manager|PkgMgrs"
  "yarn|Yarn|0|Reliable and secure JS dependency management|PkgMgrs"
  "poetry|Poetry|0|Python dependency management and packaging|PkgMgrs"
  "uv|uv|0|Ultra-fast Python package installer in Rust|PkgMgrs"
  "postgresql@16|PostgreSQL 16|0|Advanced open source relational database|Databases"
  "redis|Redis|0|In-memory data structure store|Databases"
  "sqlite|SQLite|0|Self-contained serverless SQL database|Databases"
  "dbeaver-community|DBeaver|1|Universal database tool and SQL client|Databases"
  "docker|Docker Desktop|1|Platform for containerized development|DevOps"
  "kubernetes-cli|kubectl|0|CLI for Kubernetes clusters|DevOps"
  "terraform|Terraform|0|Infrastructure as Code by HashiCorp|DevOps"
  "awscli|AWS CLI|0|Official Amazon Web Services CLI|DevOps"
  "helm|Helm|0|Kubernetes package manager|DevOps"
  "k9s|k9s|0|Terminal UI for Kubernetes clusters|DevOps"
  "visual-studio-code|VS Code|1|Lightweight powerful source code editor|Editors"
  "cursor|Cursor|1|AI-first code editor forked from VS Code|Editors"
  "zed|Zed|1|Blazingly fast collaborative code editor|Editors"
  "sublime-text|Sublime Text|1|Sophisticated text editor for code|Editors"
  "raycast|Raycast|1|Blazing fast macOS launcher and productivity|Productivity"
  "rectangle|Rectangle|1|Move and resize windows with keyboard shortcuts|Productivity"
  "obsidian|Obsidian|1|Knowledge base on top of local Markdown files|Productivity"
  "1password|1Password|1|Cross-platform password manager|Productivity"
  "fzf|fzf|0|Command-line fuzzy finder|CLI Utils"
  "bat|bat|0|cat clone with syntax highlighting|CLI Utils"
  "eza|eza|0|Modern maintained replacement for ls|CLI Utils"
  "ripgrep|ripgrep|0|Extremely fast search respecting .gitignore|CLI Utils"
  "fd|fd|0|Fast user-friendly alternative to find|CLI Utils"
  "htop|htop|0|Interactive process viewer|CLI Utils"
  "zoxide|zoxide|0|Smarter cd command that learns your habits|CLI Utils"
  "tldr|tldr|0|Simplified community-driven man pages|CLI Utils"
  "ncdu|ncdu|0|Disk usage analyzer with ncurses interface|CLI Utils"
  "ffmpeg|FFmpeg|0|Complete solution to record and convert media|Media"
  "imagemagick|ImageMagick|0|Create edit and convert digital images|Media"
  "vlc|VLC|1|Free open source multimedia player|Media"
  "wget|wget|0|Network file downloader HTTP HTTPS FTP|Networking"
  "nmap|nmap|0|Network exploration tool and security scanner|Networking"
  "mtr|mtr|0|Network diagnostic combining ping and traceroute|Networking"
)
PKG_COUNT=${#PKGS[@]}

# ── State ─────────────────────────────────────────────────────────────────────
SELECTED=()
VISIBLE=()
CATS=()
CURSOR=0
CURRENT_CAT="All"
SEARCH_MODE=false
SEARCH_STR=""
SCROLL_OFFSET=0  # in render-row space (includes category header rows)

# ── Helpers ───────────────────────────────────────────────────────────────────
pkg_field() { echo "${PKGS[$1]}" | cut -d'|' -f"$2"; }

is_selected() {
  local s
  for s in "${SELECTED[@]:-}"; do [[ "$s" == "$1" ]] && return 0; done
  return 1
}

toggle_select() {
  if is_selected "$1"; then
    local new=() s
    for s in "${SELECTED[@]:-}"; do [[ "$s" != "$1" ]] && new+=("$s"); done
    SELECTED=("${new[@]:-}")
  else
    SELECTED+=("$1")
  fi
}

select_all_visible() {
  local v
  for v in "${VISIBLE[@]:-}"; do is_selected "$v" || SELECTED+=("$v"); done
}

deselect_all_visible() {
  local new=() s found v
  for s in "${SELECTED[@]:-}"; do
    found=0
    for v in "${VISIBLE[@]:-}"; do [[ "$s" == "$v" ]] && found=1 && break; done
    [[ $found -eq 0 ]] && new+=("$s")
  done
  SELECTED=("${new[@]:-}")
}

all_visible_selected() {
  [[ ${#VISIBLE[@]} -eq 0 ]] && return 1
  local v
  for v in "${VISIBLE[@]:-}"; do is_selected "$v" || return 1; done
  return 0
}

build_visible() {
  VISIBLE=()
  local i pcat pname pbrew pdesc q
  for i in $(seq 0 $(( PKG_COUNT - 1 ))); do
    pcat=$(pkg_field "$i" 5)
    [[ "$CURRENT_CAT" != "All" && "$pcat" != "$CURRENT_CAT" ]] && continue
    if [[ -n "$SEARCH_STR" ]]; then
      pname=$(pkg_field "$i" 2 | tr '[:upper:]' '[:lower:]')
      pbrew=$(pkg_field "$i" 1 | tr '[:upper:]' '[:lower:]')
      pdesc=$(pkg_field "$i" 4 | tr '[:upper:]' '[:lower:]')
      q=$(printf '%s' "$SEARCH_STR" | tr '[:upper:]' '[:lower:]')
      [[ "$pname$pbrew$pdesc" != *"$q"* ]] && continue
    fi
    VISIBLE+=("$i")
  done
  local vcnt=${#VISIBLE[@]}
  [[ $vcnt -eq 0 ]] && CURSOR=0 && SCROLL_OFFSET=0 && return
  [[ $CURSOR -ge $vcnt ]] && CURSOR=$(( vcnt - 1 ))
}

build_cats() {
  CATS=("All")
  local seen="" i c
  for i in $(seq 0 $(( PKG_COUNT - 1 ))); do
    c=$(pkg_field "$i" 5)
    [[ "$seen" == *"|${c}|"* ]] && continue
    seen+="|${c}|"
    CATS+=("$c")
  done
}

# Build flat render list: each entry "hdr:CatName" or "pkg:vi_index"
# Also returns cursor_render (index of CURSOR in render list) via global
build_render() {
  RENDER=()
  CURSOR_RENDER=0
  local vi pcat prev_cat=""
  for vi in $(seq 0 $(( ${#VISIBLE[@]} - 1 ))); do
    pcat=$(pkg_field "${VISIBLE[$vi]}" 5)
    if [[ "$CURRENT_CAT" == "All" && "$pcat" != "$prev_cat" ]]; then
      RENDER+=("hdr:$pcat")
      prev_cat="$pcat"
    fi
    [[ $vi -eq $CURSOR ]] && CURSOR_RENDER=${#RENDER[@]}
    RENDER+=("pkg:$vi")
  done
}

# ── Draw ──────────────────────────────────────────────────────────────────────
_hline() { printf '%0.s-' $(seq 1 "$COLS"); }

draw_header() {
  get_term_size
  move 1 1
  printf "${BG_HDR}${BOLD}${FG_CYN}%-${COLS}s${R}" ""
  move 1 1
  printf "${BG_HDR}${BOLD}  ${FG_BRT}[RishavOS]${FG_CYN}  Homebrew Setup  ${FG_MUTED}|  ${FG_YLW}${#SELECTED[@]} selected${R}"
  move 2 1; clear_line
  printf "  ${FG_CYN}[up/dn]${FG_MUTED} move  ${FG_CYN}[spc]${FG_MUTED} toggle  ${FG_CYN}[a]${FG_MUTED} all  ${FG_CYN}[/]${FG_MUTED} search  ${FG_CYN}[c]${FG_MUTED} category  ${FG_CYN}[enter]${FG_MUTED} install  ${FG_RED}[q]${FG_MUTED} quit${R}"
  move 3 1; printf "${FG_DIM2}"; _hline; printf "${R}"
}

draw_search_bar() {
  move 4 1; clear_line
  local cc ci
  cc=$(cat_color "$CURRENT_CAT"); ci=$(cat_icon "$CURRENT_CAT")
  if $SEARCH_MODE; then
    printf "  ${FG_CYN}${BOLD}search:${R} ${FG_BRT}%s${FG_CYN}|${R}   ${FG_MUTED}[esc] cancel  [enter] done${R}" "$SEARCH_STR"
  else
    printf "  ${FG_MUTED}cat:${R} ${cc}${BOLD}[%s] %s${R}  ${FG_MUTED}|  showing ${FG_WHT}%d${FG_MUTED} pkgs" \
      "$ci" "$CURRENT_CAT" "${#VISIBLE[@]}"
    [[ -n "$SEARCH_STR" ]] && printf "  ${FG_MUTED}|  filter: ${FG_ORG}\"%s\"${R}" "$SEARCH_STR"
    printf "${R}"
  fi
  move 5 1; printf "${FG_DIM2}"; _hline; printf "${R}"
}

draw_pkg_list() {
  get_term_size
  local LIST_TOP=6
  local LIST_BOT=$(( ROWS - 2 ))
  local LIST_H=$(( LIST_BOT - LIST_TOP + 1 ))

  build_render
  local rcount=${#RENDER[@]}

  # Scroll in render-row space so category headers count as rows
  [[ $CURSOR_RENDER -lt $SCROLL_OFFSET ]] && SCROLL_OFFSET=$CURSOR_RENDER
  [[ $CURSOR_RENDER -ge $(( SCROLL_OFFSET + LIST_H )) ]] && SCROLL_OFFSET=$(( CURSOR_RENDER - LIST_H + 1 ))
  [[ $SCROLL_OFFSET -lt 0 ]] && SCROLL_OFFSET=0

  local row=$LIST_TOP ri rtype rval
  local hcc hci vi pkg name iscask brew desc chk badge nw bw dw
  nw=20 bw=26

  for ri in $(seq $SCROLL_OFFSET $(( rcount - 1 ))); do
    [[ $row -gt $LIST_BOT ]] && break
    rtype="${RENDER[$ri]%%:*}"
    rval="${RENDER[$ri]#*:}"

    if [[ "$rtype" == "hdr" ]]; then
      hcc=$(cat_color "$rval"); hci=$(cat_icon "$rval")
      move $row 1; clear_line
      printf "  ${hcc}${BOLD}[%s] -- %s --${R}" "$hci" "$rval"
    else
      vi="$rval"
      pkg="${VISIBLE[$vi]}"
      name=$(pkg_field   "$pkg" 2)
      iscask=$(pkg_field "$pkg" 3)
      brew=$(pkg_field   "$pkg" 1)
      desc=$(pkg_field   "$pkg" 4)

      dw=$(( COLS - nw - bw - 18 ))
      [[ $dw -lt 8 ]] && dw=8
      [[ ${#name} -gt $nw ]] && name="${name:0:$(( nw - 1 ))}~"
      [[ ${#brew} -gt $bw ]] && brew="${brew:0:$(( bw - 1 ))}~"
      [[ ${#desc} -gt $dw ]] && desc="${desc:0:$(( dw - 1 ))}~"

      if is_selected "$pkg"; then
        chk="${FG_CYN}${BOLD}[x]${R}"
      else
        chk="${FG_DIM2}[ ]${R}"
      fi
      [[ "$iscask" == "1" ]] && badge="${FG_PRP}cask${R}" || badge="${FG_GRN} cli${R}"

      move $row 1; clear_line
      if [[ $vi -eq $CURSOR ]]; then
        printf "${BG_SEL2}  %s  ${FG_BRT}${BOLD}%-${nw}s${R}${BG_SEL2}  ${FG_CYN}%-${bw}s${R}${BG_SEL2}  %s  ${FG_SKY}%s${R}" \
          "$chk" "$name" "$brew" "$badge" "$desc"
      else
        printf "  %s  ${FG_WHT}%-${nw}s${R}  ${FG_DIM2}%-${bw}s${R}  %s  ${FG_MUTED}%s${R}" \
          "$chk" "$name" "$brew" "$badge" "$desc"
      fi
    fi
    row=$(( row + 1 ))
  done

  while [[ $row -le $LIST_BOT ]]; do
    move $row 1; clear_line
    row=$(( row + 1 ))
  done
}

draw_footer() {
  get_term_size
  move $(( ROWS - 1 )) 1; printf "${FG_DIM2}"; _hline; printf "${R}"
  move $ROWS 1; clear_line
  if [[ ${#SELECTED[@]} -gt 0 ]]; then
    printf "  ${FG_GRN}${BOLD}>> ${#SELECTED[@]} package(s) ready  ${R}${FG_MUTED}press ${FG_CYN}[enter]${FG_MUTED} to install${R}"
  else
    printf "  ${FG_MUTED}No packages selected -- use ${FG_CYN}[space]${FG_MUTED} to toggle, ${FG_CYN}[a]${FG_MUTED} to select all${R}"
  fi
}

redraw() { draw_header; draw_search_bar; draw_pkg_list; draw_footer; }

# ── Category picker ────────────────────────────────────────────────────────────
pick_category() {
  build_cats
  local cat_cursor=0 i
  for i in $(seq 0 $(( ${#CATS[@]} - 1 ))); do
    [[ "${CATS[$i]}" == "$CURRENT_CAT" ]] && cat_cursor=$i
  done

  local key key2
  while true; do
    get_term_size; clear_screen
    move 1 1
    printf "${BG_HDR}${BOLD}${FG_CYN}%-${COLS}s${R}" "  [RishavOS]  Select Category"
    move 2 1; printf "${FG_MUTED}  [up/dn] move  [enter] select  [c/esc] cancel${R}"
    move 3 1; printf "${FG_DIM2}"; _hline; printf "${R}"

    local c cc ci count j pc
    for i in $(seq 0 $(( ${#CATS[@]} - 1 ))); do
      c="${CATS[$i]}" count=0
      cc=$(cat_color "$c"); ci=$(cat_icon "$c")
      for j in $(seq 0 $(( PKG_COUNT - 1 ))); do
        pc=$(pkg_field "$j" 5)
        [[ "$c" == "All" || "$pc" == "$c" ]] && count=$(( count + 1 ))
      done
      move $(( 4 + i )) 1; clear_line
      if [[ $i -eq $cat_cursor ]]; then
        printf "${BG_SEL2}  ${cc}${BOLD}[%s] %-18s${R}${BG_SEL2}  ${FG_MUTED}(%d packages)${R}" \
          "$ci" "$c" "$count"
      else
        printf "  ${cc}[%s] %-18s${FG_MUTED}  (%d packages)${R}" "$ci" "$c" "$count"
      fi
    done

    IFS= read -rsk1 key
    if [[ "$key" == $'\x1b' ]]; then
      IFS= read -rsk2 -t0.1 key2 || key2=""
      case "$key2" in
        '[A') [[ $cat_cursor -gt 0 ]] && cat_cursor=$(( cat_cursor - 1 )) ;;
        '[B') [[ $cat_cursor -lt $(( ${#CATS[@]} - 1 )) ]] && cat_cursor=$(( cat_cursor + 1 )) ;;
        '')   return ;;  # bare Esc
      esac
    elif [[ "$key" == $'\n' || "$key" == $'\r' ]]; then
      CURRENT_CAT="${CATS[$cat_cursor]}"
      CURSOR=0; SCROLL_OFFSET=0; build_visible; return
    elif [[ "$key" == 'c' || "$key" == 'C' ]]; then
      return
    fi
  done
}

# ── Install ────────────────────────────────────────────────────────────────────
run_install() {
  [[ ${#SELECTED[@]} -eq 0 ]] && return
  tput rmcups 2>/dev/null || true
  show_cursor

  local total=${#SELECTED[@]} done_count=0
  local RESULTS=()
  local idx formula name iscask cmd brew_tmp exit_code

  local C_RST=$'\e[0m' C_BOLD=$'\e[1m' C_DIM=$'\e[2m'
  local C_CYN=$'\e[1;36m' C_WHT=$'\e[1;97m' C_YLW=$'\e[1;33m'
  local C_GRN=$'\e[1;32m' C_RED=$'\e[1;31m' C_MUTED=$'\e[38;5;244m'
  local BAR='━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
  local DIV='──────────────────────────────────────────────────'

  for idx in "${SELECTED[@]}"; do
    formula=$(pkg_field "$idx" 1)
    name=$(pkg_field    "$idx" 2)
    iscask=$(pkg_field  "$idx" 3)
    done_count=$(( done_count + 1 ))

    [[ "$iscask" == "1" ]] && cmd="brew install --cask $formula" || cmd="brew install $formula"

    clear
    printf '%s\n'   "${C_CYN}${BAR}${C_RST}"
    printf '  %s  %s\n' "${C_WHT}${C_BOLD}RishavOS${C_RST}" "${C_CYN}Installing ${done_count} of ${total}${C_RST}"
    printf '%s\n\n' "${C_CYN}${BAR}${C_RST}"
    printf '  %s  %s\n'   "${C_YLW}Package:${C_RST}" "$name"
    printf '  %s  %s\n\n' "${C_YLW}Command:${C_RST}" "$cmd"
    printf '%s\n\n' "${C_CYN}${DIV}${C_RST}"

    brew_tmp=$(mktemp /tmp/rishavos_brew.XXXXXX)

    # Stream brew output live, capture for status check
    eval "$cmd" 2>&1 | tee "$brew_tmp" | while IFS= read -r line; do
      printf '  %s\n' "$line"
    done
    exit_code=${pipestatus[1]}

    printf '\n%s\n' "${C_CYN}${DIV}${C_RST}"

    if [[ $exit_code -eq 0 ]]; then
      printf '  %s  %s\n\n' "${C_GRN}✓${C_RST}" "${C_BOLD}Installed successfully${C_RST}"
      RESULTS+=("ok|$name")
    elif grep -qi "already installed\|already exists\|is already" "$brew_tmp"; then
      printf '  %s  %s\n\n' "${C_YLW}⚠${C_RST}" "Already installed"
      RESULTS+=("skip|$name")
    else
      printf '  %s  %s\n\n' "${C_RED}✗${C_RST}" "Failed"
      RESULTS+=("fail|$name")
    fi
    rm -f "$brew_tmp"

    if [[ $done_count -lt $total ]]; then
      printf '  %spress any key for next, or wait 3s...%s\n' "$C_DIM" "$C_RST"
      read -rsk1 -t 3 _ || true
    fi
  done

  # ── Summary ──────────────────────────────────────────────────────────────
  clear
  printf '%s\n'   "${C_CYN}${BAR}${C_RST}"
  printf '  %s\n' "${C_WHT}${C_BOLD}RishavOS  ${C_CYN}All Done${C_RST}"
  printf '%s\n\n' "${C_CYN}${BAR}${C_RST}"

  local ok=0 skip=0 fail=0 result lbl status
  for result in "${RESULTS[@]}"; do
    status="${result%%|*}"; lbl="${result#*|}"
    case "$status" in
      ok)   printf '  %s  %s\n'       "${C_GRN}✓${C_RST}" "$lbl"; ok=$(( ok + 1 ))     ;;
      skip) printf '  %s  %s %s\n'    "${C_YLW}⚠${C_RST}" "$lbl" "${C_DIM}(already installed)${C_RST}"; skip=$(( skip + 1 )) ;;
      fail) printf '  %s  %s %s\n'    "${C_RED}✗${C_RST}" "$lbl" "${C_DIM}(failed)${C_RST}";            fail=$(( fail + 1 )) ;;
    esac
  done

  printf '\n%s\n  ' "${C_CYN}${BAR}${C_RST}"
  [[ $ok   -gt 0 ]] && printf '%s✓ %d installed%s   '    "$C_GRN" "$ok"   "$C_RST"
  [[ $skip -gt 0 ]] && printf '%s⚠ %d already had%s   '  "$C_YLW" "$skip" "$C_RST"
  [[ $fail -gt 0 ]] && printf '%s✗ %d failed%s'           "$C_RED" "$fail" "$C_RST"
  printf '\n%s\n\n' "${C_CYN}${BAR}${C_RST}"

  printf '  %sPress any key to return to the menu...%s\n' "$C_DIM" "$C_RST"
  read -rsk1 _ || true

  tput smcups 2>/dev/null || true
  hide_cursor
  SELECTED=(); build_visible; CURSOR=0; SCROLL_OFFSET=0
}

# ── Main ──────────────────────────────────────────────────────────────────────
main() {
  command -v brew >/dev/null 2>&1 || { printf "Error: Homebrew not found.\n" >&2; exit 1; }

  tput smcups 2>/dev/null || true
  hide_cursor; clear_screen
  build_visible; redraw

  local key key2
  while true; do
    IFS= read -rsk1 key

    if $SEARCH_MODE; then
      case "$key" in
        $'\x1b')
          IFS= read -rsk2 -t0.05 key2 || key2=""
          if [[ -z "$key2" ]]; then
            SEARCH_MODE=false; SEARCH_STR=""; build_visible; CURSOR=0; SCROLL_OFFSET=0
          fi ;;
        $'\x7f'|$'\b')
          SEARCH_STR="${SEARCH_STR%?}"; build_visible; CURSOR=0; SCROLL_OFFSET=0 ;;
        $'\n'|$'\r')
          SEARCH_MODE=false; build_visible; CURSOR=0; SCROLL_OFFSET=0 ;;
        *)
          SEARCH_STR="${SEARCH_STR}${key}"; build_visible; CURSOR=0; SCROLL_OFFSET=0 ;;
      esac
      redraw; continue
    fi

    case "$key" in
      $'\x1b')
        IFS= read -rsk2 -t0.1 key2 || key2=""
        case "$key2" in
          '[A') [[ $CURSOR -gt 0 ]] && CURSOR=$(( CURSOR - 1 )) ;;
          '[B') [[ $CURSOR -lt $(( ${#VISIBLE[@]} - 1 )) ]] && CURSOR=$(( CURSOR + 1 )) ;;
          '[5') CURSOR=$(( CURSOR > 10 ? CURSOR - 10 : 0 )) ;;
          '[6')
            local m=$(( ${#VISIBLE[@]} - 1 ))
            CURSOR=$(( CURSOR + 10 < m ? CURSOR + 10 : m )) ;;
        esac ;;
      ' ')
        [[ ${#VISIBLE[@]} -gt 0 ]] && toggle_select "${VISIBLE[$CURSOR]}" ;;
      'a'|'A')
        if all_visible_selected; then deselect_all_visible; else select_all_visible; fi ;;
      '/')  SEARCH_MODE=true ;;
      'c'|'C') pick_category; clear_screen ;;
      $'\n'|$'\r') run_install; clear_screen ;;
      'q'|'Q')
        clear_screen; show_cursor
        tput rmcups 2>/dev/null || true
        printf "\n  ${FG_CYN}${BOLD}RishavOS:${R} Bye!\n\n"
        exit 0 ;;
    esac
    redraw
  done
}

main
