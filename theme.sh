#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK THEME ENGINE v3.0
# Custom Animated Termux Themes
# ============================================================

THEME_DIR="$HOME/.bhhk_theme"
THEME_FILE="$THEME_DIR/theme.conf"
mkdir -p "$THEME_DIR"

# Terminal escape
ESC=$'\033'
RST="${ESC}[0m"
BLD="${ESC}[1m"
DIM="${ESC}[2m"
ITL="${ESC}[3m"
UND="${ESC}[4m"

# Raw colors
BLACK="${ESC}[0;30m";   RED="${ESC}[0;31m";   GREEN="${ESC}[0;32m"
YELLOW="${ESC}[0;33m";  BLUE="${ESC}[0;34m";  MAGENTA="${ESC}[0;35m"
CYAN="${ESC}[0;36m";    WHITE="${ESC}[0;37m"
BRED="${ESC}[1;31m";    BGREEN="${ESC}[1;32m"; BYELLOW="${ESC}[1;33m"
BBLUE="${ESC}[1;34m";   BMAGENTA="${ESC}[1;35m"; BCYAN="${ESC}[1;36m"
BWHITE="${ESC}[1;37m"

# ============================================================
# DEFAULT THEME (if none)
# ============================================================
DEF_NAME="User"
DEF_TAGLINE=""
DEF_PRIMARY="$CYAN"
DEF_SECONDARY="$MAGENTA"
DEF_ACCENT="$GREEN"
DEF_BORDER="═"
DEF_ICON="⚡"
DEF_ANIM="wave"
DEF_SHOW_TIME="yes"
DEF_SHOW_DATE="yes"
DEF_SHOW_IP="no"
DEF_SHOW_USER="yes"
DEF_SHOW_BATTERY="no"
DEF_SHOW_WEATHER="no"
DEF_SHOW_QUOTE="no"
DEF_SHOW_UPTIME="no"
DEF_SHOW_STATS="yes"
DEF_QUOTE="Stay focused"

# ============================================================
# LOAD THEME
# ============================================================
load_theme() {
    if [ -f "$THEME_FILE" ]; then
        # shellcheck disable=SC1090
        source "$THEME_FILE"
    fi
    : "${U_NAME:=$DEF_NAME}"
    : "${U_TAGLINE:=$DEF_TAGLINE}"
    : "${T_PRIMARY:=$DEF_PRIMARY}"
    : "${T_SECONDARY:=$DEF_SECONDARY}"
    : "${T_ACCENT:=$DEF_ACCENT}"
    : "${T_BORDER:=$DEF_BORDER}"
    : "${T_ICON:=$DEF_ICON}"
    : "${T_ANIM:=$DEF_ANIM}"
    : "${S_TIME:=$DEF_SHOW_TIME}"
    : "${S_DATE:=$DEF_SHOW_DATE}"
    : "${S_IP:=$DEF_SHOW_IP}"
    : "${S_USER:=$DEF_SHOW_USER}"
    : "${S_BATTERY:=$DEF_SHOW_BATTERY}"
    : "${S_WEATHER:=$DEF_SHOW_WEATHER}"
    : "${S_QUOTE:=$DEF_SHOW_QUOTE}"
    : "${S_UPTIME:=$DEF_SHOW_UPTIME}"
    : "${S_STATS:=$DEF_SHOW_STATS}"
    : "${U_QUOTE:=$DEF_QUOTE}"
}
load_theme

# ============================================================
# HELPERS
# ============================================================
clr() { clear; }
pause_read() { printf "\n  ${DIM}ENTER to continue...${RST}"; read -r; }
hide_cursor() { printf "${ESC}[?25l"; }
show_cursor() { printf "${ESC}[?25h"; }

