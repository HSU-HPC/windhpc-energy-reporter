#! /usr/bin/env bash
#
# Copyright (c) 2025       Helmut-Schmidt-Universität/
#                          Universität der Bundeswehr Hamburg.  All rights reserved.
#
# Author: Ruben Horn
#

set -euo pipefail

cd "$(dirname "$0")"   # Go to <root>/utils
cd ..                  # Go to <root>

########################################
# Check if Python >= 3.6
########################################
if ! command -v python3 >/dev/null 2>&1; then
    echo "python3 not found"
    exit 1
fi

PY_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
REQUIRED="3.6"

if [ "$(printf '%s\n' "$REQUIRED" "$PY_VERSION" | sort -V | head -n1)" != "$REQUIRED" ]; then
    echo "Python >= 3.6 required (found $PY_VERSION)"
    exit 1
fi

########################################
# Check if .env exists
########################################
if [ ! -f ".env" ]; then
    echo ".env file not found in $(pwd)"
    exit 1
fi

########################################
# Install location
########################################
INSTALL_DIR="$HOME/.local/share/windhpc-energy-reporter"
mkdir -p "$INSTALL_DIR"

for FILE in energy-reporter.py requirements.txt .env; do
    cp "$FILE" "$INSTALL_DIR/"
done

cd "$INSTALL_DIR"

########################################
# Set up Python venv
########################################
python3 -m venv .venv
# shellcheck source=/dev/null
source .venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

########################################
# Create report-job-energy helper script
########################################
BIN=report-job-energy
cat > $BIN <<'EOF'
#! /usr/bin/env bash
set -euo pipefail

END=$(date +%s)

# Detect scheduler and determine START + NODES
if [ -n "${SLURM_JOB_ID:-}" ]; then
    START=$(date -d "$(scontrol show job "$SLURM_JOB_ID" | awk -F= '/StartTime/ {print $2}' | awk '{print $1}')" +%s)
    mapfile -t NODE_ARRAY < <(scontrol show hostnames "$SLURM_JOB_NODELIST")
elif [ -n "${PBS_JOBID:-}" ]; then
    START=$(date -d "$PBS_O_WORKDIR" +%s 2>/dev/null || date +%s)
    mapfile -t NODE_ARRAY < <(sort -u "$PBS_NODEFILE")
else
    echo "No supported scheduler detected (Not called from a Slurm or PBS)"
    exit 1
fi

cd "$(dirname "$0")"
source .venv/bin/activate

python3 energy-reporter.py \
    --start "$START" \
    --end "$END" \
    "${NODE_ARRAY[@]}"
EOF

chmod +x $BIN

########################################
# Add directory to PATH persistently
########################################
SHELL_RC="$HOME/.bashrc"

if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\" # $BIN" >> "$SHELL_RC"
    echo "Added $INSTALL_DIR to PATH in $SHELL_RC"
    echo "Run: source $SHELL_RC"
fi

echo "Installation of $BIN complete."