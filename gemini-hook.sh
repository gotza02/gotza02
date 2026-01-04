#!/usr/bin/env bash
set -euo pipefail
umask 077

# ---------------------------
# Config (ปรับได้)
# ---------------------------
DEFAULT_MODEL="gemini-3-flash-preview"
SUBAGENT_TIMEOUT_SEC="90"      # กันค้าง
CACHE_TTL_SEC="600"            # แคชผล 10 นาที กันยิงซ้ำหลายรอบใน turn เดียว
NUM_SUBAGENTS="4"              # code/research/analysis/predict + 1 judge (รวม 5 calls ต่อ 1 prompt)

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

install_gemini_cli() {
  if have gemini; then
    return 0
  fi

  echo "[INFO] gemini CLI not found. Installing..."

  if have brew; then
    brew install gemini-cli
  elif have npm; then
    # Official: npm install -g @google/gemini-cli
    npm install -g @google/gemini-cli
  else
    echo "[ERROR] Need either Homebrew (brew) or Node/NPM (npm) to install Gemini CLI."
    echo "        Install one of them, then re-run this script."
    exit 1
  fi

  if ! have gemini; then
    echo "[ERROR] gemini CLI installation completed but 'gemini' command not found in PATH."
    echo "        Open a new shell or fix PATH, then re-run."
    exit 1
  fi
}

write_global_context() {
  if [[ -f "${GLOBAL_CONTEXT}" ]]; then
    echo "[INFO] Global context already exists: ${GLOBAL_CONTEXT} (not overwriting)"
    return 0
  fi

  cat > "${GLOBAL_CONTEXT}" <<'EOF'
# Global Instructions (GEMINI.md)

คุณคือ Agent กลางของฉันใน Gemini CLI

## Multi-Agent Orchestration (Injected)
ถ้ามีบล็อกชื่อ "MULTI_AGENT_PACKET" ถูกฉีดเข้ามาในบริบท:
- ต้องอ่านทุกส่วน (CODE / RESEARCH / ANALYSIS / PREDICTION / JUDGE)
- สังเคราะห์คำตอบที่ “ดีที่สุด” ให้ผู้ใช้ โดย:
  - ถ้างานเป็นโค้ด: ให้คำตอบแบบใช้งานได้จริง, มีคำสั่งรัน/ไฟล์/แพตช์, และข้อควรระวัง
  - ถ้างานเป็นวิจัย/ค้นหา: สรุปเชิงโครงสร้าง, ระบุสมมติฐาน/ข้อจำกัด, และให้รายการแหล่งข้อมูลที่ควรตรวจสอบ (ถ้ามี)
  - ถ้างานเป็นวิเคราะห์: ให้เหตุผล/ขั้นตอนคิดแบบตรวจสอบได้, แยกข้อเท็จจริง vs สมมติฐาน
  - ถ้างานเป็นทำนายผล: ให้สมมติฐาน, ตัวแปรสำคัญ, ช่วงความเป็นไปได้, และระดับความเชื่อมั่น

## Output Style
- ตอบเป็นภาษาไทยเป็นหลัก
- เน้นขั้นตอนทำจริง (commands / config / file paths)
- ถ้าไม่มั่นใจ ให้ระบุชัดเจนว่าไม่มั่นใจส่วนไหนและต้องตรวจอะไรเพิ่ม

EOF

  echo "[INFO] Wrote global context: ${GLOBAL_CONTEXT}"
}

write_orchestrator() {
  cat > "${ORCH}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Prevent recursion: subagent processes set this env var
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
  # Prefer GNU timeout if available
  if have timeout; then
    timeout "$@"
  elif have gtimeout; then
    gtimeout "$@"
  else
    # No timeout utility; run as-is
    "$@"
  fi
}

# Read hook event JSON from stdin
EVENT_JSON="$(cat || true)"
if [[ -z "${EVENT_JSON}" ]]; then
  printf '%s' '{}'
  exit 0
fi

if ! have python3; then
  # Cannot parse event; fail gracefully
  printf '%s' '{}'
  exit 0
fi

PROMPT="$(
python3 - <<'PY' <<<"${EVENT_JSON}"
import json, sys

