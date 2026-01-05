cat > ~/.gemini/setup-full-multiagent.sh << 'SETUP_EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail
umask 022

# ═══════════════════════════════════════════════════════════════════
#  🚀 FULL SETUP: Gemini Multi-Agent Orchestrator (Termux)
#  Model: gemini-3-flash-preview | Fixes: Tools, Env, Logging
# ═══════════════════════════════════════════════════════════════════

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  📦 กำลังตรวจสอบและติดตั้ง Dependencies..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# 1. Install System Dependencies
pkg update -y >/dev/null 2>&1 || true
for pkg in python nodejs termux-api git; do
    if ! command -v $pkg &> /dev/null; then
        echo "  - Installing $pkg..."
        pkg install -y $pkg >/dev/null 2>&1
    fi
done

# 2. Setup Directories
GEMINI_DIR="$HOME/.gemini"
HOOKS_DIR="$GEMINI_DIR/hooks"
CACHE_DIR="$GEMINI_DIR/.multiagent_cache"
SETTINGS_JSON="$GEMINI_DIR/settings.json"
SETTINGS_BAK="$GEMINI_DIR/backup_settings"
GLOBAL_CONTEXT="$GEMINI_DIR/GEMINI.md"
ORCH="$HOOKS_DIR/multiagent-orchestrator.sh"
SANDBOX_DIR="/storage/emulated/0/sandbox"

mkdir -p "$GEMINI_DIR" "$HOOKS_DIR" "$CACHE_DIR" "$SETTINGS_BAK"

# 3. Setup Storage for Filesystem MCP
if [ ! -d "/storage/emulated/0" ]; then
    echo "  ⚠️  กรุณากด 'Allow' ในหน้าต่างที่เด้งขึ้นมาเพื่อให้สิทธิ์เข้าถึงไฟล์"
    termux-setup-storage
    sleep 3
fi
mkdir -p "$SANDBOX_DIR" 2>/dev/null || true

# -------------------------------------------------------------------
#  SCRIPT GENERATION
# -------------------------------------------------------------------

# 1. Global Context (GEMINI.md)
echo "  📝 สร้าง Global Context..."
cat > "$GLOBAL_CONTEXT" << 'CONTEXT_EOF'
# Global Instructions (GEMINI.md)

คุณคือ Agent กลางของฉันใน Gemini CLI

## Multi-Agent Orchestration
เมื่อได้รับบล็อก "MULTI_AGENT_PACKET" ในบริบท:
1. อ่านข้อมูลจากทุก Agent (Code, Research, Analysis, Predict)
2. สังเคราะห์คำตอบที่ดีที่สุดจากส่วน Judge
3. นำเสนอข้อมูลต่อผู้ใช้ในรูปแบบที่เข้าใจง่ายและนำไปใช้ได้จริง

## Output Style
- ตอบภาษาไทย
- เน้น Code ที่ใช้งานได้จริง (ถ้ามี)
- อ้างอิงแหล่งข้อมูล (ถ้ามี)
CONTEXT_EOF

# 2. Orchestrator Hook (หัวใจหลัก)
echo "  🧠 สร้าง Orchestrator Script (Fixed Tools)..."
cat > "$ORCH" << 'HOOK_EOF'
#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Prevent Recursion
if [[ "${GEMINI_MULTIAGENT_CHILD:-}" == "1" ]]; then
  printf '%s' '{}'
  exit 0
fi

# Configuration
DEFAULT_MODEL="${GEMINI_MULTIAGENT_MODEL:-gemini-3-flash-preview}"
TIMEOUT_SEC="${GEMINI_MULTIAGENT_TIMEOUT_SEC:-120}"
CACHE_TTL_SEC="${GEMINI_MULTIAGENT_CACHE_TTL_SEC:-600}"
GEMINI_DIR="$HOME/.gemini"
CACHE_DIR="$GEMINI_DIR/.multiagent_cache"
LOG_FILE="$GEMINI_DIR/multiagent.log"

# Logging function
log() { echo "[$(date '+%H:%M:%S')] $*" >> "$LOG_FILE"; }

# Read Input
EVENT_JSON="$(cat 2>/dev/null || echo '{}')"
log "▶ INPUT received (len: ${#EVENT_JSON})"

# Extract Prompt safely (Avoid Python quotes crash)
export EVENT_JSON_ENV="$EVENT_JSON"
PROMPT="$(python3 -c '
import json, os, sys
raw = os.environ.get("EVENT_JSON_ENV", "")
try:
    data = json.loads(raw) if raw.strip() else {}
except:
    data = {}

