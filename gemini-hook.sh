cat > ~/.gemini/setup-multiagent.sh << 'SCRIPT_EOF'
#!/usr/bin/env bash
set -euo pipefail
umask 077

# ---------------------------
# Config (ปรับได้)
# ---------------------------
DEFAULT_MODEL="gemini-3-flash-preview"
SUBAGENT_TIMEOUT_SEC="90"
CACHE_TTL_SEC="600"
NUM_SUBAGENTS="4"

# ---------------------------
# Paths (Global)
# ---------------------------
GEMINI_DIR="${HOME}/.gemini"
HOOKS_DIR="${GEMINI_DIR}/hooks"
CACHE_DIR="${GEMINI_DIR}/.multiagent_cache"

SETTINGS_JSON="${GEMINI_DIR}/settings.json"
SETTINGS_BAK_DIR="${GEMINI_DIR}/backup_settings"
GLOBAL_CONTEXT="${GEMINI_DIR}/GEMINI.md"

ORCH="${HOOKS_DIR}/multiagent-orchestrator.sh"

# ---------------------------
# Helpers
# ---------------------------
have() { command -v "$1" >/dev/null 2>&1; }
timestamp() { date +"%Y%m%d-%H%M%S"; }

backup_file() {
  local f="$1"
  [[ -f "$f" ]] || return 0
  mkdir -p "${SETTINGS_BAK_DIR}"
  cp -f "$f" "${SETTINGS_BAK_DIR}/$(basename "$f").$(timestamp).bak"
}

write_global_context() {
  cat > "${GLOBAL_CONTEXT}" <<'EOF'
# Global Instructions (GEMINI.md)

คุณคือ Agent กลางของฉันใน Gemini CLI

## Multi-Agent Orchestration (Injected)
ถ้ามีบล็อกชื่อ "MULTI_AGENT_PACKET" ถูกฉีดเข้ามาในบริบท:
- ต้องอ่านทุกส่วน (CODE / RESEARCH / ANALYSIS / PREDICTION / JUDGE)
- สังเคราะห์คำตอบที่ "ดีที่สุด" ให้ผู้ใช้ โดย:
  - ถ้างานเป็นโค้ด: ให้คำตอบแบบใช้งานได้จริง, มีคำสั่งรัน/ไฟล์/แพตช์, และข้อควรระวัง
  - ถ้างานเป็นวิจัย/ค้นหา: สรุปเชิงโครงสร้าง, ระบุสมมติฐาน/ข้อจำกัด, และให้รายการแหล่งข้อมูลที่ควรตรวจสอบ
  - ถ้างานเป็นวิเคราะห์: ให้เหตุผล/ขั้นตอนคิดแบบตรวจสอบได้, แยกข้อเท็จจริง vs สมมติฐาน
  - ถ้างานเป็นทำนายผล: ให้สมมติฐาน, ตัวแปรสำคัญ, ช่วงความเป็นไปได้, และระดับความเชื่อมั่น

## MCP Tools Available
- **exa**: ค้นหาข้อมูลจาก web แบบ semantic search
- **context7**: จัดการ context และ memory
- **brave-search**: ค้นหาจาก Brave Search API
- **filesystem**: อ่าน/เขียนไฟล์ใน sandbox directories

## Output Style
- ตอบเป็นภาษาไทยเป็นหลัก
- เน้นขั้นตอนทำจริง (commands / config / file paths)
- ถ้าไม่มั่นใจ ให้ระบุชัดเจนว่าไม่มั่นใจส่วนไหนและต้องตรวจอะไรเพิ่ม
- ใช้ MCP tools เมื่อต้องการข้อมูลจริงจาก web หรือจัดการไฟล์
EOF
  echo "[✓] Global context: ${GLOBAL_CONTEXT}"
}

write_orchestrator() {
  cat > "${ORCH}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Prevent recursion
if [[ "${GEMINI_MULTIAGENT_CHILD:-}" == "1" ]]; then
  printf '%s' '{}'
  exit 0
fi

DEFAULT_MODEL="${GEMINI_MULTIAGENT_MODEL:-gemini-3-flash-preview}"
TIMEOUT_SEC="${GEMINI_MULTIAGENT_TIMEOUT_SEC:-90}"
CACHE_TTL_SEC="${GEMINI_MULTIAGENT_CACHE_TTL_SEC:-600}"

GEMINI_DIR="${HOME}/.gemini"
CACHE_DIR="${GEMINI_DIR}/.multiagent_cache"
mkdir -p "${CACHE_DIR}"

have() { command -v "$1" >/dev/null 2>&1; }

timeout_cmd() {
  if have timeout; then
    timeout "$@"
  elif have gtimeout; then
    gtimeout "$@"
  else
    shift; "$@"
  fi
}

EVENT_JSON="$(cat || true)"
if [[ -z "${EVENT_JSON}" ]]; then
  printf '%s' '{}'
  exit 0
fi

if ! have python3; then
  printf '%s' '{}'
  exit 0
fi

PROMPT="$(python3 - <<'PY' <<<"${EVENT_JSON}"
import json, sys
raw = sys.stdin.read()
try:
    data = json.loads(raw) if raw.strip() else {}
except:
    data = {}
def get_str(x):
    return x.strip() if isinstance(x, str) else ""
for k in ["prompt", "input", "text", "userPrompt", "userMessage", "query"]:
    v = get_str(data.get(k))
    if v:
        print(v)
        raise SystemExit(0)
msgs = data.get("messages")
if isinstance(msgs, list) and msgs:
    last = msgs[-1]
    if isinstance(last, dict):
        v = get_str(last.get("content")) or get_str(last.get("text"))
        if v:
            print(v)
            raise SystemExit(0)
print("")
PY
)"

