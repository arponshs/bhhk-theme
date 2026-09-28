#!/data/data/com.termux/files/usr/bin/bash
# ============================================================
# BHHK THEME ENGINE v2.0
# Personal Animated Termux Themes
# ============================================================

# Directories
THEME_DIR="$HOME/.bhhk_theme"
USER_THEME="$THEME_DIR/user.theme"
CONFIG="$THEME_DIR/config.json"
STATS="$THEME_DIR/stats.json"
mkdir -p "$THEME_DIR"

# ============================================================
# CORE COLORS (default fallback)
# ============================================================
CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'
YELLOW='\033[1;33m'; RED='\033[0;31m'; WHITE='\033[1;37m'
BLUE='\033[0;34m'; DIM='\033[2m'; BOLD='\033[1m'; NC='\033[0m'

# ============================================================
# LOAD USER THEME
# ============================================================
load_user_theme() {
    if [ -f "$USER_THEME" ]; then
        # shellcheck disable=SC1090
        source "$USER_THEME"
    fi
    # Defaults if not set
    : "${USER_NAME:=BHHK TEAMS}"
    : "${THEME_NAME:=Default}"
    : "${PRIMARY:=$CYAN}"
    : "${SECONDARY:=$PINK}"
    : "${ACCENT:=$GREEN}"
    : "${HIGHLIGHT:=$YELLOW}"
    : "${BORDER_CHAR:=═}"
    : "${ICON:=⚡}"
    : "${TAGLINE:=Termux User}"
    : "${ANIM_STYLE:=wave}"
}

load_user_theme

# ============================================================
# TERMINAL HELPERS
# ============================================================
clr() { clear; }
pause() { printf "\n  ${DIM}Press ENTER...${NC}"; read -r; }

hide_cursor() { printf '\033[?25l'; }
show_cursor() { printf '\033[?25h'; }

