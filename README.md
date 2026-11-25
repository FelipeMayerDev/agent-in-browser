# agent-in-browser

Claude Code (TUI) no navegador via [ttyd](https://github.com/tsl0922/ttyd), em container.

```sh
cp .env.example .env   # ajuste senha, porta, workspace
mkdir -p data/claude workspace
docker compose up -d
```

A imagem `ghcr.io/felipemayerdev/agent-in-browser:latest` é publicada pelo GitHub Actions (amd64/arm64) a cada push e toda segunda, com o Claude Code mais recente. Pra buildar local: `docker compose up -d --build`.

Abra `http://<host>:7681`. No primeiro acesso o Claude pede login (`/login`); fica salvo em `CLAUDE_DATA`.

Cada aba abre um processo novo do `AGENT_CMD`; fechar a aba encerra a sessão.
Atualizar: `docker compose pull && docker compose up -d`.

As pastas em `CLAUDE_DATA` e `WORKSPACE` precisam ser do uid 1000 (usuário `node` no container).
