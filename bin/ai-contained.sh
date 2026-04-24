#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <path>"
    echo "  path  Path to mount as /workspace (use '.' for current directory)"
    exit 1
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
fi

if [[ $# -lt 1 ]]; then
    usage
fi

readonly WORKSPACE="$(realpath "$1")"
readonly COMPOSE_FILE="$(dirname "$0")/../docker-compose.yaml"
# Docker compose project names can only contain lowercase alphanumeric characters, hyphens, and underscores
readonly PROJECT="$(basename "${WORKSPACE}" | tr '[:upper:]' '[:lower:]' | tr -cs 'a-z0-9_-' '-' | sed 's/^-//;s/-$//')-$$"
readonly USER_ID="$(id -u)"
readonly GROUP_ID="$(id -g)"

export WORKSPACE USER_ID GROUP_ID

cleanup() { docker compose -f "${COMPOSE_FILE}" -p "${PROJECT}" down; }
trap cleanup EXIT

docker compose -f "${COMPOSE_FILE}" -p "${PROJECT}" run --rm -it agent "${@:2}"