raw = sys.stdin.read()
try:
    data = json.loads(raw) if raw.strip() else {}
except Exception:
    data = {}

def get_str(x):
    return x.strip() if isinstance(x, str) else ""

# Try common keys
for k in ["prompt", "input", "text", "userPrompt", "userMessage", "query"]:
    v = get_str(data.get(k))
    if v:
        print(v)
        raise SystemExit(0)

# Try messages array
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

# Compute cache key (sha256 of prompt)
CACHE_KEY="$(
python3 - <<'PY' <<<"${PROMPT}"
import hashlib, sys
p = sys.stdin.read().encode("utf-8", "replace")
print(hashlib.sha256(p).hexdigest())
PY
)"

CACHE_FILE="${CACHE_DIR}/${CACHE_KEY}.json"

now_epoch() { date +%s; }

if [[ -f "${CACHE_FILE}" ]]; then
  # Validate TTL
  if python3 - <<'PY' "${CACHE_FILE}" "${CACHE_TTL_SEC}" >/dev/null 2>&1; then
import json, sys, time, os
path = sys.argv[1]
ttl = int(sys.argv[2])
st = os.stat(path)
age = int(time.time()) - int(st.st_mtime)
if age <= ttl:
    sys.exit(0)
sys.exit(1)
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

TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t gemini-ma)"
cleanup() { rm -rf "${TMP_DIR}"; }
trap cleanup EXIT

CODE_OUT="${TMP_DIR}/code.txt"
RES_OUT="${TMP_DIR}/research.txt"
ANL_OUT="${TMP_DIR}/analysis.txt"
PRD_OUT="${TMP_DIR}/predict.txt"
JDG_OUT="${TMP_DIR}/judge.txt"

run_agent() {
  local label="$1"
  local outfile="$2"
  local sys_prompt="$3"

  # Use YOLO so subagents don't hang on approvals.
  # Still instruct them not to run shell / modify files.
  (
    GEMINI_MULTIAGENT_CHILD=1 \
    GEMINI_MULTIAGENT_MODEL="${DEFAULT_MODEL}" \
      timeout_cmd "${TIMEOUT_SEC}" \
      gemini -m "${DEFAULT_MODEL}" --approval-mode=yolo -p "${sys_prompt}

USER REQUEST:
${PROMPT}
" >"${outfile}" 2>&1 || true
  ) &
}

run_agent "CODE"    "${CODE_OUT}" "ROLE: CODE (subagent)
เป้าหมาย: ให้คำตอบด้านโค้ดที่ใช้งานได้จริงที่สุด
กติกา:
- ถ้าต้องเขียนโค้ด ให้ใส่โค้ด/คำสั่งรัน/โครงสร้างไฟล์ชัดเจน
- ถ้าต้องแก้บั๊ก ให้ระบุสาเหตุ + แพตช์
- ห้ามรัน shell tool หรือแก้ไฟล์จริง (ตอบเป็นคำแนะนำ/คำสั่งเท่านั้น)
เอาท์พุต:
- สรุปแนวทาง
- โค้ด/คำสั่ง
- ข้อควรระวัง"

run_agent "RESEARCH" "${RES_OUT}" "ROLE: RESEARCH/SEARCH (subagent)
เป้าหมาย: ค้นคว้า/สรุปข้อมูลให้พร้อมใช้งาน
กติกา:
- ถ้าต้องอ้างอิง ให้ใส่ชื่อแหล่งข้อมูล/หัวข้อ/คำค้นที่แนะนำ
- ถ้าคำขอเป็นงานค้นหา ให้เสนอรายการ query และสิ่งที่ควรตรวจสอบ
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต:
- สรุป bullet
- รายการคำค้น/แหล่งข้อมูลที่ควรดู
- ช่องว่าง/ข้อจำกัด"

run_agent "ANALYSIS" "${ANL_OUT}" "ROLE: ANALYSIS (subagent)
เป้าหมาย: วิเคราะห์เชิงลึกและโครงสร้างการตัดสินใจ
กติกา:
- แยก Fact / Assumption / Risk
- ถ้าเป็นงานออกแบบระบบ ให้ trade-offs
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต:
- กรอบวิเคราะห์
- ข้อเสนอแนะเชิงขั้นตอน
- ความเสี่ยง"

