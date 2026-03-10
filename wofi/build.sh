#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
cat colors.css base.css > style.css