# ============================================================
# TYPEWRITER
# ============================================================
tw() {
    local text="$1"
    local color="${2:-$WHITE}"
    local speed="${3:-0.015}"
    for ((i=0; i<${#text}; i++)); do
        printf "${color}${text:$i:1}${RST}"
        sleep "$speed"
    done
}

# ============================================================
# GLITCH EFFECT
# ============================================================
glitch() {
    local text="$1"
    local c1="${2:-$CYAN}"
    local c2="${3:-$MAGENTA}"
    local chars="!@#\$%&*"
    for ((r=0; r<4; r++)); do
        printf "\r  "
        for ((i=0; i<${#text}; i++)); do
            local ch="${text:$i:1}"
            if [ "$ch" = " " ]; then
                printf " "
            elif [ $((RANDOM % 3)) -eq 0 ]; then
                local ri=$((RANDOM % ${#chars}))
                printf "${c2}${chars:$ri:1}${RST}"
            else
                printf "${c1}${ch}${RST}"
            fi
        done
        sleep 0.04
    done
    printf "\r  ${c1}${text}${RST}\n"
}

# ============================================================
# RAINBOW
# ============================================================
rainbow() {
    local text="$1"
    local colors=("$RED" "$YELLOW" "$GREEN" "$CYAN" "$BLUE" "$MAGENTA")
    for ((i=0; i<${#text}; i++)); do
        printf "${colors[$((i % 6))]}${text:$i:1}${RST}"
        sleep 0.02
    done
    echo ""
}

# ============================================================
# WAVE ANIMATION
# ============================================================
wave_anim() {
    local width="${1:-40}"
    local frames=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █ ▇ ▆ ▅ ▄ ▃ ▂)
    local n=${#frames[@]}
    for ((step=0; step<n*2; step++)); do
        printf "\r  ${T_ACCENT}"
        for ((i=0; i<width; i++)); do
            local idx=$(( (i + step) % n ))
            printf "${frames[$idx]}"
        done
        printf "${RST}"
        sleep 0.05
    done
    printf "\r  "
    for ((i=0; i<width; i++)); do printf " "; done
    printf "\r"
}

# ============================================================
# MATRIX FILL
# ============================================================
matrix_fill() {
    local text="$1"
    local color="${2:-$T_SECONDARY}"
    local chars="01アイウエオカキクケコサシスセソ"
    for ((step=0; step<=${#text}; step++)); do
        printf "\r  "
        for ((i=0; i<${#text}; i++)); do
            if [ $i -lt $step ]; then
                printf "${color}${text:$i:1}${RST}"
            elif [ $i -eq $step ]; then
                local ri=$((RANDOM % ${#chars}))
                printf "${WHITE}${chars:$ri:1}${RST}"
            else
                printf " "
            fi
        done
        sleep 0.03
    done
    printf "\r  ${color}${text}${RST}\n"
}

# ============================================================
# DISPLAY NAME with animation
# ============================================================
display_name() {
    local name="$1"
    case "$T_ANIM" in
        typewriter) tw "  $name" "$T_SECONDARY" 0.04; echo "";;
        glitch) glitch "  $name" "$T_SECONDARY" "$T_PRIMARY";;
        rainbow) printf "  "; rainbow "$name";;
        matrix) matrix_fill "  $name" "$T_SECONDARY";;
        *) printf "  ${T_SECONDARY}${BLD}${name}${RST}\n";;
    esac
}

# ============================================================
# SYSTEM INFO COLLECTORS
# ============================================================
get_time() { date '+%H:%M:%S'; }
get_date() { date '+%A, %d %B %Y'; }
get_ip() {
    local ip
    ip=$(curl -s --max-time 3 https://api.ipify.org 2>/dev/null)
    [ -z "$ip" ] && ip=$(ifconfig 2>/dev/null | grep 'inet ' | grep -v 127.0.0.1 | head -1 | awk '{print $2}')
    echo "${ip:-Offline}"
}
get_battery() {
    if command -v termux-battery-status > /dev/null 2>&1; then
        local lvl=$(termux-battery-status 2>/dev/null | grep '"percentage"' | grep -oE '[0-9]+')
        echo "${lvl:-?}%"
    else
        echo "N/A"
    fi
}
get_weather() {
    local w=$(curl -s --max-time 3 "wttr.in/?format=%C+%t" 2>/dev/null | tr -d '\n')
    echo "${w:-N/A}"
}
get_uptime() {
    local up=$(uptime 2>/dev/null | grep -oE 'up [^,]+' | sed 's/up //')
    echo "${up:-N/A}"
}
get_stats() {
    local total=$(find "$HOME" -maxdepth 3 -type f 2>/dev/null | wc -l)
    local pkgs=$(ls "$PREFIX/bin" 2>/dev/null | wc -l)
    echo "$total files | $pkgs pkgs"
}

# ============================================================
# SHOW THEME (main view)
# ============================================================
show_theme() {
    clr
    hide_cursor

    local W=42

    # Top border
    printf "  ${T_PRIMARY}"
    for ((i=0; i<W; i++)); do printf "${T_BORDER}"; done
    printf "${RST}\n"

    echo ""
    # Icon + Greeting
    if [ "$S_USER" = "yes" ]; then
        printf "  ${T_ACCENT}${T_ICON}${RST}  ${DIM}Welcome back${RST}\n"
        echo ""
        display_name "$U_NAME"
        if [ -n "$U_TAGLINE" ]; then
            printf "  ${DIM}${ITL}$U_TAGLINE${RST}\n"
        fi
    else
        printf "  ${T_ACCENT}${T_ICON}${RST}  ${T_SECONDARY}${BLD}BHHK TERMUX${RST}\n"
    fi

    echo ""
    # Bottom border
    printf "  ${T_PRIMARY}"
    for ((i=0; i<W; i++)); do printf "${T_BORDER}"; done
    printf "${RST}\n"
    echo ""

    # Animated wave (only for wave style)
    [ "$T_ANIM" = "wave" ] && wave_anim $W

    # Info section
    local info_rows=()

    [ "$S_TIME" = "yes" ] && info_rows+=("🕐|Time|$(get_time)")
    [ "$S_DATE" = "yes" ] && info_rows+=("📅|Date|$(get_date)")
    [ "$S_IP" = "yes" ] && info_rows+=("🌐|IP|$(get_ip)")
    [ "$S_BATTERY" = "yes" ] && info_rows+=("🔋|Battery|$(get_battery)")
    [ "$S_WEATHER" = "yes" ] && info_rows+=("☁️|Weather|$(get_weather)")
    [ "$S_UPTIME" = "yes" ] && info_rows+=("⏱️|Uptime|$(get_uptime)")
    [ "$S_STATS" = "yes" ] && info_rows+=("📊|Storage|$(get_stats)")

    if [ ${#info_rows[@]} -gt 0 ]; then
        for row in "${info_rows[@]}"; do
            IFS='|' read -r icon label value <<< "$row"
            printf "  ${T_PRIMARY}▸${RST} ${icon}  ${DIM}%-8s${RST} ${T_ACCENT}%s${RST}\n" "${label}" "${value}"
        done
        echo ""
    fi

    # Quote
    if [ "$S_QUOTE" = "yes" ] && [ -n "$U_QUOTE" ]; then
        printf "  ${T_PRIMARY}${T_BORDER}${T_BORDER}${RST}  ${ITL}${DIM}\"%s\"${RST}\n" "$U_QUOTE"
        echo ""
    fi

    show_cursor
}

# ============================================================
# LIST OF COLORS
# ============================================================
list_colors() {
    echo -e "  ${PINK}[1]${RST}  Cyan       ${CYAN}████████${RST}"
    echo -e "  ${PINK}[2]${RST}  Magenta    ${MAGENTA}████████${RST}"
    echo -e "  ${PINK}[3]${RST}  Green      ${GREEN}████████${RST}"
    echo -e "  ${PINK}[4]${RST}  Yellow     ${YELLOW}████████${RST}"
    echo -e "  ${PINK}[5]${RST}  Red        ${RED}████████${RST}"
    echo -e "  ${PINK}[6]${RST}  Blue       ${BLUE}████████${RST}"
    echo -e "  ${PINK}[7]${RST}  White      ${WHITE}████████${RST}"
    echo -e "  ${PINK}[8]${RST}  B.Cyan     ${BCYAN}████████${RST}"
    echo -e "  ${PINK}[9]${RST}  B.Magenta  ${BMAGENTA}████████${RST}"
    echo -e "  ${PINK}[10]${RST} B.Green    ${BGREEN}████████${RST}"
    echo -e "  ${PINK}[11]${RST} B.Yellow   ${BYELLOW}████████${RST}"
    echo -e "  ${PINK}[12]${RST} B.Red      ${BRED}████████${RST}"
    echo -e "  ${PINK}[13]${RST} B.Blue     ${BBLUE}████████${RST}"
    echo -e "  ${PINK}[14]${RST} B.White    ${BWHITE}████████${RST}"
}

pick_color() {
    list_colors
    printf "  ${PINK}➜${RST} "
    read -r c
    case "$c" in
        1) echo "$CYAN";; 2) echo "$MAGENTA";; 3) echo "$GREEN";;
        4) echo "$YELLOW";; 5) echo "$RED";; 6) echo "$BLUE";;
        7) echo "$WHITE";; 8) echo "$BCYAN";; 9) echo "$BMAGENTA";;
        10) echo "$BGREEN";; 11) echo "$BYELLOW";; 12) echo "$BRED";;
        13) echo "$BBLUE";; 14) echo "$BWHITE";;
        *) echo "$CYAN";;
    esac
}

# ============================================================
# WRITE THEME FILE
# ============================================================
save_theme() {
    cat > "$THEME_FILE" << EOF
# BHHK Theme — $(date)
U_NAME="$U_NAME"
U_TAGLINE="$U_TAGLINE"
U_QUOTE="$U_QUOTE"
T_PRIMARY='$T_PRIMARY'
T_SECONDARY='$T_SECONDARY'
T_ACCENT='$T_ACCENT'
T_BORDER="$T_BORDER"
T_ICON="$T_ICON"
T_ANIM="$T_ANIM"
S_TIME="$S_TIME"
S_DATE="$S_DATE"
S_IP="$S_IP"
S_USER="$S_USER"
S_BATTERY="$S_BATTERY"
S_WEATHER="$S_WEATHER"
S_QUOTE="$S_QUOTE"
S_UPTIME="$S_UPTIME"
S_STATS="$S_STATS"
EOF
}

# ============================================================
# CREATE FULL THEME (wizard)
# ============================================================
create_theme() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ CREATE THEME ══════${RST}"
    echo ""

    # Step 1: Name
    printf "  ${PINK}➜${RST} Your name: "
    read -r U_NAME
    [ -z "$U_NAME" ] && U_NAME="User"

    printf "  ${PINK}➜${RST} Tagline (optional): "
    read -r U_TAGLINE

    printf "  ${PINK}➜${RST} Your quote (optional): "
    read -r U_QUOTE
    [ -z "$U_QUOTE" ] && U_QUOTE="Stay focused"

    # Step 2: Icon
    echo ""
    echo -e "  ${DIM}Pick icon:${RST}"
    echo -e "  ${PINK}[1]${RST} ⚡   ${PINK}[2]${RST} 🔥   ${PINK}[3]${RST} 🌊   ${PINK}[4]${RST} 🎯"
    echo -e "  ${PINK}[5]${RST} 💀   ${PINK}[6]${RST} 👑   ${PINK}[7]${RST} 🚀   ${PINK}[8]${RST} 💎"
    echo -e "  ${PINK}[9]${RST} 🌌   ${PINK}[10]${RST} ⭐   ${PINK}[11]${RST} 🐉   ${PINK}[12]${RST} >_"
    printf "  ${PINK}➜${RST} "
    read -r ic
    case "$ic" in
        1) T_ICON="⚡";; 2) T_ICON="🔥";; 3) T_ICON="🌊";; 4) T_ICON="🎯";;
        5) T_ICON="💀";; 6) T_ICON="👑";; 7) T_ICON="🚀";; 8) T_ICON="💎";;
        9) T_ICON="🌌";; 10) T_ICON="⭐";; 11) T_ICON="🐉";; 12) T_ICON=">_";;
        *) T_ICON="⚡";;
    esac

    # Step 3: Primary color
    echo ""
    echo -e "  ${DIM}─── Primary color ───${RST}"
    T_PRIMARY=$(pick_color)

    # Step 4: Secondary color
    echo ""
    echo -e "  ${DIM}─── Secondary color (name text) ───${RST}"
    T_SECONDARY=$(pick_color)

    # Step 5: Accent color
    echo ""
    echo -e "  ${DIM}─── Accent color (info values) ───${RST}"
    T_ACCENT=$(pick_color)

    # Step 6: Border
    echo ""
    echo -e "  ${DIM}─── Border style ───${RST}"
    echo -e "  ${PINK}[1]${RST} ═     ${PINK}[2]${RST} ─     ${PINK}[3]${RST} ▓     ${PINK}[4]${RST} ✦"
    echo -e "  ${PINK}[5]${RST} ★     ${PINK}[6]${RST} ▪     ${PINK}[7]${RST} ●     ${PINK}[8]${RST} ◆"
    printf "  ${PINK}➜${RST} "
    read -r bc
    case "$bc" in
        1) T_BORDER="═";; 2) T_BORDER="─";; 3) T_BORDER="▓";; 4) T_BORDER="✦";;
        5) T_BORDER="★";; 6) T_BORDER="▪";; 7) T_BORDER="●";; 8) T_BORDER="◆";;
        *) T_BORDER="═";;
    esac

    # Step 7: Animation
    echo ""
    echo -e "  ${DIM}─── Animation style ───${RST}"
    echo -e "  ${PINK}[1]${RST} Static      ${DIM}(no anim)${RST}"
    echo -e "  ${PINK}[2]${RST} Typewriter  ${DIM}(char-by-char)${RST}"
    echo -e "  ${PINK}[3]${RST} Glitch      ${DIM}(cyber)${RST}"
    echo -e "  ${PINK}[4]${RST} Rainbow     ${DIM}(multi-color)${RST}"
    echo -e "  ${PINK}[5]${RST} Matrix      ${DIM}(fill effect)${RST}"
    echo -e "  ${PINK}[6]${RST} Wave        ${DIM}(wave bar)${RST}"
    printf "  ${PINK}➜${RST} "
    read -r an
    case "$an" in
        1) T_ANIM="static";; 2) T_ANIM="typewriter";; 3) T_ANIM="glitch";;
        4) T_ANIM="rainbow";; 5) T_ANIM="matrix";; 6) T_ANIM="wave";;
        *) T_ANIM="typewriter";;
    esac

    # Step 8: What to show
    echo ""
    echo -e "  ${DIM}─── What to display ───${RST}"
    toggle_field "Show Time" S_TIME
    toggle_field "Show Date" S_DATE
    toggle_field "Show Your Name" S_USER
    toggle_field "Show IP Address" S_IP
    toggle_field "Show Battery" S_BATTERY
    toggle_field "Show Weather" S_WEATHER
    toggle_field "Show Uptime" S_UPTIME
    toggle_field "Show Storage Stats" S_STATS
    toggle_field "Show Quote" S_QUOTE

    save_theme
    load_theme

    echo ""
    echo -e "  ${GREEN}✓ Theme saved!${RST}"
    sleep 0.6

    # Preview
    show_theme
    pause_read
}