def find_prompt(obj, depth=0):
    if depth > 3: return ""
    if isinstance(obj, str) and obj.strip(): return obj.strip()
    if isinstance(obj, dict):
        for key in ["prompt", "input", "text", "userPrompt", "message"]:
            val = obj.get(key)
            if isinstance(val, str) and val.strip(): return val.strip()
        for val in obj.values():
            res = find_prompt(val, depth+1)
            if res: return res
    if isinstance(obj, list):
        for item in reversed(obj):
            res = find_prompt(item, depth+1)
            if res: return res
    return ""
print(find_prompt(data))
')"

if [[ -z "$PROMPT" ]]; then
  printf '%s' '{}'
  exit 0
fi

log "  Prompt: ${PROMPT:0:50}..."

# Cache Check
CACHE_KEY="$(echo -n "$PROMPT" | python3 -c 'import hashlib,sys; print(hashlib.sha256(sys.stdin.read().encode()).hexdigest())')"
CACHE_FILE="$CACHE_DIR/$CACHE_KEY.json"

if [[ -f "$CACHE_FILE" ]]; then
  FILE_AGE=$(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) ))
  if [[ $FILE_AGE -le $CACHE_TTL_SEC ]]; then
    log "  ✓ Cache Hit"
    cat "$CACHE_FILE"
    exit 0
  fi
fi

# Sub-agent Execution
TMP_DIR="$(mktemp -d)"
trap "rm -rf '$TMP_DIR'" EXIT

log "  ⚡ Starting Agents..."
echo "[Multi-Agent] ⏳ กำลังระดมสมอง 4 ด้าน (Research/Code/Analysis/Predict)..." >&2

run_agent() {
  local name="$1"
  local outfile="$2"
  local role="$3"
  (
    export GEMINI_MULTIAGENT_CHILD=1
    # FIX: ใช้ yes | เพื่อ Auto-approve Tool usage
    yes | timeout "$TIMEOUT_SEC" gemini -m "$DEFAULT_MODEL" --sandbox=false --approval-mode=yolo -p "$role

USER REQUEST:
$PROMPT" > "$outfile" 2>&1 || echo "Error: Timeout" > "$outfile"
  ) &
}

run_agent "CODE" "$TMP_DIR/code.txt" "ROLE: CODE AGENT. Focus: Implementation, Commands, Syntax."
run_agent "RESEARCH" "$TMP_DIR/research.txt" "ROLE: RESEARCH AGENT. Focus: Search Web, Facts, Docs."
run_agent "ANALYSIS" "$TMP_DIR/analysis.txt" "ROLE: ANALYSIS AGENT. Focus: Logic, Risks, Trade-offs."
run_agent "PREDICT" "$TMP_DIR/predict.txt" "ROLE: PREDICTION AGENT. Focus: Future trends, Estimation."

#wait

log "  ✓ Agents finished. Synthesizing..."

# Safe File Reading
read_file() {
    export FPATH="$1"
    python3 -c "import os; print(open(os.environ['FPATH'], errors='replace').read()[-15000:])" 2>/dev/null
}

CODE="$(read_file "$TMP_DIR/code.txt")"
RES="$(read_file "$TMP_DIR/research.txt")"
ANL="$(read_file "$TMP_DIR/analysis.txt")"
PRD="$(read_file "$TMP_DIR/predict.txt")"

# Judge Agent
export GEMINI_MULTIAGENT_CHILD=1
yes | timeout "$TIMEOUT_SEC" gemini -m "$DEFAULT_MODEL" --sandbox=false --approval-mode=yolo -p "ROLE: JUDGE
Synthesize the final answer from these agents:
[CODE]: $CODE
[RESEARCH]: $RES
[ANALYSIS]: $ANL
[PREDICT]: $PRD
" > "$TMP_DIR/judge.txt" 2>&1

JDG="$(read_file "$TMP_DIR/judge.txt")"

# Packet Construction
PACKET="════════════════════════════════════════════════════════════════
MULTI_AGENT_PACKET (Model: $DEFAULT_MODEL)
════════════════════════════════════════════════════════════════
▶ CODE:
$CODE
────────────────────────────────────────────────────────────────
▶ RESEARCH:
$RES
────────────────────────────────────────────────────────────────
▶ ANALYSIS:
$ANL
────────────────────────────────────────────────────────────────
▶ PREDICT:
$PRD
────────────────────────────────────────────────────────────────
▶ JUDGE (FINAL):
$JDG
════════════════════════════════════════════════════════════════"

