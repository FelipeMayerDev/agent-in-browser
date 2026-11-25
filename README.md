# agent-in-browser

Claude Code, opencode or Codex (TUI) in the browser via [ttyd](https://github.com/tsl0922/ttyd), with Docker Compose.

## Usage

```sh
cp .env.example .env    # AGENT, AUTH_USER, AUTH_PASSWORD, PORT, WORKSPACE
mkdir -p data workspace
docker compose up -d
```

Open `http://<host>:7681` (or whatever `PORT` you set).

## How it works

- **No build:** no Dockerfile, no CI. Compose uses the public `buildpack-deps:bookworm-scm` image (ships with curl, git and bash).
- On first start, `start.sh` downloads ttyd and the selected agent into the `DATA` volume. Later starts just launch it.
- `AGENT=claude|opencode|codex`, each installed from its official installer/binary.
- Browser login set via `AUTH_USER` / `AUTH_PASSWORD`. Empty = no password.

## Configuration (`.env`)

| Variable | Default | Description |
|---|---|---|
| `AGENT` | `claude` | `claude`, `opencode` or `codex` |
| `AUTH_USER` / `AUTH_PASSWORD` | empty | browser login (ttyd basic auth) |
| `BIND_ADDR` / `PORT` | `0.0.0.0` / `7681` | host address/port to listen on. Use your Tailscale/VPN IP to keep it off the LAN |
| `TTYD_ARGS` | empty | extra ttyd flags, e.g. `-t fontSize=16` |
| `TTYD_VERSION` | `1.7.7` | ttyd version to download |
| `PUID` / `PGID` | `1000` | user the container runs as (must own `DATA` and `WORKSPACE`) |
| `DATA` | `./data` | container HOME: binaries, agent login and config |
| `WORKSPACE` | `./workspace` | folder mounted at `/workspace`, where the agent works |

## Agent login

Done once, persisted in `DATA`.

- **claude:** prompts for `/login` in the TUI.
- **opencode:** `docker compose exec agent opencode auth login`
- **codex:** `docker compose exec agent codex login --device-auth`

## Notes

- Each browser tab spawns a new agent process; closing the tab ends the session.
- Claude and opencode auto-update. To reinstall/update any agent, delete its binary in `data/.local/bin` (or `data/.opencode`) and run `docker compose restart`.
- Switching `AGENT` just needs `docker compose up -d`; the new agent is downloaded on start.