# ============================================================
# CENTER TEXT
# ============================================================
center_text() {
    local text="$1"
    local width="${2:-44}"
    local len=${#text}
    local pad=$(( (width - len) / 2 ))
    [ $pad -lt 0 ] && pad=0
    printf "%*s%s%*s" "$pad" "" "$text" "$((width - len - pad))" ""
}

# ============================================================
# ANIMATIONS
# ============================================================
anim_typewriter() {
    local text="$1"
    local color="${2:-$WHITE}"
    for ((i=0; i<${#text}; i++)); do
        printf "${color}${text:$i:1}${NC}"
        sleep 0.03
    done
    echo ""
}

anim_wave() {
    local text="$1"
    local color1="$2"
    local color2="$3"
    local wave="▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
    for ((i=0; i<${#text}; i++)); do
        printf "${color1}${text:$i:1}${NC}"
        sleep 0.02
    done
    echo ""
    for ((j=0; j<3; j++)); do
        local line=""
        for ((i=0; i<24; i++)); do
            local idx=$(( (i + j * 3) % ${#wave} ))
            line="${line}${wave:$idx:1}"
        done
        printf "  ${color2}${line}${NC}\r"
        sleep 0.08
    done
    echo ""
}

anim_glitch() {
    local text="$1"
    local color1="$2"
    local color2="$3"
    for ((r=0; r<3; r++)); do
        printf "\r  "
        for ((i=0; i<${#text}; i++)); do
            if [ $((RANDOM % 4)) -eq 0 ]; then
                printf "${color2}${text:$i:1}${NC}"
            else
                printf "${color1}${text:$i:1}${NC}"
            fi
        done
        sleep 0.05
    done
    printf "\r  ${color1}${text}${NC}\n"
}

anim_rainbow() {
    local text="$1"
    local colors=("$RED" "$YELLOW" "$GREEN" "$CYAN" "$BLUE" "$PINK")
    for ((i=0; i<${#text}; i++)); do
        printf "${colors[$((i % 6))]}${text:$i:1}${NC}"
        sleep 0.03
    done
    echo ""
}

anim_matrix_fill() {
    local text="$1"
    local color="$2"
    local len=${#text}
    local chars="!@#$%^&*()_+-=[]{}|;:,.<>?"
    for ((step=0; step<len; step++)); do
        printf "\r  "
        for ((i=0; i<len; i++)); do
            if [ $i -lt $step ]; then
                printf "${color}${text:$i:1}${NC}"
            elif [ $i -eq $step ]; then
                local rc=$((RANDOM % ${#chars}))
                printf "${WHITE}${chars:$rc:1}${NC}"
            else
                printf " "
            fi
        done
        sleep 0.04
    done
    printf "\r  ${color}${text}${NC}\n"
}

# ============================================================
# SHOW THEME (Main animation)
# ============================================================
show_theme() {
    clr
    hide_cursor

    local w=42

    # Top border with wave
    echo ""
    printf "  ${PRIMARY}"
    for ((i=0; i<w; i++)); do
        printf "${BORDER_CHAR}"
        sleep 0.008
    done
    printf "${NC}\n"

    # Blank line
    echo ""

    # Icon + Greeting
    printf "  ${ACCENT}${ICON}${NC}  "
    anim_typewriter "Welcome back," "$DIM"
    echo ""
    printf "  ${SECONDARY}${BOLD}"
    anim_matrix_fill "$USER_NAME" "$SECONDARY"
    printf "${NC}"

    # Tagline
    printf "  ${DIM}"
    anim_typewriter "$TAGLINE" "$DIM"

    echo ""

    # Bottom border
    printf "  ${PRIMARY}"
    for ((i=0; i<w; i++)); do
        printf "${BORDER_CHAR}"
        sleep 0.008
    done
    printf "${NC}\n"

    echo ""

    # Wave animation below
    local wave="▁▂▃▄▅▆▇█▇▆▅▄▃▂▁"
    for ((k=0; k<10; k++)); do
        local line=""
        for ((i=0; i<w; i++)); do
            local idx=$(( (i * 2 + k * 3) % ${#wave} ))
            line="${line}${wave:$idx:1}"
        done
        printf "\r  ${ACCENT}${line}${NC}"
        sleep 0.1
    done
    echo ""
    echo ""

    # Status line
    printf "  ${PRIMARY}▸${NC} ${WHITE}Theme:${NC} ${SECONDARY}${THEME_NAME}${NC}\n"
    printf "  ${PRIMARY}▸${NC} ${WHITE}Style:${NC} ${SECONDARY}${ANIM_STYLE}${NC}\n"
    printf "  ${PRIMARY}▸${NC} ${WHITE}Time:${NC}  ${SECONDARY}$(date '+%H:%M:%S')${NC}\n"
    printf "  ${PRIMARY}▸${NC} ${WHITE}Date:${NC}  ${SECONDARY}$(date '+%A, %d %B %Y')${NC}\n"
    echo ""
    printf "  ${DIM}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${BORDER_CHAR}${NC} "
    printf "${ACCENT}Ready${NC}\n"
    echo ""

    show_cursor
}

# ============================================================
# ANIMATED BANNER (small)
# ============================================================
show_banner() {
    clr
    echo ""
    printf "  ${PRIMARY}╔"
    for ((i=0; i<40; i++)); do printf "═"; done
    printf "╗${NC}\n"
    printf "  ${PRIMARY}║${NC}  ${ACCENT}${ICON}${NC}  ${PINK}${BOLD}B H H K   T H E M E${NC}  ${ACCENT}${ICON}${NC}              ${PRIMARY}║${NC}\n"
    printf "  ${PRIMARY}║${NC}      ${DIM}Personal Theme Engine v2.0${NC}          ${PRIMARY}║${NC}\n"
    printf "  ${PRIMARY}╚"
    for ((i=0; i<40; i++)); do printf "═"; done
    printf "╝${NC}\n"
    echo ""
}

# ============================================================
# COLOR PICKER
# ============================================================
color_options() {
    echo "  ${PINK}[1]${NC}  Cyan        ${DIM}(default)${NC}"
    echo "  ${PINK}[2]${NC}  Magenta/Pink"
    echo "  ${PINK}[3]${NC}  Green"
    echo "  ${PINK}[4]${NC}  Yellow"
    echo "  ${PINK}[5]${NC}  Red"
    echo "  ${PINK}[6]${NC}  Blue"
    echo "  ${PINK}[7]${NC}  White"
    echo "  ${PINK}[8]${NC}  Bright Cyan"
    echo "  ${PINK}[9]${NC}  Bright Magenta"
    echo "  ${PINK}[10]${NC} Bright Green"
    echo "  ${PINK}[11]${NC} Bright Yellow"
    echo "  ${PINK}[12]${NC} Bright Red"
}

pick_color() {
    color_options
    printf "  ${PINK}➜${NC} "
    read -r choice
    case "$choice" in
        1) echo '\033[0;36m';;
        2) echo '\033[0;35m';;
        3) echo '\033[0;32m';;
        4) echo '\033[1;33m';;
        5) echo '\033[0;31m';;
        6) echo '\033[0;34m';;
        7) echo '\033[1;37m';;
        8) echo '\033[1;36m';;
        9) echo '\033[1;35m';;
        10) echo '\033[1;32m';;
        11) echo '\033[1;33m';;
        12) echo '\033[1;31m';;
        *) echo '\033[0;36m';;
    esac
}

# ============================================================
# CREATE / EDIT THEME
# ============================================================
create_theme() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}⚙️  Create Your Custom Theme${NC}"
    echo ""
    echo -e "  ${DIM}─── Step 1: Personal Info ───${NC}"
    echo ""

    printf "  ${PINK}➜${NC} Your name: "
    read -r name
    [ -z "$name" ] && name="ARPON"

    printf "  ${PINK}➜${NC} Tagline (press ENTER to skip): "
    read -r tagline
    [ -z "$tagline" ] && tagline="Termux User"

    printf "  ${PINK}➜${NC} Theme name: "
    read -r theme_name
    [ -z "$theme_name" ] && theme_name="My Theme"

    printf "  ${PINK}➜${NC} Icon (emoji/symbol, default ⚡): "
    read -r icon
    [ -z "$icon" ] && icon="⚡"

    echo ""
    echo -e "  ${DIM}─── Step 2: Primary Color ───${NC}"
    local primary=$(pick_color)

    echo ""
    echo -e "  ${DIM}─── Step 3: Secondary Color ───${NC}"
    local secondary=$(pick_color)

    echo ""
    echo -e "  ${DIM}─── Step 4: Accent Color ───${NC}"
    local accent=$(pick_color)

    echo ""
    echo -e "  ${DIM}─── Step 5: Border Style ───${NC}"
    echo "  ${PINK}[1]${NC}  ═  (double)"
    echo "  ${PINK}[2]${NC}  ─  (single)"
    echo "  ${PINK}[3]${NC}  ▓  (block)"
    echo "  ${PINK}[4]${NC}  ✦  (star)"
    echo "  ${PINK}[5]${NC}  ★  (filled star)"
    printf "  ${PINK}➜${NC} "
    read -r bch
    case "$bch" in
        1) border_char="═";;
        2) border_char="─";;
        3) border_char="▓";;
        4) border_char="✦";;
        5) border_char="★";;
        *) border_char="═";;
    esac

    echo ""
    echo -e "  ${DIM}─── Step 6: Animation Style ───${NC}"
    echo "  ${PINK}[1]${NC}  Wave        ${DIM}(smooth wave)${NC}"
    echo "  ${PINK}[2]${NC}  Typewriter  ${DIM}(character-by-character)${NC}"
    echo "  ${PINK}[3]${NC}  Glitch      ${DIM}(cyberpunk)${NC}"
    echo "  ${PINK}[4]${NC}  Rainbow     ${DIM}(multi-color)${NC}"
    echo "  ${PINK}[5]${NC}  Matrix      ${DIM}(filling effect)${NC}"
    printf "  ${PINK}➜${NC} "
    read -r anim
    case "$anim" in
        1) anim_style="wave";;
        2) anim_style="typewriter";;
        3) anim_style="glitch";;
        4) anim_style="rainbow";;
        5) anim_style="matrix";;
        *) anim_style="wave";;
    esac

    # Save theme file
    cat > "$USER_THEME" << EOF
