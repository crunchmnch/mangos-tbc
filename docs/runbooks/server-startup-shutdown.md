# Runbook: Server Startup and Shutdown

## Startup (after fresh boot or manual shutdown)

### Prerequisites
- Docker Desktop must be running before starting containers
- Tailscale auto-starts on boot — no action needed

### Step 1 — Start Docker Desktop
Open Docker Desktop from the Start menu. Wait until the whale icon
in the system tray stops animating and shows "Docker Desktop is running".

Note: Docker Desktop is configured to auto-start on login. After a normal
reboot this step may not be needed — check the system tray first.

### Step 2 — Start both servers
Run the startup script from VSCode (open file, press F5) or from PowerShell:

```powershell
& "D:\Projects\mangos-tbc\scripts\startup-servers.ps1"
```

Both dev and live containers will start. Expect ~10 seconds for databases
to become healthy before mangosd and realmd start.

### Step 3 — Verify
```powershell
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Expected: six containers running — three dev, three live.

## Shutdown (before reboot or powering off)

### Step 1 — Run the shutdown script
Run from VSCode (open file, press F5) or from PowerShell:

```powershell
& "D:\Projects\mangos-tbc\scripts\shutdown-servers.ps1"
```

This gracefully stops both compose stacks. Docker sends SIGTERM to each
process and waits for clean exit before removing containers.

### Step 2 — Shut down Windows normally
Once the script completes and shows "Shutdown complete. Safe to reboot."
it is safe to reboot or power off.

## Notes
- Never kill Docker Desktop while containers are running — always run the
  shutdown script first
- `restart: unless-stopped` in both compose files means containers restart
  automatically if Docker Desktop restarts after a crash
- Tailscale requires no manual action — it auto-starts and maintains the
  100.78.207.105 address automatically