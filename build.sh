#!/bin/bash
# Build miclaw_root_helper KSU module
# Usage: ./build.sh [version]

set -e

VERSION="${1:-v3.0}"
HOSTMCP_VERSION="2.0.2"
OUTPUT="miclaw_root_helper_${VERSION}.zip"

TMPDIR=$(mktemp -d)
MODULE_DIR="${TMPDIR}/miclaw_root_helper"

echo "[build] version=${VERSION} host-mcp=${HOSTMCP_VERSION}"

# Copy module files
cp -r module/* "${MODULE_DIR}/"
mkdir -p "${MODULE_DIR}"
cp -r module/* "${MODULE_DIR}/"

# Download host-mcp if not present
ARCH="aarch64"
DEB_URL="https://github.com/mark3labs/mcphost/releases/download/v${HOSTMCP_VERSION}/host-mcp_${HOSTMCP_VERSION}_${ARCH}.deb"

echo "[build] downloading host-mcp v${HOSTMCP_VERSION}..."
if command -v curl >/dev/null 2>&1; then
  curl -sL -o "${TMPDIR}/host-mcp.deb" "${DEB_URL}"
elif command -v wget >/dev/null 2>&1; then
  wget -q -O "${TMPDIR}/host-mcp.deb" "${DEB_URL}"
else
  echo "[ERR] curl or wget required"
  exit 1
fi

# Extract binary from deb
mkdir -p "${TMPDIR}/deb_extract"
dpkg-deb -x "${TMPDIR}/host-mcp.deb" "${TMPDIR}/deb_extract"
cp "${TMPDIR}/deb_extract/data/data/com.termux/files/usr/bin/host-mcp" "${MODULE_DIR}/host-mcp"
chmod 755 "${MODULE_DIR}/host-mcp"

# Package
( cd "${TMPDIR}" && zip -r "${OUTPUT}" miclaw_root_helper/ )
cp "${TMPDIR}/${OUTPUT}" .

# Cleanup
rm -rf "${TMPDIR}"

echo "[build] done: ${OUTPUT} ($(du -h ${OUTPUT} | cut -f1))"
