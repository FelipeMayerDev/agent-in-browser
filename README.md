# agent-in-browser

Claude Code (TUI) no navegador via [ttyd](https://github.com/tsl0922/ttyd), em container.

```sh
cp .env.example .env   # ajuste senha, porta, workspace
mkdir -p data/claude workspace
docker compose up -d --build
```

Abra `http://<host>:7681`. No primeiro acesso o Claude pede login (`/login`); fica salvo em `CLAUDE_DATA`.

Cada aba abre um processo novo do `AGENT_CMD`; fechar a aba encerra a sessão.
Atualizar o Claude: `docker compose build --pull && docker compose up -d`.

As pastas em `CLAUDE_DATA` e `WORKSPACE` precisam ser do uid 1000 (usuário `node` no container).
