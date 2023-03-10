FROM node:latest
RUN npm i -g pnpm snocommit tsx typescript
RUN apt-get update && apt-get install -y git curl && \
    curl -fsSL https://aka.ms/install-vscode-server/setup.sh | sh
ENV PORT=8000
# COPY ./vscode/* /root/.vscode-server/data/Machine/
COPY ./home/.vscode-server/data/Machine/ /root/.vscode-server/data/Machine/
RUN code-server serve-local \
    --install-extension "dbaeumer.vscode-eslint" \
    --install-extension "eamodio.gitlens" \
    --install-extension "esbenp.prettier-vscode" \
    --install-extension "ms-azuretools.vscode-docker" \
    --install-extension "nicoespeon.abracadabra" \
    --install-extension "tabnine.tabnine-vscode" \
    --install-extension "yo1dog.cursor-align" \
    --install-extension "ypresto.vscode-intelli-refactor" \
    --accept-server-license-terms
CMD code-server serve-local \
    --accept-server-license-terms \
    --host 0.0.0.0 \
    --port $PORT \
    --without-connection-token