# BHHK Theme - Generated $(date)
USER_NAME="$name"
TAGLINE="$tagline"
THEME_NAME="$theme_name"
ICON="$icon"
PRIMARY='$primary'
SECONDARY='$secondary'
ACCENT='$accent'
HIGHLIGHT='\033[1;33m'
BORDER_CHAR="$border_char"
ANIM_STYLE="$anim_style"
EOF

    echo ""
    echo -e "  ${GREEN}✓ Theme saved!${NC}"
    echo -e "  ${DIM}File: $USER_THEME${NC}"
    echo ""

    # Preview
    printf "  ${DIM}Loading preview...${NC}"
    sleep 0.5
    load_user_theme
    show_theme

    pause
}

# ============================================================
# PREVIEW CURRENT THEME
# ============================================================
preview_theme() {
    load_user_theme
    show_theme
    pause
}

# ============================================================
# CHANGE ANIMATION STYLE
# ============================================================
change_animation() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}🎬 Change Animation Style${NC}"
    echo ""
    echo -e "  ${DIM}Current: ${ACCENT}${ANIM_STYLE}${NC}"
    echo ""
    echo "  ${PINK}[1]${NC}  Wave"
    echo "  ${PINK}[2]${NC}  Typewriter"
    echo "  ${PINK}[3]${NC}  Glitch"
    echo "  ${PINK}[4]${NC}  Rainbow"
    echo "  ${PINK}[5]${NC}  Matrix"
    echo ""
    printf "  ${PINK}➜${NC} "
    read -r anim
    case "$anim" in
        1) new_style="wave";;
        2) new_style="typewriter";;
        3) new_style="glitch";;
        4) new_style="rainbow";;
        5) new_style="matrix";;
        *) new_style="$ANIM_STYLE";;
    esac

    # Update file
    if [ -f "$USER_THEME" ]; then
        sed -i "s/^ANIM_STYLE=.*/ANIM_STYLE=\"$new_style\"/" "$USER_THEME"
    fi

    echo ""
    echo -e "  ${GREEN}✓ Animation changed to: ${new_style}${NC}"
    sleep 1
    load_user_theme

    # Preview the new style
    clr
    echo ""
    echo -e "  ${DIM}Preview:${NC}"
    echo ""
    case "$new_style" in
        typewriter) anim_typewriter "  ✨ $USER_NAME ✨" "$SECONDARY";;
        glitch) anim_glitch "  $USER_NAME" "$PRIMARY" "$SECONDARY";;
        rainbow) echo -n "  "; anim_rainbow "$USER_NAME";;
        matrix) anim_matrix_fill "  $USER_NAME" "$SECONDARY";;
        *) anim_wave "$USER_NAME" "$PRIMARY" "$SECONDARY";;
    esac

    pause
}

