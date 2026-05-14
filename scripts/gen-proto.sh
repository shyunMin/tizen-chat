#!/usr/bin/env bash
#
# Generate Dart gRPC stubs for chat-ui from carbon v2 .proto definitions.
#
# Usage:
#   scripts/gen-proto.sh <carbon-repo-path>
#
# Example:
#   scripts/gen-proto.sh ../carbon
#   scripts/gen-proto.sh /home/wonki/dev/tizenaios-workspace/carbon
#
# Prereqs:
#   - protoc on PATH (apt install protobuf-compiler)
#   - protoc-gen-dart on PATH (dart pub global activate protoc_plugin,
#     then ensure ~/.pub-cache/bin is on PATH)

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <carbon-repo-path>" >&2
  exit 2
fi

CARBON_REPO="$1"

if [[ ! -d "$CARBON_REPO" ]]; then
  echo "error: carbon path not found: $CARBON_REPO" >&2
  exit 1
fi

PROTO_ROOT="$CARBON_REPO/crates/core/proto/proto"
V2_DIR="$PROTO_ROOT/carbon/v2"

if [[ ! -d "$V2_DIR" ]]; then
  echo "error: expected v2 proto dir not found: $V2_DIR" >&2
  echo "       (is this really the carbon repo root?)" >&2
  exit 1
fi

# Preflight: required tools.
if ! command -v protoc >/dev/null 2>&1; then
  echo "error: protoc not on PATH. install protobuf-compiler." >&2
  exit 1
fi
if ! command -v protoc-gen-dart >/dev/null 2>&1; then
  echo "error: protoc-gen-dart not on PATH." >&2
  echo "       run: dart pub global activate protoc_plugin" >&2
  echo "       and ensure ~/.pub-cache/bin is on PATH." >&2
  exit 1
fi

# chat-ui repo root = parent of this script's dir.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHAT_UI_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$CHAT_UI_ROOT/lib/generated"

# Enumerate v2 protos explicitly (mirrors carbon/scripts/gen-stubs.sh
# convention — no glob, so new services don't slip in silently).
V2_PROTOS=(
  "$V2_DIR/common.proto"
  "$V2_DIR/session_service.proto"
  "$V2_DIR/ingress_service.proto"
  "$V2_DIR/event_service.proto"
  "$V2_DIR/schedule_service.proto"
  "$V2_DIR/skill_service.proto"
  "$V2_DIR/thread_service.proto"
  "$V2_DIR/control_service.proto"
  "$V2_DIR/settings_service.proto"
)

for p in "${V2_PROTOS[@]}"; do
  if [[ ! -f "$p" ]]; then
    echo "error: missing proto: $p" >&2
    exit 1
  fi
done

echo "=== chat-ui dart codegen ==="
echo "carbon repo : $CARBON_REPO"
echo "proto root  : $PROTO_ROOT"
echo "output      : $OUT_DIR"
echo

mkdir -p "$OUT_DIR"

protoc \
  -I"$PROTO_ROOT" \
  --dart_out=grpc:"$OUT_DIR" \
  "${V2_PROTOS[@]}"

echo
echo "Done. Generated dart stubs in $OUT_DIR/carbon/v2/"
