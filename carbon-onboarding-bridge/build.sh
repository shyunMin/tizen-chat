#!/usr/bin/env bash
# Build script for carbon-onboarding-bridge.
#
# 전제: cargo tizen으로 미리 빌드한 RPM이 tizen/rpm/sources/ 에 있어야 합니다.
#   없으면 cargo tizen build --release 를 자동으로 실행하여 생성을 시도합니다.
#
# Steps:
#   1. tizen/rpm/sources/{arch}.rpm 존재 확인 (없으면 cargo tizen build)
#   2. git staging + commit (GBS tarball에 RPM 포함)
#   3. gbs build -A {arch} 로 Tizen RPM 생성
#   4. 생성된 RPM을 packaging/ 및 USB(있을 경우)에 복사
#
# Usage:
#   ./build.sh                    # armv7l (default)
#   ARCH=aarch64 ./build.sh       # aarch64
#   USB_DIR=/path ./build.sh

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGING_DIR="$ROOT_DIR/packaging"
SOURCES_DIR="$ROOT_DIR/tizen/rpm/sources"
APP_NAME="carbon-onboarding-bridge"
ARCH="${ARCH:-armv7l}"
USB_DIR="${USB_DIR:-/media/hoon/C052-0E64/move}"

log()  { printf '[build.sh] %s\n' "$*"; }
fail() { printf '[build.sh] ERROR: %s\n' "$*" >&2; exit 1; }
warn() { printf '[build.sh] WARNING: %s\n' "$*" >&2; }

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fail "required command not found: $1"
}

get_version() {
    grep '^version' "$ROOT_DIR/Cargo.toml" | head -1 | sed 's/.*= *"\(.*\)"/\1/'
}

source_rpm_path() {
    local arch="$1"
    local version; version="$(get_version)"
    echo "${SOURCES_DIR}/${APP_NAME}-${version}-1.${arch}.rpm"
}

ensure_rpm() {
    local arch="$1"
    local rpm; rpm="$(source_rpm_path "$arch")"

    if [[ -f "$rpm" ]]; then
        log "$arch RPM found: $rpm"
        return 0
    fi

    log "$arch RPM not found ? running cargo tizen build --release"
    require_cmd cargo

    ARCH="$arch" cargo tizen build --release

    [[ -f "$rpm" ]] || fail \
        "$arch RPM still not found after build.\nExpected: $rpm\nPlace the cargo-tizen RPM output at this path."
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
    # RPM은 gitignore 대상이므로 force-add (GBS tarball에 포함시키기 위해)
    git -C "$ROOT_DIR" add -f "$(source_rpm_path "$ARCH")"

    if git -C "$ROOT_DIR" diff --cached --quiet --exit-code; then
        log "no staged changes, reusing existing HEAD"
        return 0
    fi

    local msg="build: update $APP_NAME $(date '+%Y-%m-%d %H:%M:%S %Z')"
    log "creating git commit: $msg"
    git -C "$ROOT_DIR" commit -m "$msg"
}

find_gbs_rpm() {
    find "$HOME/GBS-ROOT" -type f -name "${APP_NAME}-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debugsource-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debuginfo-*.${ARCH}.rpm" \
        -print 2>/dev/null | sort | tail -n 1
}

main() {
    [[ -d "$PACKAGING_DIR" ]] || fail "packaging directory not found: $PACKAGING_DIR"
    [[ -d "$SOURCES_DIR" ]]   || fail "sources directory not found: $SOURCES_DIR"

    require_cmd gbs
    require_cmd git

    # Step 1: 소스 RPM 확인 (없으면 cargo tizen build 시도)
    ensure_rpm "$ARCH"

    # Step 2: git staging + commit
    local stamp_file
    stamp_file="$(mktemp)"
    trap 'rm -f "$stamp_file"' EXIT
    stage_and_commit_git

    # Step 3: GBS 빌드
    log "running gbs build for arch=$ARCH"
    touch "$stamp_file"
    gbs build -A "$ARCH" --include-all --clean

    # Step 4: 결과 RPM 수집
    local rpm_path
    rpm_path="$(find "$HOME/GBS-ROOT" -type f -name "${APP_NAME}-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debugsource-*.${ARCH}.rpm" \
        ! -name "${APP_NAME}-debuginfo-*.${ARCH}.rpm" \
        -newer "$stamp_file" -print 2>/dev/null | sort | tail -n 1 || true)"
    [[ -n "$rpm_path" ]] || rpm_path="$(find_gbs_rpm)"
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
}

main "$@"