# Create Output JSON
export PACKET_ENV="$PACKET"
OUT_JSON="$(python3 -c '
import json, os
packet = os.environ.get("PACKET_ENV", "")
output = {"hookSpecificOutput": {"additionalContext": packet}}
print(json.dumps(output, ensure_ascii=False))
')"

echo "$OUT_JSON" > "$CACHE_FILE" 2>/dev/null || true
printf '%s' "$OUT_JSON"
HOOK_EOF
chmod +x "$ORCH"

# 3. Settings JSON
echo "  ⚙️ อัปเดต Settings JSON..."
backup_file() { cp -f "$1" "$SETTINGS_BAK/" 2>/dev/null || true; }
backup_file "$SETTINGS_JSON"

python3 << PYEOF
import json, os
path = "$SETTINGS_JSON"
data = {}
if os.path.exists(path):
    try: data = json.load(open(path))
    except: pass

# Basic Config
data.setdefault("context", {})["fileName"] = ["GEMINI.md"]
data.setdefault("tools", {})["enableHooks"] = True
data.setdefault("tools", {})["sandbox"] = False # Disable built-in sandbox to use MCP
data.setdefault("experimental", {})["enableAgents"] = True

# Hooks
hooks = data.setdefault("hooks", {})
before = hooks.get("BeforeModel", [])
# Remove old hook entry if exists
before = [h for h in before if not (isinstance(h,dict) and "$ORCH" in str(h))]
# Add new hook
before.append({
    "matcher": "*",
    "hooks": [{"type": "command", "command": "$ORCH"}]
})
hooks["BeforeModel"] = before

# MCP Servers (Env vars inherited from shell)
data["mcpServers"] = {
    "exa": { "command": "npx", "args": ["-y", "exa-mcp-server"] },
    "brave-search": { "command": "npx", "args": ["-y", "@modelcontextprotocol/server-brave-search"] },
    "context7": { "command": "npx", "args": ["-y", "@upstash/context7-mcp"] },
    "filesystem": { 
        "command": "npx", 
        "args": ["-y", "@modelcontextprotocol/server-filesystem", "$SANDBOX_DIR", "$GEMINI_DIR"] 
    }
}

with open(path, 'w') as f: json.dump(data, f, indent=2, ensure_ascii=False)
PYEOF

# 4. Helper Scripts & Aliases
echo "  🛠️ สร้าง Helper Scripts..."
cat > "$GEMINI_DIR/multiagent-toggle.sh" << 'EOF'
#!/bin/bash
S="$HOME/.gemini/settings.json"
curr=$(python3 -c "import json; print(json.load(open('$S'))['tools'].get('enableHooks',False))")
new=$([ "$curr" == "True" ] && echo "False" || echo "True")
python3 -c "import json; d=json.load(open('$S')); d['tools']['enableHooks']=$new; json.dump(d,open('$S','w'),indent=2)"
echo "Multi-Agent: $new"
EOF
chmod +x "$GEMINI_DIR/multiagent-toggle.sh"

cat > "$GEMINI_DIR/multiagent-clear.sh" << 'EOF'
#!/bin/bash
rm -rf ~/.gemini/.multiagent_cache/* ~/.gemini/multiagent.log
echo "Cache cleared."
EOF
chmod +x "$GEMINI_DIR/multiagent-clear.sh"

# Add Aliases
RC="$HOME/.bashrc"
[[ -f "$HOME/.zshrc" ]] && RC="$HOME/.zshrc"
sed -i '/# Gemini-MA/d' "$RC" 2>/dev/null || true
sed -i '/alias ma-/d' "$RC" 2>/dev/null || true

cat >> "$RC" << 'EOF'

# Gemini-MA Aliases
alias ma-on='~/.gemini/multiagent-toggle.sh'
alias ma-off='~/.gemini/multiagent-toggle.sh'
alias ma-log='tail -f ~/.gemini/multiagent.log'
alias ma-clear='~/.gemini/multiagent-clear.sh'
EOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✅ ติดตั้งเสร็จสมบูรณ์! (Full Setup)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  1. พิมพ์คำสั่งนี้เพื่อโหลดการตั้งค่าใหม่:"
echo "     source ~/.bashrc"
echo ""
echo "  2. เริ่มใช้งานได้เลย:"
echo "     gemini \"ข่าวด่วน Bitcoin วันนี้ และผลกระทบต่อตลาด\""
echo ""
echo "  3. ดูการทำงานของ Agent:"
echo "     ma-log"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
SETUP_EOF

chmod +x ~/.gemini/setup-full-multiagent.sh && ~/.gemini/setup-full-multiagent.sh
