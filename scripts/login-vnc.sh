#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:99}"
mkdir -p /tmp/.X11-unix

Xvfb "$DISPLAY" -screen 0 1365x768x24 -nolisten tcp >/tmp/xvfb.log 2>&1 &
XVFB_PID=$!

cleanup() {
  kill "$WEBSOCKIFY_PID" "$X11VNC_PID" "$XVFB_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

for _ in $(seq 1 50); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  sleep 0.1
done

x11vnc -display "$DISPLAY" -forever -shared -nopw -localhost -rfbport 5900 \
  >/tmp/x11vnc.log 2>&1 &
X11VNC_PID=$!

websockify --web=/usr/share/novnc 6080 localhost:5900 \
  >/tmp/websockify.log 2>&1 &
WEBSOCKIFY_PID=$!

printf '%s\n' 'LinkedIn one-time login UI ready on container port 6080.' >&2
printf '%s\n' 'Keep access bound to host loopback and use an SSH tunnel.' >&2

exec python -m linkedin_mcp_server \
  --login \
  --no-headless \
  --no-auto-import \
  --user-data-dir /home/pwuser/.linkedin-mcp/profile \
  --login-timeout 0
