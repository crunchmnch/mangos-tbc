# === Kirby TBC Server Shutdown Script ===
# Gracefully shuts down both dev and live mangos servers.
# Run this before rebooting or shutting down Windows.

Write-Output "=== Kirby TBC Server Shutdown ==="

Write-Output "Stopping dev containers..."
Set-Location "D:\Projects\mangos-tbc\docker\server-dev"
docker compose down

Write-Output "Stopping live containers..."
Set-Location "D:\Projects\mangos-tbc\docker\server-live"
docker compose down

Write-Output "=== Shutdown complete. Safe to reboot. ==="