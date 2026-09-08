#!/usr/bin/env bash
set -euo pipefail

KERNEL_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
BOOT_IMG_URL="${BOOT_IMG_URL:-}"
KSUD_VERSION="${KSUD_VERSION:-v3.3.0}"

DIST_DIR="${KERNEL_DIR}/dist"
mkdir -p "${DIST_DIR}"

cp "${KERNEL_DIR}/out/arch/arm64/boot/Image" "${DIST_DIR}/Image"
cp "${KERNEL_DIR}/out/.config" "${DIST_DIR}/config"
