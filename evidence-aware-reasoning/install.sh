#!/usr/bin/env bash

# Global Auto-Installer for Evidence-Aware Reasoning (EAR) System Prompt
# Supports: Gemini / Antigravity, Claude Code, Cursor, Codex

set -e

RAW_BASE_URL="https://raw.githubusercontent.com/HaoNgo232/evidence-aware-reasoning/main"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" 2>/dev/null || echo "." )" && pwd )"
LOCAL_PROMPT="$SCRIPT_DIR/ear.md"

get_prompt_file() {
    local target_path="$1"
    if [ -f "$LOCAL_PROMPT" ]; then
        cp "$LOCAL_PROMPT" "$target_path"
    else
        curl -sSL "$RAW_BASE_URL/ear.md" -o "$target_path"
    fi
}

install_gemini() {
    local gemini_dir="$HOME/.gemini"
    mkdir -p "$gemini_dir"
    get_prompt_file "$gemini_dir/ear.md"
    local gemini_md="$gemini_dir/GEMINI.md"
    touch "$gemini_md"
    
    sed -i '/@evidence-aware-reasoning\.md/d' "$gemini_md" 2>/dev/null || true
    
    if ! grep -qF "@ear.md" "$gemini_md"; then
        TEMP_FILE=$(mktemp)
        echo "@ear.md" > "$TEMP_FILE"
        cat "$gemini_md" >> "$TEMP_FILE"
        mv "$TEMP_FILE" "$gemini_md"
        echo "[+] Gemini / Antigravity: Injected @ear.md at top of $gemini_md"
    else
        echo "[=] Gemini / Antigravity: @ear.md already present in $gemini_md"
    fi
}

install_claude() {
    local claude_dir="$HOME/.claude"
    mkdir -p "$claude_dir"
    get_prompt_file "$claude_dir/ear.md"
    local claude_md="$claude_dir/CLAUDE.md"
    touch "$claude_md"
    
    if ! grep -qF "@ear.md" "$claude_md"; then
        TEMP_FILE=$(mktemp)
        echo "@ear.md" > "$TEMP_FILE"
        cat "$claude_md" >> "$TEMP_FILE"
        mv "$TEMP_FILE" "$claude_md"
        echo "[+] Claude Code: Injected @ear.md at top of $claude_md"
    else
        echo "[=] Claude Code: @ear.md already present in $claude_md"
    fi
}

install_cursor() {
    local cursor_rules="$HOME/.cursorrules"
    get_prompt_file "$HOME/.ear.md"
    touch "$cursor_rules"
    if ! grep -qF "@ear.md" "$cursor_rules" 2>/dev/null; then
        TEMP_FILE=$(mktemp)
        echo "@ear.md" > "$TEMP_FILE"
        cat "$cursor_rules" >> "$TEMP_FILE"
        mv "$TEMP_FILE" "$cursor_rules"
        echo "[+] Cursor: Injected @ear.md into $cursor_rules"
    else
        echo "[=] Cursor: @ear.md already present in $cursor_rules"
    fi
}

install_codex() {
    local codex_dir="$HOME/.codex"
    mkdir -p "$codex_dir"
    get_prompt_file "$codex_dir/ear.md"
    local codex_md="$codex_dir/CODEX.md"
    touch "$codex_md"
    
    if ! grep -qF "@ear.md" "$codex_md"; then
        TEMP_FILE=$(mktemp)
        echo "@ear.md" > "$TEMP_FILE"
        cat "$codex_md" >> "$TEMP_FILE"
        mv "$TEMP_FILE" "$codex_md"
        echo "[+] Codex: Injected @ear.md at top of $codex_md"
    else
        echo "[=] Codex: @ear.md already present in $codex_md"
    fi
}

TARGET_AGENT="$1"

# Interactive TUI Menu if no argument is passed
if [ -z "$TARGET_AGENT" ]; then
    if [ -t 0 ]; then
        echo "======================================================"
        echo " Select AI Coding Agent for Evidence-Aware Reasoning  "
        echo "======================================================"
        echo "  1) All Agents (Gemini, Claude Code, Cursor, Codex)"
        echo "  2) Gemini / Antigravity (~/.gemini/GEMINI.md)"
        echo "  3) Claude Code (~/.claude/CLAUDE.md)"
        echo "  4) Cursor (~/.cursorrules)"
        echo "  5) Codex (~/.codex/CODEX.md)"
        echo "  6) Exit"
        echo "======================================================"
        read -p "Select an option [1-6] (Default: 1): " CHOICE || CHOICE="1"
        
        case "$CHOICE" in
            1|"") TARGET_AGENT="all" ;;
            2)    TARGET_AGENT="gemini" ;;
            3)    TARGET_AGENT="claude" ;;
            4)    TARGET_AGENT="cursor" ;;
            5)    TARGET_AGENT="codex" ;;
            6)    echo "Installation cancelled."; exit 0 ;;
            *)    echo "Invalid option. Exiting."; exit 1 ;;
        esac
    elif [ -c /dev/tty ] && exec < /dev/tty 2>/dev/null; then
        echo "======================================================"
        echo " Select AI Coding Agent for Evidence-Aware Reasoning  "
        echo "======================================================"
        echo "  1) All Agents (Gemini, Claude Code, Cursor, Codex)"
        echo "  2) Gemini / Antigravity (~/.gemini/GEMINI.md)"
        echo "  3) Claude Code (~/.claude/CLAUDE.md)"
        echo "  4) Cursor (~/.cursorrules)"
        echo "  5) Codex (~/.codex/CODEX.md)"
        echo "  6) Exit"
        echo "======================================================"
        read -p "Select an option [1-6] (Default: 1): " CHOICE || CHOICE="1"
        
        case "$CHOICE" in
            1|"") TARGET_AGENT="all" ;;
            2)    TARGET_AGENT="gemini" ;;
            3)    TARGET_AGENT="claude" ;;
            4)    TARGET_AGENT="cursor" ;;
            5)    TARGET_AGENT="codex" ;;
            6)    echo "Installation cancelled."; exit 0 ;;
            *)    echo "Invalid option. Exiting."; exit 1 ;;
        esac
    else
        TARGET_AGENT="all"
    fi
fi

echo ""
echo "======================================================"
echo " Installing Evidence-Aware Reasoning (EAR) Globally "
echo " Target: ${TARGET_AGENT^^} "
echo "======================================================"

case "$TARGET_AGENT" in
    gemini)
        install_gemini
        ;;
    claude)
        install_claude
        ;;
    cursor)
        install_cursor
        ;;
    codex)
        install_codex
        ;;
    all)
        install_gemini
        install_claude
        install_cursor
        install_codex
        ;;
    *)
        echo "Error: Unknown agent '$TARGET_AGENT'."
        echo "Usage: ./install.sh [all|gemini|claude|cursor|codex]"
        exit 1
        ;;
esac

echo "======================================================"
echo " Installation Complete! EAR is active for ${TARGET_AGENT}. "
echo "======================================================"
