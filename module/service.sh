#!/system/bin/sh
# Miclaw Root Helper v3.0 - KSU Module
# Starts nc 9999 (root shell) + host-mcp (MCP bridge)

MODDIR="$(cd "$(dirname "$0")" && pwd)"
LOG="${MODDIR}/miclaw_root_helper.log"

log() { echo "$(date '+%m-%d %H:%M:%S') $*" >> "$LOG"; }

# Wait for boot
while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 2; done
sleep 3

log "[INIT] miclaw root helper v3.0 starting"

# === NC Listener (port 9999) ===
NC_CMD=""
if command -v toybox >/dev/null 2>&1; then NC_CMD="toybox nc";
elif command -v nc >/dev/null 2>&1; then NC_CMD="nc";
elif [ -f /data/adb/ksu/bin/busybox ]; then NC_CMD="/data/adb/ksu/bin/busybox nc";
elif [ -f /data/adb/magisk/busybox ]; then NC_CMD="/data/adb/magisk/busybox nc";
fi

if [ -z "$NC_CMD" ]; then log "[ERR] no nc found"; exit 1; fi

# Kill old instance
[ -f "${MODDIR}/listener.pid" ] && kill $(cat "${MODDIR}/listener.pid") 2>/dev/null

# Start listener in background
(
  while true; do
    log "[NC] listening on 127.0.0.1:9999"
    $NC_CMD -s 127.0.0.1 -p 9999 -L /system/bin/sh -l 2>/dev/null
    sleep 1
  done
) &
echo $! > "${MODDIR}/listener.pid"
log "[NC] started, pid=$!"

# === Host-MCP ===
HOSTMCP="${MODDIR}/host-mcp"
if [ -f "$HOSTMCP" ] && [ -x "$HOSTMCP" ]; then
  export HOME="${MODDIR}"
  mkdir -p "${MODDIR}/.config"
  (
    while true; do
      log "[HCP] starting host-mcp serve"
      "$HOSTMCP" serve 2>> "${MODDIR}/hostmcp.log"
      log "[HCP] host-mcp exited, restarting in 3s"
      sleep 3
    done
  ) &
  log "[HCP] host-mcp started, pid=$!"
else
  log "[WARN] host-mcp not found at ${HOSTMCP}"
fi

log "[INIT] all services started"