# ============================================================
# CHANGE COLORS
# ============================================================
change_colors() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}🎨 Change Theme Colors${NC}"
    echo ""

    echo -e "  ${DIM}─── Primary Color ───${NC}"
    local new_primary=$(pick_color)

    echo ""
    echo -e "  ${DIM}─── Secondary Color ───${NC}"
    local new_secondary=$(pick_color)

    echo ""
    echo -e "  ${DIM}─── Accent Color ───${NC}"
    local new_accent=$(pick_color)

    if [ -f "$USER_THEME" ]; then
        sed -i "s|^PRIMARY=.*|PRIMARY='$new_primary'|" "$USER_THEME"
        sed -i "s|^SECONDARY=.*|SECONDARY='$new_secondary'|" "$USER_THEME"
        sed -i "s|^ACCENT=.*|ACCENT='$new_accent'|" "$USER_THEME"
    fi

    echo ""
    echo -e "  ${GREEN}✓ Colors updated!${NC}"
    sleep 1
    load_user_theme
    show_theme
    pause
}

# ============================================================
# EDIT NAME
# ============================================================
edit_name() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}👤 Edit Your Name${NC}"
    echo ""
    echo -e "  ${DIM}Current: ${ACCENT}$USER_NAME${NC}"
    echo ""
    printf "  ${PINK}➜${NC} New name: "
    read -r new_name
    [ -z "$new_name" ] && { echo -e "  ${RED}✗ No change${NC}"; pause; return; }

    printf "  ${PINK}➜${NC} New tagline (ENTER to skip): "
    read -r new_tag
    [ -z "$new_tag" ] && new_tag="$TAGLINE"

    if [ -f "$USER_THEME" ]; then
        sed -i "s|^USER_NAME=.*|USER_NAME=\"$new_name\"|" "$USER_THEME"
        sed -i "s|^TAGLINE=.*|TAGLINE=\"$new_tag\"|" "$USER_THEME"
    fi

    echo ""
    echo -e "  ${GREEN}✓ Updated!${NC}"
    sleep 1
    load_user_theme

    # Nice preview animation
    clr
    echo ""
    case "$ANIM_STYLE" in
        typewriter) anim_typewriter "  $USER_NAME" "$SECONDARY";;
        glitch) anim_glitch "  $USER_NAME" "$PRIMARY" "$SECONDARY";;
        rainbow) echo -n "  "; anim_rainbow "$USER_NAME";;
        matrix) anim_matrix_fill "  $USER_NAME" "$SECONDARY";;
        *) anim_wave "$USER_NAME" "$PRIMARY" "$SECONDARY";;
    esac

    pause
}

