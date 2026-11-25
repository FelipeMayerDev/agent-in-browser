FROM node:22-bookworm-slim

ARG TTYD_VERSION=1.7.7
ARG CLAUDE_VERSION=latest

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl git less procps openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && arch="$(uname -m)" \
 && curl -fsSL -o /usr/local/bin/ttyd "https://github.com/tsl0922/ttyd/releases/download/${TTYD_VERSION}/ttyd.${arch}" \
 && chmod +x /usr/local/bin/ttyd \
 && npm install -g "@anthropic-ai/claude-code@${CLAUDE_VERSION}" \
 && npm cache clean --force

# Imagem "node" já tem o usuário node (uid 1000)
USER node
ENV HOME=/home/node \
    CLAUDE_CONFIG_DIR=/home/node/.claude \
    DISABLE_AUTOUPDATER=1
WORKDIR /workspace

EXPOSE 7681
CMD exec ttyd -W ${TTYD_CREDENTIAL:+-c "$TTYD_CREDENTIAL"} -p 7681 -w /workspace $TTYD_ARGS $AGENT_CMD