toggle_field() {
    local label="$1"
    local var_name="$2"
    local current="${!var_name}"
    printf "  ${PINK}➜${RST} %-22s [${current}] enable? (y/n): " "$label"
    read -r ans
    case "$ans" in
        y|Y) printf -v "$var_name" "yes";;
        n|N) printf -v "$var_name" "no";;
        *) ;;
    esac
}

# ============================================================
# TOGGLE DISPLAY ITEMS
# ============================================================
manage_display() {
    while true; do
        clr
        echo ""
        echo -e "  ${T_PRIMARY}══════ DISPLAY SETTINGS ══════${RST}"
        echo ""
        echo -e "  ${PINK}[1]${RST} Time              [${T_ACCENT}$S_TIME${RST}]"
        echo -e "  ${PINK}[2]${RST} Date              [${T_ACCENT}$S_DATE${RST}]"
        echo -e "  ${PINK}[3]${RST} Your Name         [${T_ACCENT}$S_USER${RST}]"
        echo -e "  ${PINK}[4]${RST} IP Address        [${T_ACCENT}$S_IP${RST}]"
        echo -e "  ${PINK}[5]${RST} Battery           [${T_ACCENT}$S_BATTERY${RST}]"
        echo -e "  ${PINK}[6]${RST} Weather           [${T_ACCENT}$S_WEATHER${RST}]"
        echo -e "  ${PINK}[7]${RST} Uptime            [${T_ACCENT}$S_UPTIME${RST}]"
        echo -e "  ${PINK}[8]${RST} Storage Stats     [${T_ACCENT}$S_STATS${RST}]"
        echo -e "  ${PINK}[9]${RST} Quote             [${T_ACCENT}$S_QUOTE${RST}]"
        echo -e "  ${PINK}[0]${RST} Back"
        echo ""
        printf "  ${PINK}➜${RST} Toggle: "
        read -r c
        case "$c" in
            1) [ "$S_TIME" = "yes" ] && S_TIME="no" || S_TIME="yes";;
            2) [ "$S_DATE" = "yes" ] && S_DATE="no" || S_DATE="yes";;
            3) [ "$S_USER" = "yes" ] && S_USER="no" || S_USER="yes";;
            4) [ "$S_IP" = "yes" ] && S_IP="no" || S_IP="yes";;
            5) [ "$S_BATTERY" = "yes" ] && S_BATTERY="no" || S_BATTERY="yes";;
            6) [ "$S_WEATHER" = "yes" ] && S_WEATHER="no" || S_WEATHER="yes";;
            7) [ "$S_UPTIME" = "yes" ] && S_UPTIME="no" || S_UPTIME="yes";;
            8) [ "$S_STATS" = "yes" ] && S_STATS="no" || S_STATS="yes";;
            9) [ "$S_QUOTE" = "yes" ] && S_QUOTE="no" || S_QUOTE="yes";;
            0) save_theme; return;;
        esac
        save_theme
    done
}