run_agent "PREDICT" "${PRD_OUT}" "ROLE: PREDICTION/FORECAST (subagent)
เป้าหมาย: ประเมินแนวโน้ม/ทำนายผล/ประมาณการ
กติกา:
- ระบุสมมติฐานชัดเจน
- ให้ range และความเชื่อมั่น
- ชี้ตัวแปรที่ทำให้ผลเปลี่ยน
- ห้ามรัน shell tool หรือแก้ไฟล์จริง
เอาท์พุต:
- สมมติฐาน
- ผลลัพธ์คาดการณ์ (ช่วง)
- ความเชื่อมั่น + ตัวแปรสำคัญ"

wait || true

# Read outputs (truncate to keep context small)
truncate() {
  python3 - <<'PY' "$1"
import sys
path = sys.argv[1]
try:
    s = open(path, "r", encoding="utf-8", errors="replace").read()
except Exception:
    s = ""
# Keep last 12000 chars (often most relevant is near the end for CLI tools)
if len(s) > 12000:
    s = s[-12000:]
print(s)
PY
}

CODE_TXT="$(truncate "${CODE_OUT}")"
RES_TXT="$(truncate "${RES_OUT}")"
ANL_TXT="$(truncate "${ANL_OUT}")"
PRD_TXT="$(truncate "${PRD_OUT}")"

# Judge/synthesizer (one more call) to pick best + merge
JUDGE_PROMPT="ROLE: JUDGE/SYNTHESIZER
คุณได้รับผลจาก subagents 4 ตัว: CODE/RESEARCH/ANALYSIS/PREDICT
งานของคุณ: สังเคราะห์คำตอบที่ดีที่สุด “พร้อมใช้งานจริง” สำหรับผู้ใช้
กติกา:
- ถ้าเป็นงานโค้ด ให้มีคำสั่ง/โค้ดชัดเจน
- ถ้าเป็นงานวิจัย/ค้นหา ให้มีขั้นตอนและสิ่งที่ต้องตรวจสอบต่อ
- ถ้าเป็นงานทำนาย ให้มีสมมติฐาน + range + ความเชื่อมั่น
- ห้ามรัน shell tool หรือแก้ไฟล์จริง

INPUTS:
[CODE]
${CODE_TXT}

[RESEARCH]
${RES_TXT}

[ANALYSIS]
${ANL_TXT}

[PREDICT]
${PRD_TXT}

OUTPUT:
- FINAL (คำตอบสุดท้ายให้ผู้ใช้)
- CHECKLIST (สิ่งที่ต้องทำ/ตรวจ)
- RISKS (ถ้ามี)
"

GEMINI_MULTIAGENT_CHILD=1 \
  timeout_cmd "${TIMEOUT_SEC}" \
  gemini -m "${DEFAULT_MODEL}" --approval-mode=yolo -p "${JUDGE_PROMPT}" >"${JDG_OUT}" 2>&1 || true

JDG_TXT="$(truncate "${JDG_OUT}")"

# Build additional context packet for the main agent
PACKET="$(python3 - <<'PY'
import os, json
code = os.environ.get("CODE_TXT","")
res  = os.environ.get("RES_TXT","")
anl  = os.environ.get("ANL_TXT","")
prd  = os.environ.get("PRD_TXT","")
jdg  = os.environ.get("JDG_TXT","")

packet = f"""MULTI_AGENT_PACKET
MODEL={os.environ.get("DEFAULT_MODEL","")}

[CODE]
{code}

[RESEARCH]
{res}

[ANALYSIS]
{anl}

[PREDICTION]
{prd}

[JUDGE]
{jdg}
"""
print(packet)
PY
)"

# Emit hook output JSON (additionalContext)
OUT_JSON="$(
python3 - <<'PY' <<<"${PACKET}"
import json, sys
ctx = sys.stdin.read()
print(json.dumps({"hookSpecificOutput": {"additionalContext": ctx}}, ensure_ascii=False))
PY
)"

# Cache it
printf '%s' "${OUT_JSON}" > "${CACHE_FILE}" 2>/dev/null || true

