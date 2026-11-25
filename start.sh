#!/bin/sh
# Na primeira subida baixa ttyd e o agente pro $HOME (volume); depois só inicia.
set -e
bin="$HOME/.local/bin"
arch="$(uname -m)"
ttyd="$bin/ttyd-$TTYD_VERSION"
mkdir -p "$bin"

if [ ! -x "$ttyd" ]; then
  curl -fsSL -o "$ttyd" "https://github.com/tsl0922/ttyd/releases/download/$TTYD_VERSION/ttyd.$arch"
  chmod +x "$ttyd"
fi

if ! command -v "$AGENT" >/dev/null; then
  case "$AGENT" in
    claude)   curl -fsSL https://claude.ai/install.sh | bash ;;
    opencode) curl -fsSL https://opencode.ai/install | bash ;;
    codex)    curl -fsSL "https://github.com/openai/codex/releases/latest/download/codex-$arch-unknown-linux-musl.tar.gz" \
                | tar -xz -O > "$bin/codex" && chmod +x "$bin/codex" ;;
    *)        echo "AGENT inválido: $AGENT (claude|opencode|codex)" >&2; exit 1 ;;
  esac
fi

cred=""
[ -n "$AUTH_USER" ] && [ -n "$AUTH_PASSWORD" ] && cred="$AUTH_USER:$AUTH_PASSWORD"
exec "$ttyd" -W ${cred:+-c "$cred"} -p 7681 -w /workspace $TTYD_ARGS "$AGENT"
