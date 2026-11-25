# agent-in-browser

Claude Code, opencode ou Codex (TUI) no navegador via [ttyd](https://github.com/tsl0922/ttyd). Sem build: usa a imagem pública `buildpack-deps:bookworm-scm` e, na primeira subida, baixa o ttyd e o agente escolhido pro volume `DATA`.

```sh
cp .env.example .env   # AGENT, AUTH_USER, AUTH_PASSWORD, porta, workspace
mkdir -p data workspace
docker compose up -d
```

Abra `http://<host>:7681`.

## Login do agente

Fica salvo em `DATA`, só precisa fazer uma vez.

- **claude**: no primeiro acesso ele pede login (`/login`); cole o código.
- **opencode**: `docker compose exec agent opencode auth login`
- **codex**: `docker compose exec agent codex login --device-auth`

## Notas

- Cada aba abre um processo novo do agente; fechar a aba encerra a sessão.
- Claude e opencode se atualizam sozinhos. Pra reinstalar/atualizar qualquer um: apague o binário em `data/.local/bin` (ou `data/.opencode`) e `docker compose restart`.
- `DATA` e `WORKSPACE` precisam ser do `PUID`/`PGID` (padrão 1000).
