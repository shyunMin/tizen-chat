#!/usr/bin/env bash
#
# Generate Dart gRPC stubs for chat-ui from Argot .proto definitions.
# Carbon stubs are kept in-tree for the selectable Carbon backend; this script
# only refreshes the Argot side.
#
# Usage:
#   scripts/gen-proto.sh <argot-repo-path>
#
# Example:
#   scripts/gen-proto.sh ../argo-tizen
#
# Prereqs:
#   - protoc on PATH (apt install protobuf-compiler)
#   - protoc-gen-dart on PATH (dart pub global activate protoc_plugin,
#     then ensure ~/.pub-cache/bin is on PATH)

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <argot-repo-path>" >&2
  exit 2
fi

ARGOT_REPO="$1"

if [[ ! -d "$ARGOT_REPO" ]]; then
  echo "error: argot path not found: $ARGOT_REPO" >&2
  exit 1
fi

PROTO_ROOT="$ARGOT_REPO/crates/argot-proto/proto"
V1_DIR="$PROTO_ROOT/argot/v1"

if [[ ! -d "$V1_DIR" ]]; then
  echo "error: expected argot v1 proto dir not found: $V1_DIR" >&2
  exit 1
fi

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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHAT_UI_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT_DIR="$CHAT_UI_ROOT/lib/generated"

V1_PROTOS=(
  "$V1_DIR/chat.proto"
  "$V1_DIR/conversation.proto"
  "$V1_DIR/monitor.proto"
  "$V1_DIR/notify.proto"
  "$V1_DIR/types.proto"
)

for p in "${V1_PROTOS[@]}"; do
  if [[ ! -f "$p" ]]; then
    echo "error: missing proto: $p" >&2
    exit 1
  fi
done

echo "=== chat-ui dart codegen ==="
echo "argot repo : $ARGOT_REPO"
echo "proto root : $PROTO_ROOT"
echo "output     : $OUT_DIR"
echo

mkdir -p "$OUT_DIR"

# Wipe stale argot/v1 stubs so renamed or removed protos (e.g. the retired
# service.proto) don't leave orphaned generated files behind. Carbon stubs
# live under generated/carbon and are untouched.
rm -f "$OUT_DIR/argot/v1/"*.dart

protoc \
  -I"$PROTO_ROOT" \
  --dart_out=grpc:"$OUT_DIR" \
  "${V1_PROTOS[@]}"

echo
echo "Done. Generated dart stubs in $OUT_DIR/argot/v1/"