# ============================================================
# CHANGE ANIMATION
# ============================================================
change_anim() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ ANIMATION ══════${RST}"
    echo ""
    echo -e "  ${DIM}Current: ${T_ACCENT}$T_ANIM${RST}"
    echo ""
    echo -e "  ${PINK}[1]${RST} Static       ${DIM}(no animation)${RST}"
    echo -e "  ${PINK}[2]${RST} Typewriter"
    echo -e "  ${PINK}[3]${RST} Glitch"
    echo -e "  ${PINK}[4]${RST} Rainbow"
    echo -e "  ${PINK}[5]${RST} Matrix"
    echo -e "  ${PINK}[6]${RST} Wave"
    echo -e "  ${PINK}[0]${RST} Back"
    echo ""
    printf "  ${PINK}➜${RST} "
    read -r a
    case "$a" in
        1) T_ANIM="static";; 2) T_ANIM="typewriter";; 3) T_ANIM="glitch";;
        4) T_ANIM="rainbow";; 5) T_ANIM="matrix";; 6) T_ANIM="wave";;
        0) return;;
    esac
    save_theme

    # Live preview
    clr
    echo ""
    echo -e "  ${DIM}Preview:${RST}"
    echo ""
    display_name "  $U_NAME"
    sleep 0.5
    pause_read
}

