# agent-in-browser

Claude Code, opencode ou Codex (TUI) no navegador via [ttyd](https://github.com/tsl0922/ttyd), com Docker Compose.

## Uso

```sh
cp .env.example .env    # AGENT, AUTH_USER, AUTH_PASSWORD, PORT, WORKSPACE
mkdir -p data workspace
docker compose up -d
```

Abra `http://<host>:7681` (ou a `PORT` definida).

## Como funciona

- **Sem build:** sem Dockerfile e sem CI. O compose usa a imagem pública `buildpack-deps:bookworm-scm` (já tem curl, git e bash).
- Na primeira subida o `start.sh` baixa o ttyd e o agente escolhido pro volume `DATA`. Nas próximas, só inicia.
- `AGENT=claude|opencode|codex`, cada um pelo instalador ou binário oficial.
- Login do navegador em `AUTH_USER` / `AUTH_PASSWORD`. Vazio = sem senha.

## Configuração (`.env`)

| Variável | Padrão | Descrição |
|---|---|---|
| `AGENT` | `claude` | `claude`, `opencode` ou `codex` |
| `AUTH_USER` / `AUTH_PASSWORD` | vazio | login do navegador (basic auth do ttyd) |
| `BIND_ADDR` / `PORT` | `0.0.0.0` / `7681` | onde escuta no host. Use o IP do Tailscale/VPN pra não expor na LAN |
| `TTYD_ARGS` | vazio | flags extras do ttyd, ex: `-t fontSize=16` |
| `TTYD_VERSION` | `1.7.7` | versão do ttyd baixada |
| `PUID` / `PGID` | `1000` | usuário que roda no container (dono de `DATA` e `WORKSPACE`) |
| `DATA` | `./data` | HOME do container: binários, login e config do agente |
| `WORKSPACE` | `./workspace` | pasta montada em `/workspace`, onde o agente trabalha |

## Login do agente

Feito uma vez e salvo em `DATA`.

- **claude:** pede `/login` na própria tela.
- **opencode:** `docker compose exec agent opencode auth login`
- **codex:** `docker compose exec agent codex login --device-auth`

## Notas

- Cada aba abre um processo novo do agente. Fechar a aba encerra a sessão.
- Claude e opencode se atualizam sozinhos. Pra reinstalar ou atualizar qualquer um, apague o binário em `data/.local/bin` (ou `data/.opencode`) e rode `docker compose restart`.
- Trocar de `AGENT` só exige `docker compose up -d`. O novo agente é baixado na subida.
