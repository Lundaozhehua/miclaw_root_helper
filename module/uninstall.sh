#!/system/bin/sh
# Cleanup on module uninstall
MODDIR="$(cd "$(dirname "$0")" && pwd)"
pkill -f 'nc.*-p 9999' 2>/dev/null
pkill -f 'host-mcp serve' 2>/dev/null
rm -rf "${MODDIR}/log" "${MODDIR}/data" "${MODDIR}/nc.pid" "${MODDIR}/hostmcp.pid"
