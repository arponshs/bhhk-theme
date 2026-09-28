#!/data/data/com.termux/files/usr/bin/bash
# BHHK THEME — Installer

CYAN='\033[0;36m'; PINK='\033[0;35m'; GREEN='\033[0;32m'
WHITE='\033[1;37m'; RED='\033[0;31m'; DIM='\033[2m'; NC='\033[0m'

clear
echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║${NC}  ${PINK}🎨  BHHK THEME ENGINE v3.0  🎨${NC}      ${CYAN}║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════╝${NC}"
echo ""

echo -e "${CYAN}▸${NC} ${WHITE}Installing dependencies...${NC}"
for pkg in bash coreutils curl; do
    if dpkg -l "$pkg" > /dev/null 2>&1; then
        echo -e "  ${DIM}✓ ${pkg}${NC}"
    else
        pkg install -y "$pkg" > /dev/null 2>&1
        echo -e "  ${GREEN}✓${NC} ${WHITE}${pkg}${NC}"
    fi
done
echo ""

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MAIN="$SCRIPT_DIR/theme.sh"

if [ ! -f "$MAIN" ]; then
    echo -e "${RED}✗ theme.sh not found${NC}"
    exit 1
fi

chmod +x "$MAIN"

if [ -z "$PREFIX" ]; then
    echo -e "${RED}✗ Termux not detected${NC}"
    exit 1
fi

cat > "$PREFIX/bin/bhhk-theme" << EOF
#!/data/data/com.termux/files/usr/bin/bash
exec bash "$MAIN" "\$@"
EOF

chmod +x "$PREFIX/bin/bhhk-theme"
echo -e "${GREEN}✓${NC} ${WHITE}Command registered:${NC} ${PINK}bhhk-theme${NC}"
echo ""

echo -e "${CYAN}  ╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║${NC}  ${GREEN}✓ INSTALLED${NC}                          ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}                                      ${CYAN}║${NC}"
echo -e "${CYAN}  ║${NC}  ${WHITE}Run:${NC} ${PINK}bhhk-theme${NC}                      ${CYAN}║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════╝${NC}"
echo ""

printf "  ${DIM}Launch now? [Y/n]: ${NC}"
read -r ans
case "$ans" in
    n|N) echo -e "\n  ${DIM}Run 'bhhk-theme' anytime.${NC}\n";;
    *) bash "$MAIN";;
esac