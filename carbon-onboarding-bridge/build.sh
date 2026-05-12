#!/usr/bin/env bash
# Build script for carbon-onboarding-bridge.
#
# Steps:
#   1. Cross-compile Rust binary for the target architecture.
#   2. Stage the binary into tizen/rpm/sources/.
#   3a. (GBS available)   Run gbs build to produce an RPM.
#   3b. (GBS unavailable) Run rpmbuild directly using tizen/rpm/ spec.
#   4. Copy the RPM to packaging/ and optionally to a USB drive.
#
# Usage:
#   ./build.sh                    # armv7l (default), auto-detect gbs/rpmbuild
#   ARCH=aarch64 ./build.sh       # aarch64
#   USB_DIR=/path ./build.sh

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_OS_ROOT="$(cd "$ROOT_DIR/../.." && pwd)"
PACKAGING_DIR="$ROOT_DIR/packaging"
SOURCES_DIR="$ROOT_DIR/tizen/rpm/sources"
APP_NAME="carbon-onboarding-bridge"
ARCH="${ARCH:-armv7l}"
USB_DIR="${USB_DIR:-/media/hoon/C052-0E64/move}"

# Rust cross-compile targets
declare -A RUST_TARGETS=(
    [armv7l]="armv7-unknown-linux-gnueabihf"
    [aarch64]="aarch64-unknown-linux-gnu"
)

# Staged binary name (aarch64 gets a suffix to keep both in sources/)
declare -A STAGED_NAMES=(
    [armv7l]="$APP_NAME"
    [aarch64]="$APP_NAME.aarch64"
)

log()  { printf '[build.sh] %s\n' "$*"; }
fail() { printf '[build.sh] ERROR: %s\n' "$*" >&2; exit 1; }
warn() { printf '[build.sh] WARNING: %s\n' "$*" >&2; }

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

ensure_git_repo() {
    git -C "$ROOT_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 && return 0

    log "initializing temporary git repository for gbs"
    git -C "$ROOT_DIR" init
    git -C "$ROOT_DIR" config user.name "build"
    git -C "$ROOT_DIR" config user.email "build@local"
}

stage_and_commit_git() {
    ensure_git_repo

    log "staging source changes for gbs"
    git -C "$ROOT_DIR" add \
        build.rs Cargo.toml Cargo.lock \
        proto src packaging tizen build.sh

    if git -C "$ROOT_DIR" diff --cached --quiet --exit-code; then
        log "no staged changes, reusing existing HEAD"
        return 0
    fi

    local msg="build: update $APP_NAME $(date '+%Y-%m-%d %H:%M:%S %Z')"
    log "creating git commit: $msg"
    git -C "$ROOT_DIR" commit -m "$msg"
}

find_latest_rpm() {
    find "$HOME/GBS-ROOT" -type f -name "${APP_NAME}-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debugsource-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debuginfo-*.${ARCH}.rpm" \
        -print 2>/dev/null | sort | tail -n 1
}

