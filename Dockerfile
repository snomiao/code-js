FROM node:latest
RUN npm i -g pnpm snocommit tsx typescript

RUN apt-get update && apt-get install -y git curl && \
    curl -fsSL https://aka.ms/install-vscode-server/setup.sh | sh
ENV PORT=8000
RUN code-server serve-local --accept-server-license-terms \
    --install-extension tabnine.tabnine-vscode \
    --install-extension tabnine.tabnine-vscode
CMD code-server serve-local \
    --accept-server-license-terms \
    --host 0.0.0.0 \
    --port $PORT \
    --without-connection-token
