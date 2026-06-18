# === Kirby TBC Server Startup Script ===
# Starts both dev and live mangos servers.
# Requires Docker Desktop to already be running.

Write-Output "=== Kirby TBC Server Startup ==="

Write-Output "Starting dev containers..."
Set-Location "D:\Projects\mangos-tbc\docker\server-dev"
docker compose up -d

Write-Output "Starting live containers..."
Set-Location "D:\Projects\mangos-tbc\docker\server-live"
docker compose up -d

Write-Output "=== Startup complete. ==="