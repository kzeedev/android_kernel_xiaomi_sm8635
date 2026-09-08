#!/usr/bin/env bash
set -euo pipefail

KERNEL_DIR="${1:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
CLANG_DIR="${2:-${KERNEL_DIR}/clang}"
DEVICE="${3:-peridot}"
MSM_ARCH="${4:-palawan}"

export ARCH=arm64
export LLVM=1
export PATH="${CLANG_DIR}/bin:${PATH}"

cd "${KERNEL_DIR}"

DEFCONFIGS=(arch/arm64/configs/gki_defconfig)
if [ -f "arch/arm64/configs/vendor/${MSM_ARCH}_GKI.config" ]; then
    DEFCONFIGS+=("arch/arm64/configs/vendor/${MSM_ARCH}_GKI.config")
fi
if [ -f "arch/arm64/configs/vendor/${DEVICE}_GKI.config" ]; then
    DEFCONFIGS+=("arch/arm64/configs/vendor/${DEVICE}_GKI.config")
fi

mkdir -p out
KCONFIG_CONFIG="${KERNEL_DIR}/out/.config" \
    scripts/kconfig/merge_config.sh -m -r "${DEFCONFIGS[@]}"

printf '\n' >> out/.config
./scripts/config --file out/.config -e LTO_CLANG_THIN -d LTO_CLANG_FULL

make O=out olddefconfig

make O=out -j"$(nproc)" Image

echo "Image built at out/arch/arm64/boot/Image"