# Print final hook output
printf '%s' "${OUT_JSON}"
EOF

  chmod +x "${ORCH}"
  echo "[INFO] Wrote orchestrator hook: ${ORCH}"
}

update_settings_json() {
  mkdir -p "${GEMINI_DIR}"
  backup_file "${SETTINGS_JSON}"

  # Decide sandbox default (if docker exists, enable; else leave true anyway—Gemini CLI may handle)
  SANDBOX_DEFAULT="true"
  if ! have docker; then
    # Still keep true; user can disable later if needed.
    SANDBOX_DEFAULT="true"
  fi

  python3 - <<PY
import json, os, sys
path = os.path.expanduser("${SETTINGS_JSON}")
orch = os.path.expanduser("${ORCH}")

data = {}
if os.path.exists(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            data = json.load(f)
    except Exception:
        data = {}

def ensure_dict(parent, key):
    v = parent.get(key)
    if not isinstance(v, dict):
        v = {}
        parent[key] = v
    return v

# context.fileName -> GEMINI.md (global memory filename)
context = ensure_dict(data, "context")
context["fileName"] = ["GEMINI.md"]

# tools.enableHooks -> true
tools = ensure_dict(data, "tools")
tools["enableHooks"] = True
tools["sandbox"] = ${SANDBOX_DEFAULT}

# experimental.enableAgents -> true (ถ้ามีในเวอร์ชันนั้น)
experimental = ensure_dict(data, "experimental")
experimental["enableAgents"] = True

# hooks.BeforeModel -> call orchestrator (idempotent; remove duplicates)
hooks = ensure_dict(data, "hooks")
before_model = hooks.get("BeforeModel")
if not isinstance(before_model, list):
    before_model = []
entry = {"matcher": "*", "hooks": [{"type": "command", "command": orch}]}

# de-dup existing entries with same command
new_list = []
for e in before_model:
    try:
        cmd = e.get("hooks",[{}])[0].get("command")
    except Exception:
        cmd = None
    if cmd == orch:
        continue
    new_list.append(e)
new_list.append(entry)
hooks["BeforeModel"] = new_list

os.makedirs(os.path.dirname(path), exist_ok=True)
with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY

  echo "[INFO] Updated settings: ${SETTINGS_JSON}"
}

print_next_steps() {
  cat <<EOF

[DONE] Global multi-agent setup completed.

What was configured:
- Global context file: ${GLOBAL_CONTEXT}
  (Gemini CLI loads global context from ~/.gemini/<configured-context-filename>) :contentReference[oaicite:5]{index=5}
- context.fileName set to GEMINI.md :contentReference[oaicite:6]{index=6}
- tools.enableHooks enabled (requires restart) :contentReference[oaicite:7]{index=7}
- Hook registered on BeforeModel to run: ${ORCH} :contentReference[oaicite:8]{index=8}

How to use:
1) Close any running gemini sessions and re-open your terminal (or start a new shell).
2) Run:
   gemini
   แล้วพิมพ์โจทย์ตามปกติ (คุณไม่ต้องสั่ง subagent เอง)

Verification / Debug:
- ใน Gemini CLI ใช้คำสั่ง:
  /memory show    เพื่อดู context ที่ถูกรวมจริง :contentReference[oaicite:9]{index=9}
  /memory refresh เพื่อสแกนไฟล์ GEMINI.md ใหม่ :contentReference[oaicite:10]{index=10}

Disable quickly (ถ้าต้องการหยุด multi-agent):
- แก้ ~/.gemini/settings.json แล้วตั้ง tools.enableHooks = false :contentReference[oaicite:11]{index=11}

Security note:
- Hooks รันโค้ดด้วยสิทธิ์ของ user คุณเอง จึงมีความเสี่ยงถ้าสคริปต์ไม่ปลอดภัย :contentReference[oaicite:12]{index=12}

EOF
}

main() {
  mkdir -p "${GEMINI_DIR}" "${HOOKS_DIR}" "${CACHE_DIR}"
  install_gemini_cli
  write_global_context
  write_orchestrator
  update_settings_json
  print_next_steps
}

main "$@"
