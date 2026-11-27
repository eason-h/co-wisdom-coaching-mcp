#!/usr/bin/env bash
set -euo pipefail

ENDPOINT="https://www.cw-coach.com/mcp"
PROTOCOL_VERSION="2025-06-18"

echo "=== 1. initialize ==="
curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "MCP-Protocol-Version: $PROTOCOL_VERSION" \
  -d "{
    \"jsonrpc\": \"2.0\",
    \"id\": 1,
    \"method\": \"initialize\",
    \"params\": {
      \"protocolVersion\": \"$PROTOCOL_VERSION\",
      \"capabilities\": {},
      \"clientInfo\": { \"name\": \"curl-test\", \"version\": \"1.0.0\" }
    }
  }"
echo

echo "=== 2. tools/list ==="
curl -s -X POST "$ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "MCP-Protocol-Version: $PROTOCOL_VERSION" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list"
  }'
echo