if [[ -z "${PROMPT}" ]]; then
  printf '%s' '{}'
  exit 0
fi

CACHE_KEY="$(python3 -c "import hashlib,sys; print(hashlib.sha256(sys.argv[1].encode()).hexdigest())" "${PROMPT}")"
CACHE_FILE="${CACHE_DIR}/${CACHE_KEY}.json"

if [[ -f "${CACHE_FILE}" ]]; then
  if python3 - "${CACHE_FILE}" "${CACHE_TTL_SEC}" 2>/dev/null <<'PY'
import sys, time, os
age = int(time.time()) - int(os.stat(sys.argv[1]).st_mtime)
sys.exit(0 if age <= int(sys.argv[2]) else 1)
PY
  then
    cat "${CACHE_FILE}"
    exit 0
  fi
fi

if ! have gemini; then
  printf '%s' '{}'
  exit 0
fi

TMP_DIR="$(mktemp -d)"
trap "rm -rf '${TMP_DIR}'" EXIT

run_agent() {
  local outfile="$1" sys_prompt="$2"
  (
    GEMINI_MULTIAGENT_CHILD=1 \
    timeout_cmd "${TIMEOUT_SEC}" \
    gemini -m "${DEFAULT_MODEL}" --sandbox=false --approval-mode=yolo -p "${sys_prompt}

USER REQUEST:
${PROMPT}
" >"${outfile}" 2>&1 || true
  ) &
}

echo "[Multi-Agent] กำลังประมวลผล 4 agents..." >&2

run_agent "${TMP_DIR}/code.txt" "ROLE: CODE (subagent)
เป้าหมาย: ให้คำตอบด้านโค้ดที่ใช้งานได้จริงที่สุด
- ถ้าต้องเขียนโค้ด ให้ใส่โค้ด/คำสั่งรัน/โครงสร้างไฟล์ชัดเจน
- ถ้าต้องแก้บั๊ก ให้ระบุสาเหตุ + แพตช์
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต: สรุปแนวทาง, โค้ด/คำสั่ง, ข้อควรระวัง"

run_agent "${TMP_DIR}/research.txt" "ROLE: RESEARCH (subagent)
เป้าหมาย: ค้นคว้า/สรุปข้อมูลให้พร้อมใช้งาน
- ถ้าต้องอ้างอิง ให้ใส่ชื่อแหล่งข้อมูล/หัวข้อ/คำค้นที่แนะนำ
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต: สรุป bullet, รายการคำค้น/แหล่งข้อมูล, ข้อจำกัด"

run_agent "${TMP_DIR}/analysis.txt" "ROLE: ANALYSIS (subagent)
เป้าหมาย: วิเคราะห์เชิงลึกและโครงสร้างการตัดสินใจ
- แยก Fact / Assumption / Risk
- ถ้าเป็นงานออกแบบระบบ ให้ trade-offs
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต: กรอบวิเคราะห์, ข้อเสนอแนะ, ความเสี่ยง"

run_agent "${TMP_DIR}/predict.txt" "ROLE: PREDICTION (subagent)
เป้าหมาย: ประเมินแนวโน้ม/ทำนายผล/ประมาณการ
- ระบุสมมติฐานชัดเจน
- ให้ range และความเชื่อมั่น
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต: สมมติฐาน, ผลลัพธ์คาดการณ์, ความเชื่อมั่น"

wait || true
echo "[Multi-Agent] agents เสร็จ กำลังสังเคราะห์..." >&2

truncate_file() {
  python3 -c "
import sys
try:
    s = open(sys.argv[1]).read()[-12000:]
except:
    s = ''
print(s)
" "$1"
}

CODE_TXT="$(truncate_file "${TMP_DIR}/code.txt")"
RES_TXT="$(truncate_file "${TMP_DIR}/research.txt")"
ANL_TXT="$(truncate_file "${TMP_DIR}/analysis.txt")"
PRD_TXT="$(truncate_file "${TMP_DIR}/predict.txt")"

JUDGE_PROMPT="ROLE: JUDGE/SYNTHESIZER
คุณได้รับผลจาก 4 subagents: CODE/RESEARCH/ANALYSIS/PREDICT
งาน: สังเคราะห์คำตอบที่ดีที่สุดพร้อมใช้งานจริง
- ถ้างานโค้ด: มีคำสั่ง/โค้ดชัดเจน
- ถ้างานวิจัย: มีขั้นตอนและสิ่งที่ต้องตรวจสอบ
- ถ้างานทำนาย: มีสมมติฐาน + range + ความเชื่อมั่น
ห้ามรัน shell หรือแก้ไฟล์จริง

