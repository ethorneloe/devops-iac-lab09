#!/usr/bin/env bash

echo "==================================="
echo "Running on Self-Hosted Runner"
echo "==================================="
echo ""

echo "System Information:"
echo "-----------------------------------"
echo "OS: $(uname -s)"
echo "Kernel: $(uname -r)"
echo "Architecture: $(uname -m)"
echo "Full uname: $(uname -a)"
echo ""

echo "Runner Environment:"
echo "-----------------------------------"
echo "Hostname: $(hostname)"
echo "Current user: $(whoami)"
echo "User home: $HOME"
echo "Working directory: $(pwd)"
echo ""

echo "Network Information:"
echo "-----------------------------------"
echo "IP Address(es):"
ip addr show 2>/dev/null | grep "inet " | awk '{print "  " $2}' || \
  ifconfig 2>/dev/null | grep "inet " | awk '{print "  " $2}'
echo ""

echo "Runner Details:"
echo "-----------------------------------"
if [ -n "$RUNNER_NAME" ]; then
  echo "Runner Name: $RUNNER_NAME"
  echo "Runner OS: $RUNNER_OS"
  echo "Runner Architecture: $RUNNER_ARCH"
  echo "Runner Workspace: $RUNNER_WORKSPACE"
else
  echo "Runner environment variables not set (running locally?)"
fi
echo ""

echo "Available Resources:"
echo "-----------------------------------"
echo "CPU Cores: $(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 'unknown')"
echo "Memory: $(free -h 2>/dev/null | awk '/^Mem:/ {print $2 " total, " $7 " available"}' || echo 'N/A')"
echo "Disk Space:"
df -h / | awk 'NR==2 {print "  Total: " $2 ", Used: " $3 ", Available: " $4 " (" $5 " used)"}'
echo ""

echo "==================================="
echo "Demo script completed successfully!"
echo "==================================="