# ============================================================
# CHANGE COLORS
# ============================================================
change_colors() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ COLORS ══════${RST}"
    echo ""
    echo -e "  ${DIM}─── Primary color ───${RST}"
    T_PRIMARY=$(pick_color)
    echo ""
    echo -e "  ${DIM}─── Secondary color ───${RST}"
    T_SECONDARY=$(pick_color)
    echo ""
    echo -e "  ${DIM}─── Accent color ───${RST}"
    T_ACCENT=$(pick_color)
    save_theme
    load_theme

    # Preview
    clr
    echo ""
    echo -e "  ${DIM}Preview:${RST}"
    echo ""
    printf "  ${T_PRIMARY}════════════════════════════════════════${RST}\n"
    printf "  ${T_ACCENT}${T_ICON}${RST}  ${DIM}Welcome back${RST}\n"
    echo ""
    printf "  ${T_SECONDARY}${BLD}$U_NAME${RST}\n"
    printf "  ${T_PRIMARY}════════════════════════════════════════${RST}\n"
    pause_read
}

# ============================================================
# EDIT NAME / TAGLINE
# ============================================================
edit_identity() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ IDENTITY ══════${RST}"
    echo ""
    echo -e "  ${DIM}Current: ${T_ACCENT}$U_NAME${RST}"
    echo ""
    printf "  ${PINK}➜${RST} New name [ENTER to keep]: "
    read -r new_name
    [ -n "$new_name" ] && U_NAME="$new_name"

    printf "  ${PINK}➜${RST} New tagline: "
    read -r new_tag
    [ -n "$new_tag" ] && U_TAGLINE="$new_tag"

    printf "  ${PINK}➜${RST} New quote: "
    read -r new_q
    [ -n "$new_q" ] && U_QUOTE="$new_q"

    save_theme
    load_theme
    echo ""
    echo -e "  ${GREEN}✓ Saved${RST}"
    sleep 0.4
    clr
    display_name "  $U_NAME"
    pause_read
}