build_with_rpmbuild() {
    require_cmd rpmbuild

    local spec="$ROOT_DIR/tizen/rpm/${APP_NAME}.spec"
    local rpmbuild_root="$ROOT_DIR/target/rpmbuild"
    local version; version="$(grep '^version' "$ROOT_DIR/Cargo.toml" | head -1 | sed 's/.*= *"\(.*\)"/\1/')"
    local release=1

    log "building RPM with rpmbuild (arch=$ARCH, version=$version)"

    # Set up rpmbuild directory tree
    mkdir -p "$rpmbuild_root"/{SPECS,SOURCES,BUILD,RPMS,SRPMS}

    # Stage sources expected by tizen/rpm spec (Source0~Source3)
    cp -f "${SOURCES_DIR}/${STAGED_NAMES[$ARCH]}"                     "$rpmbuild_root/SOURCES/${APP_NAME}"
    cp -f "$PACKAGING_DIR/${APP_NAME}.service"                        "$rpmbuild_root/SOURCES/${APP_NAME}.service"
    cp -f "$PACKAGING_DIR/carbon-daemon-config-watch.path"            "$rpmbuild_root/SOURCES/carbon-daemon-config-watch.path"
    cp -f "$PACKAGING_DIR/carbon-daemon-config-reload.service"        "$rpmbuild_root/SOURCES/carbon-daemon-config-reload.service"
    cp -f "$spec"                                     "$rpmbuild_root/SPECS/"

    rpmbuild \
        --define "_topdir $rpmbuild_root" \
        --define "_target_cpu $ARCH" \
        --target "$ARCH" \
        -bb "$rpmbuild_root/SPECS/${APP_NAME}.spec"

    local rpm_path
    rpm_path="$(find "$rpmbuild_root/RPMS" -name "${APP_NAME}-*.rpm" \
        ! -name "${APP_NAME}-debuginfo-*.rpm" \
        -print | sort | tail -n 1)"
    [[ -n "$rpm_path" ]] || fail "rpmbuild did not produce an RPM"

    local packaging_rpm="$PACKAGING_DIR/$(basename "$rpm_path")"
    log "copying RPM to packaging/: $packaging_rpm"
    cp -f "$rpm_path" "$packaging_rpm"

    if [[ -d "$USB_DIR" ]]; then
        log "copying RPM to USB: $USB_DIR"
        cp -f "$rpm_path" "$USB_DIR/"
    else
        warn "USB directory not found: $USB_DIR (skipping)"
    fi

    log "done"
    log "RPM: $packaging_rpm"
}

cross_compile() {
    local rust_target="${RUST_TARGETS[$ARCH]:-}"
    [[ -n "$rust_target" ]] || fail "unsupported ARCH=$ARCH (supported: ${!RUST_TARGETS[*]})"

    require_cmd cargo

    log "cross-compiling for $ARCH ($rust_target)"
    cargo build --release --target "$rust_target" --manifest-path "$ROOT_DIR/Cargo.toml"

    local built="$ROOT_DIR/target/$rust_target/release/$APP_NAME"
    [[ -f "$built" ]] || fail "expected binary not found: $built"

    local staged="${SOURCES_DIR}/${STAGED_NAMES[$ARCH]}"
    log "staging binary: $staged"
    cp -f "$built" "$staged"
    chmod 0755 "$staged"
}

main() {
    require_cmd cargo
    [[ -d "$PACKAGING_DIR" ]] || fail "packaging directory not found: $PACKAGING_DIR"
    [[ -d "$SOURCES_DIR" ]]   || fail "sources directory not found: $SOURCES_DIR"

    # Step 1: cross-compile
    cross_compile

    if command -v gbs >/dev/null 2>&1; then
        # Step 2a: GBS path
        require_cmd git

        local stamp_file
        stamp_file="$(mktemp)"
        trap 'rm -f "$stamp_file"' EXIT
        stage_and_commit_git

        log "running gbs build for arch=$ARCH"
        touch "$stamp_file"
        gbs build -A "$ARCH" --include-all --clean

        local rpm_path
        rpm_path="$(find "$HOME/GBS-ROOT" -type f -name "${APP_NAME}-*.${ARCH}.rpm" \
            ! -name "${APP_NAME}-debugsource-*.${ARCH}.rpm" \
            ! -name "${APP_NAME}-debuginfo-*.${ARCH}.rpm" \
            -newer "$stamp_file" -print 2>/dev/null | sort | tail -n 1 || true)"
        [[ -n "$rpm_path" ]] || rpm_path="$(find_latest_rpm)"
        [[ -n "$rpm_path" ]] || fail "built RPM not found under $HOME/GBS-ROOT"

        local packaging_rpm="$PACKAGING_DIR/$(basename "$rpm_path")"
        [[ "$rpm_path" == "$packaging_rpm" ]] || {
            log "copying RPM to packaging/: $packaging_rpm"
            cp -f "$rpm_path" "$packaging_rpm"
        }

        if [[ -d "$USB_DIR" ]]; then
            log "copying RPM to USB: $USB_DIR"
            cp -f "$rpm_path" "$USB_DIR/"
        else
            warn "USB directory not found: $USB_DIR (skipping)"
        fi

        log "done"
        log "RPM: $rpm_path"
    else
        # Step 2b: rpmbuild fallback (no GBS)
        warn "gbs not found — falling back to rpmbuild"
        build_with_rpmbuild
    fi
}

main "$@"
