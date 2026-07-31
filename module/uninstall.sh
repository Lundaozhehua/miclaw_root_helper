#!/system/bin/sh
# Miclaw Root Helper - Uninstall
# Kill listeners
[ -f "${MODDIR}/listener.pid" ] && kill $(cat "${MODDIR}/listener.pid") 2>/dev/null
pkill -f "nc.*9999" 2>/dev/null
# Note: host-mcp in Termux is NOT removed (user may want to keep it)
# User can manually run: rm ~/host-mcp ~/.config/host-mcp -rf