# ============================================================
# PRESET THEMES
# ============================================================
apply_preset() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ PRESET THEMES ══════${RST}"
    echo ""
    echo -e "  ${PINK}[1]${RST}  ${BCYAN}Cyber Blue${RST}      ${DIM}— cool neon${RST}"
    echo -e "  ${PINK}[2]${RST}  ${BMAGENTA}Neon Pink${RST}       ${DIM}— vibrant${RST}"
    echo -e "  ${PINK}[3]${RST}  ${BGREEN}Matrix Green${RST}     ${DIM}— terminal${RST}"
    echo -e "  ${PINK}[4]${RST}  ${BYELLOW}Sunset Gold${RST}      ${DIM}— warm${RST}"
    echo -e "  ${PINK}[5]${RST}  ${BRED}Blood Moon${RST}       ${DIM}— dark red${RST}"
    echo -e "  ${PINK}[6]${RST}  ${BWHITE}Arctic Snow${RST}      ${DIM}— clean${RST}"
    echo -e "  ${PINK}[7]${RST}  ${BBLUE}Midnight${RST}         ${DIM}— deep blue${RST}"
    echo -e "  ${PINK}[8]${RST}  ${BCYAN}Ocean Wave${RST}       ${DIM}— fluid${RST}"
    echo -e "  ${PINK}[0]${RST}  Back"
    echo ""
    printf "  ${PINK}➜${RST} "
    read -r p

    case "$p" in
        1) T_PRIMARY="$BCYAN"; T_SECONDARY="$BBLUE"; T_ACCENT="$BCYAN"; T_BORDER="═"; T_ANIM="typewriter"; T_ICON="💎";;
        2) T_PRIMARY="$BMAGENTA"; T_SECONDARY="$BCYAN"; T_ACCENT="$BMAGENTA"; T_BORDER="▰"; T_ANIM="glitch"; T_ICON="⚡";;
        3) T_PRIMARY="$BGREEN"; T_SECONDARY="$BGREEN"; T_ACCENT="$BGREEN"; T_BORDER="▮"; T_ANIM="matrix"; T_ICON=">_";;
        4) T_PRIMARY="$BYELLOW"; T_SECONDARY="$BRED"; T_ACCENT="$BYELLOW"; T_BORDER="▓"; T_ANIM="wave"; T_ICON="🔥";;
        5) T_PRIMARY="$BRED"; T_SECONDARY="$BRED"; T_ACCENT="$BRED"; T_BORDER="☾"; T_ANIM="glitch"; T_ICON="💀";;
        6) T_PRIMARY="$BWHITE"; T_SECONDARY="$BCYAN"; T_ACCENT="$BWHITE"; T_BORDER="─"; T_ANIM="typewriter"; T_ICON="❄";;
        7) T_PRIMARY="$BBLUE"; T_SECONDARY="$BMAGENTA"; T_ACCENT="$BBLUE"; T_BORDER="✦"; T_ANIM="wave"; T_ICON="🌌";;
        8) T_PRIMARY="$BCYAN"; T_SECONDARY="$BCYAN"; T_ACCENT="$BGREEN"; T_BORDER="═"; T_ANIM="wave"; T_ICON="🌊";;
        0) return;;
        *) return;;
    esac

    save_theme
    load_theme
    echo ""
    echo -e "  ${GREEN}✓ Applied!${RST}"
    sleep 0.4
    show_theme
    pause_read
}