# ============================================================
# VIEW CURRENT THEME FILE
# ============================================================
view_config() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}📄 Theme Configuration${NC}"
    echo ""
    if [ -f "$USER_THEME" ]; then
        echo -e "  ${DIM}Path: $USER_THEME${NC}"
        echo ""
        echo -e "  ${PRIMARY}┌──────────────────────────────────────┐${NC}"
        cat "$USER_THEME" | while IFS= read -r line; do
            [ -z "$line" ] && continue
            case "$line" in
                \#*) echo -e "  ${PRIMARY}│${NC} ${DIM}$line${NC}";;
                *) echo -e "  ${PRIMARY}│${NC} ${WHITE}$line${NC}";;
            esac
        done
        echo -e "  ${PRIMARY}└──────────────────────────────────────┘${NC}"
    else
        echo -e "  ${RED}✗ No theme yet. Create one first.${NC}"
    fi
    pause
}

# ============================================================
# RESET THEME
# ============================================================
reset_theme() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}🔄 Reset Theme${NC}"
    echo ""
    printf "  ${RED}⚠ Delete current theme? [y/N]: ${NC}"
    read -r ans
    case "$ans" in
        y|Y)
            rm -f "$USER_THEME"
            echo -e "  ${GREEN}✓ Theme deleted${NC}"
            sleep 1
            load_user_theme
            ;;
        *) echo -e "  ${DIM}Cancelled${NC}";;
    esac
    pause
}

# ============================================================
# EXPORT TO BASH RC
# ============================================================
export_to_bashrc() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}📤 Auto-Show on Termux Startup${NC}"
    echo ""

    local bashrc="$HOME/.bashrc"
    local marker="# BHHK THEME AUTO-START"

    # Check if already added
    if grep -q "$marker" "$bashrc" 2>/dev/null; then
        echo -e "  ${YELLOW}⚠ Already added. Remove?${NC}"
        printf "  ${PINK}➜${NC} [y/N]: "
        read -r remove
        case "$remove" in
            y|Y)
                # Remove
                grep -v "$marker" "$bashrc" | grep -v "bhhk-theme" > "$bashrc.tmp"
                mv "$bashrc.tmp" "$bashrc"
                echo -e "  ${GREEN}✓ Removed from .bashrc${NC}"
                ;;
            *) echo -e "  ${DIM}Cancelled${NC}";;
        esac
    else
        echo -e "  ${DIM}Add BHHK theme to Termux startup?${NC}"
        printf "  ${PINK}➜${NC} [y/N]: "
        read -r add
        case "$add" in
            y|Y)
                echo "" >> "$bashrc"
                echo "$marker" >> "$bashrc"
                echo "bhhk-theme show" >> "$bashrc"
                echo -e "  ${GREEN}✓ Added! Termux restart হলেই theme দেখাবে${NC}"
                ;;
            *) echo -e "  ${DIM}Cancelled${NC}";;
        esac
    fi
    pause
}

# ============================================================
# PRESET THEMES
# ============================================================
apply_preset() {
    show_banner
    echo -e "  ${SECONDARY}${BOLD}🎁 Preset Themes${NC}"
    echo ""

    echo "  ${PINK}[1]${NC}  ${CYAN}Ocean Blue${NC}"
    echo "  ${PINK}[2]${NC}  ${PINK}Neon Cyber${NC}"
    echo "  ${PINK}[3]${NC}  ${GREEN}Matrix Green${NC}"
    echo "  ${PINK}[4]${NC}  ${YELLOW}Sunset Orange${NC}"
    echo "  ${PINK}[5]${NC}  ${RED}Blood Moon${NC}"
    echo "  ${PINK}[6]${NC}  ${WHITE}Arctic White${NC}"
    echo "  ${PINK}[7]${NC}  ${BLUE}Midnight Purple${NC}"
    echo "  ${PINK}[8]${NC}  ${GREEN}Hacker Green${NC} ${DIM}(pure terminal)${NC}"
    echo "  ${PINK}[0]${NC}  Back"
    echo ""
    printf "  ${PINK}➜${NC} "
    read -r p

    local name="$USER_NAME"
    local tag="$TAGLINE"

    case "$p" in
        1)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Ocean Blue Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Ocean Blue"
ICON="🌊"
PRIMARY='\033[0;34m'
SECONDARY='\033[0;36m'
ACCENT='\033[1;36m'
BORDER_CHAR="═"
ANIM_STYLE="wave"
EOF
            ;;
        2)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Neon Cyber Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Neon Cyber"
ICON="⚡"
PRIMARY='\033[0;35m'
SECONDARY='\033[1;36m'
ACCENT='\033[1;35m'
BORDER_CHAR="▰"
ANIM_STYLE="glitch"
EOF
            ;;
        3)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Matrix Green Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Matrix"