[CODE]
${CODE_TXT}

[RESEARCH]
${RES_TXT}

[ANALYSIS]
${ANL_TXT}

[PREDICT]
${PRD_TXT}

OUTPUT: FINAL (คำตอบสุดท้าย), CHECKLIST (สิ่งที่ต้องทำ), RISKS (ถ้ามี)"

GEMINI_MULTIAGENT_CHILD=1 \
  timeout_cmd "${TIMEOUT_SEC}" \
  gemini -m "${DEFAULT_MODEL}" --sandbox=false --approval-mode=yolo -p "${JUDGE_PROMPT}" >"${TMP_DIR}/judge.txt" 2>&1 || true

JDG_TXT="$(truncate_file "${TMP_DIR}/judge.txt")"

export CODE_TXT RES_TXT ANL_TXT PRD_TXT JDG_TXT DEFAULT_MODEL
PACKET="$(python3 -c '
import os
print(f"""MULTI_AGENT_PACKET
MODEL={os.environ.get("DEFAULT_MODEL","")}

[CODE]
{os.environ.get("CODE_TXT","")}

[RESEARCH]
{os.environ.get("RES_TXT","")}

[ANALYSIS]
{os.environ.get("ANL_TXT","")}

[PREDICTION]
{os.environ.get("PRD_TXT","")}

[JUDGE]
{os.environ.get("JDG_TXT","")}
""")')"

OUT_JSON="$(python3 -c "import json,sys; print(json.dumps({'hookSpecificOutput':{'additionalContext':sys.stdin.read()}}))" <<<"${PACKET}")"

printf '%s' "${OUT_JSON}" > "${CACHE_FILE}" 2>/dev/null || true
printf '%s' "${OUT_JSON}"
EOF

  chmod +x "${ORCH}"
  echo "[✓] Orchestrator hook: ${ORCH}"
}

update_settings_json() {
  backup_file "${SETTINGS_JSON}"
  
  python3 - <<PY
import json, os

path = "${SETTINGS_JSON}"
orch = "${ORCH}"

data = {}
if os.path.exists(path):
    try:
        data = json.load(open(path))
    except:
        data = {}

# Context
data.setdefault("context", {})["fileName"] = ["GEMINI.md"]

# Tools
tools = data.setdefault("tools", {})
tools["enableHooks"] = True
tools["sandbox"] = False

# Experimental
data.setdefault("experimental", {})["enableAgents"] = True

# Hooks
hooks = data.setdefault("hooks", {})
before = [e for e in hooks.get("BeforeModel", []) 
          if e.get("hooks", [{}])[0].get("command") != orch]
before.append({"matcher": "*", "hooks": [{"type": "command", "command": orch}]})
hooks["BeforeModel"] = before

# MCP Servers
data["mcpServers"] = {
    "exa": {
        "command": "npx",
        "args": ["-y", "exa-mcp-server"],
        "env": {
            "EXA_API_KEY": "\$EXA_API_KEY"
        }
    },
    "context7": {
        "command": "npx",
        "args": ["-y", "@upstash/context7-mcp"],
        "env": {
            "CONTEXT7_API_KEY": "\$CONTEXT7_API_KEY"
        }
    },
    "brave-search": {
        "command": "npx",
        "args": ["-y", "@modelcontextprotocol/server-brave-search"],
        "env": {
            "BRAVE_API_KEY": "\$BRAVE_API_KEY"
        }
    },
    "filesystem": {
        "command": "npx",
        "args": [
            "-y",
            "@modelcontextprotocol/server-filesystem",
            "/storage/emulated/0/sandbox",
            "/data/data/com.termux/files/home/.gemini"
        ]
    }
}

with open(path, "w") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write("\n")
PY
  echo "[✓] Settings + MCP Servers: ${SETTINGS_JSON}"
}

main() {
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Multi-Agent + MCP Servers Setup"
  echo "  Model: gemini-3-flash-preview"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  mkdir -p "${GEMINI_DIR}" "${HOOKS_DIR}" "${CACHE_DIR}"
  write_global_context
  write_orchestrator
  update_settings_json
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "📦 MCP Servers ที่ติดตั้ง:"
  echo "   • exa (semantic search)"
  echo "   • context7 (memory)"
  echo "   • brave-search"
  echo "   • filesystem"
  echo ""
  echo "🔑 ตั้ง API Keys (ถ้าต้องการใช้ search):"
  echo "   export EXA_API_KEY='your-key'"
  echo "   export BRAVE_API_KEY='your-key'"
  echo "   export CONTEXT7_API_KEY='your-key'"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "[✓] เสร็จสมบูรณ์! พิมพ์ 'gemini' เพื่อใช้งาน"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

main
SCRIPT_EOF

chmod +x ~/.gemini/setup-multiagent.sh && ~/.gemini/setup-multiagent.sh