# ============================================================
# AUTO START
# ============================================================
auto_start() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ AUTO-START ══════${RST}"
    echo ""
    local bashrc="$HOME/.bashrc"
    local marker="# BHHK-THEME-AUTOSTART"

    if grep -q "$marker" "$bashrc" 2>/dev/null; then
        echo -e "  ${YELLOW}⚠ Already enabled${RST}"
        printf "  ${PINK}➜${RST} Remove? (y/n): "
        read -r rm
        case "$rm" in
            y|Y)
                grep -v "$marker" "$bashrc" | grep -v "bhhk-theme show" > "$bashrc.tmp"
                mv "$bashrc.tmp" "$bashrc"
                echo -e "  ${GREEN}✓ Removed${RST}"
                ;;
        esac
    else
        echo -e "  ${DIM}Show theme automatically when Termux opens?${RST}"
        printf "  ${PINK}➜${RST} Enable? (y/n): "
        read -r en
        case "$en" in
            y|Y)
                echo "" >> "$bashrc"
                echo "$marker" >> "$bashrc"
                echo "bhhk-theme show 2>/dev/null" >> "$bashrc"
                echo -e "  ${GREEN}✓ Enabled!${RST}"
                echo -e "  ${DIM}Restart Termux to see effect${RST}"
                ;;
            *) echo -e "  ${DIM}Cancelled${RST}";;
        esac
    fi
    pause_read
}