ICON="🟢"
PRIMARY='\033[0;32m'
SECONDARY='\033[1;32m'
ACCENT='\033[1;32m'
BORDER_CHAR="▮"
ANIM_STYLE="matrix"
EOF
            ;;
        4)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Sunset Orange Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Sunset"
ICON="🌅"
PRIMARY='\033[1;33m'
SECONDARY='\033[0;31m'
ACCENT='\033[1;31m'
BORDER_CHAR="▓"
ANIM_STYLE="rainbow"
EOF
            ;;
        5)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Blood Moon Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Blood Moon"
ICON="🌑"
PRIMARY='\033[0;31m'
SECONDARY='\033[1;31m'
ACCENT='\033[0;31m'
BORDER_CHAR="☾"
ANIM_STYLE="glitch"
EOF
            ;;
        6)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Arctic White Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Arctic"
ICON="❄"
PRIMARY='\033[1;37m'
SECONDARY='\033[0;36m'
ACCENT='\033[1;36m'
BORDER_CHAR="─"
ANIM_STYLE="typewriter"
EOF
            ;;
        7)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Midnight Purple Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Midnight"
ICON="🌌"
PRIMARY='\033[0;34m'
SECONDARY='\033[0;35m'
ACCENT='\033[1;35m'
BORDER_CHAR="✦"
ANIM_STYLE="wave"
EOF
            ;;
        8)
            cat > "$USER_THEME" << EOF
# BHHK Theme - Hacker Green Preset
USER_NAME="$name"
TAGLINE="$tag"
THEME_NAME="Terminal"
ICON=">_"
PRIMARY='\033[0;32m'
SECONDARY='\033[1;32m'
ACCENT='\033[1;32m'
BORDER_CHAR="─"
ANIM_STYLE="matrix"
EOF
            ;;
        0) return;;
        *) return;;
    esac

    echo ""
    echo -e "  ${GREEN}✓ Preset applied!${NC}"
    sleep 0.8
    load_user_theme
    show_theme
    pause
}

# ============================================================
# MAIN MENU
# ============================================================
main_menu() {
    while true; do
        show_banner

        echo -e "  ${PRIMARY}╭──────────────────────────────────────────╮${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[1]${NC} ✨  Create Custom Theme              ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[2]${NC} 🎬  Change Animation Style           ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[3]${NC} 🎨  Change Colors                    ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[4]${NC} 👤  Edit Your Name                   ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[5]${NC} 🎁  Preset Themes                    ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[6]${NC} 👁️   Preview Theme                    ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[7]${NC} 📄  View Configuration               ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[8]${NC} 📤  Auto-Start on Termux             ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[9]${NC} 🔄  Reset Theme                      ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}│${NC}  ${PINK}[0]${NC} 🚪  Exit                             ${PRIMARY}│${NC}"
        echo -e "  ${PRIMARY}╰──────────────────────────────────────────╯${NC}"
        echo ""
        echo -e "  ${DIM}Current: ${ACCENT}$THEME_NAME${NC} ${DIM}| User: ${ACCENT}$USER_NAME${NC}"
        echo ""
        printf "  ${PINK}➜${NC} ${WHITE}Select:${NC} "
        read -r c
        case "$c" in
            1) create_theme;;
            2) change_animation;;
            3) change_colors;;
            4) edit_name;;
            5) apply_preset;;
            6) preview_theme;;
            7) view_config;;
            8) export_to_bashrc;;
            9) reset_theme;;
            0) clear; echo -e "  ${PINK}⚡ Goodbye!${NC}"; echo ""; exit 0;;
            *) ;;
        esac
    done
}

# ============================================================
# ENTRY
# ============================================================
if [ "$1" = "show" ]; then
    show_theme
    exit 0
fi

# Boot animation
clear
echo ""
printf "  ${CYAN}"
for ((i=0; i<42; i++)); do printf "═"; sleep 0.008; done
printf "${NC}\n"
echo ""
printf "  ${PINK}"
anim_matrix_fill "  🎨 BHHK THEME ENGINE v2.0" "$PINK"
printf "${NC}"
echo ""
printf "  ${DIM}"
anim_typewriter "  Personal Animated Termux Themes" "$DIM"
echo ""
printf "  ${CYAN}"
for ((i=0; i<42; i++)); do printf "═"; sleep 0.008; done
printf "${NC}\n"
echo ""

sleep 0.6
main_menu