#!/system/bin/sh
# Miclaw Root Helper v5.3.3 - KSU Module
# Starts nc 9999 root shell listener + host-mcp MCP bridge (root mode)

MODDIR="$(cd "$(dirname "$0")" && pwd)"
LOG="${MODDIR}/miclaw_root_helper.log"
HOSTMCP_LOG="${MODDIR}/hostmcp.log"

log() { echo "$(date '+%m-%d %H:%M:%S') $1" >> "$LOG"; }

log "[INIT] v5.3.3 starting"

# Wait for boot
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
sleep 10

# === NC Listener ===
NC_CMD=""
for cmd in "toybox nc" "nc" "/data/adb/ksu/bin/busybox nc" "/data/adb/magisk/busybox nc"; do
  if $cmd -h 2>&1 | grep -q 'listen'; then NC_CMD="$cmd"; break; fi
done
[ -z "$NC_CMD" ] && NC_CMD="nc"

sh -c 'while true; do $0 -ll -p 9999 -e /system/bin/sh 127.0.0.1 2>/dev/null; sleep 1; done' $NC_CMD &
echo $! > "${MODDIR}/listener.pid"
log "[NC] pid=$!"

# === Deploy host-mcp to /data/adb/host-mcp ===
HCP_DIR="/data/adb/host-mcp"
mkdir -p "$HCP_DIR/.config/host-mcp"

# Binary
if [ -f "${MODDIR}/bin/host-mcp" ]; then
  cp "${MODDIR}/bin/host-mcp" "${HCP_DIR}/host-mcp"
  chmod 755 "${HCP_DIR}/host-mcp"
  log "[DEPLOY] binary ok"
else
  log "[ERR] bin/host-mcp not found in module"
fi

# Config
if [ -f "${MODDIR}/config/config.json" ]; then
  cp "${MODDIR}/config/config.json" "${HCP_DIR}/.config/host-mcp/config.json"
  chmod 644 "${HCP_DIR}/.config/host-mcp/config.json"
  log "[DEPLOY] config ok"
fi
if [ -f "${MODDIR}/config/token" ]; then
  cp "${MODDIR}/config/token" "${HCP_DIR}/.config/host-mcp/token"
  chmod 600 "${HCP_DIR}/.config/host-mcp/token"
  log "[DEPLOY] token ok"
fi

# === Ensure Termux dirs exist (host-mcp roots need them) ===
mkdir -p /data/data/com.termux/files/usr /data/data/com.termux/files/home
chmod 771 /data/data/com.termux/files
log "[DEPLOY] termux dirs ensured"

# === Start host-mcp as root ===
if [ -f "${HCP_DIR}/host-mcp" ]; then
  export PATH=/data/data/com.termux/files/usr/bin:$PATH
  export HOME="$HCP_DIR"
  pkill -f "host-mcp serve" 2>/dev/null
  sleep 1
  nohup "${HCP_DIR}/host-mcp" serve >> "$HOSTMCP_LOG" 2>&1 &
  HCP_PID=$!
  echo "${HCP_PID}" > "${MODDIR}/hostmcp.pid"
  log "[HCP] host-mcp started, pid=${HCP_PID}"
else
  log "[ERR] host-mcp binary not found at ${HCP_DIR}"
fi

log "[INIT] done (nc + host-mcp root mode)"
