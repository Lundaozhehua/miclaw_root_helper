#!/system/bin/sh
# Miclaw Root Helper v5.3.3 - Module setup
# Deploys host-mcp + config to /data/adb/host-mcp/

MODDIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="/data/adb/host-mcp"

# Deploy host-mcp binary
mkdir -p "$TARGET"
cp "${MODDIR}/bin/host-mcp" "${TARGET}/host-mcp" && chmod 755 "${TARGET}/host-mcp"

# Deploy config + token
mkdir -p "${TARGET}/.config/host-mcp"
cp "${MODDIR}/config/config.json" "${TARGET}/.config/host-mcp/config.json" && chmod 644 "${TARGET}/.config/host-mcp/config.json"
cp "${MODDIR}/config/token" "${TARGET}/.config/host-mcp/token" && chmod 600 "${TARGET}/.config/host-mcp/token"

echo "[setup] host-mcp deployed to ${TARGET}"
echo "[setup] token: ${TARGET}/.config/host-mcp/token"