# ============================================================
# RESET
# ============================================================
reset_theme() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ RESET ══════${RST}"
    echo ""
    printf "  ${RED}⚠ Delete current theme? (y/n): ${RST}"
    read -r a
    case "$a" in
        y|Y)
            rm -f "$THEME_FILE"
            echo -e "  ${GREEN}✓ Deleted${RST}"
            sleep 0.6
            unset U_NAME U_TAGLINE U_QUOTE T_PRIMARY T_SECONDARY T_ACCENT T_BORDER T_ICON T_ANIM
            unset S_TIME S_DATE S_IP S_USER S_BATTERY S_WEATHER S_QUOTE S_UPTIME S_STATS
            load_theme
            ;;
        *) echo -e "  ${DIM}Cancelled${RST}";;
    esac
    pause_read
}

# ============================================================
# VIEW CONFIG FILE
# ============================================================
view_config() {
    clr
    echo ""
    echo -e "  ${T_PRIMARY}══════ CONFIG FILE ══════${RST}"
    echo ""
    if [ -f "$THEME_FILE" ]; then
        echo -e "  ${DIM}$THEME_FILE${RST}"
        echo ""
        while IFS= read -r line; do
            [ -z "$line" ] && continue
            case "$line" in
                \#*) echo -e "  ${DIM}$line${RST}";;
                *) echo -e "  ${T_PRIMARY}▸${RST} ${T_ACCENT}$line${RST}";;
            esac
        done < "$THEME_FILE"
    else
        echo -e "  ${DIM}No theme saved yet${RST}"
    fi
    pause_read
}

# ============================================================
# MAIN MENU
# ============================================================
show_menu() {
    clr
    echo ""
    printf "  ${T_PRIMARY}"
    for ((i=0; i<42; i++)); do printf "${T_BORDER}"; done
    printf "${RST}\n"
    printf "  ${T_PRIMARY}${T_BORDER}${RST}  ${T_ACCENT}${T_ICON}${RST}  ${T_SECONDARY}${BLD}B H H K   T H E M E${RST}\n"
    printf "  ${T_PRIMARY}${T_BORDER}${RST}  ${DIM}Custom Animated Themes v3.0${RST}\n"
    printf "  ${T_PRIMARY}"
    for ((i=0; i<42; i++)); do printf "${T_BORDER}"; done
    printf "${RST}\n"
    echo ""
    echo -e "  ${PINK}[1]${RST}  ✨  Create New Theme"
    echo -e "  ${PINK}[2]${RST}  🎬  Change Animation"
    echo -e "  ${PINK}[3]${RST}  🎨  Change Colors"
    echo -e "  ${PINK}[4]${RST}  👤  Edit Name / Tagline"
    echo -e "  ${PINK}[5]${RST}  📊  Display Settings"
    echo -e "  ${PINK}[6]${RST}  🎁  Preset Themes"
    echo -e "  ${PINK}[7]${RST}  👁️   Preview Theme"
    echo -e "  ${PINK}[8]${RST}  📄  View Config File"
    echo -e "  ${PINK}[9]${RST}  📤  Enable Auto-Start"
    echo -e "  ${PINK}[10]${RST} 🔄  Reset Theme"
    echo -e "  ${PINK}[0]${RST}  🚪  Exit"
    echo ""
    printf "  ${T_PRIMARY}${T_BORDER}${T_BORDER}${RST}  ${DIM}$U_NAME${RST}"
    echo ""
    printf "  ${PINK}➜${RST} "
    read -r c
    case "$c" in
        1) create_theme;;
        2) change_anim;;
        3) change_colors;;
        4) edit_identity;;
        5) manage_display;;
        6) apply_preset;;
        7) show_theme; pause_read;;
        8) view_config;;
        9) auto_start;;
        10) reset_theme;;
        0) clr; show_cursor; exit 0;;
        *) ;;
    esac
}

# ============================================================
# ENTRY
# ============================================================
if [ "$1" = "show" ]; then
    show_theme
    exit 0
fi

main_loop() {
    while true; do
        show_menu
    done
}
main_loop