FROM debian:latest

# latest git with lfs
RUN echo "deb http://deb.debian.org/debian bullseye-backports main" >/etc/apt/sources.list.d/bullseye-backports.list && \
    apt update && \
    apt install --allow-downgrades -y git/bullseye-backports && \
    git --version
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get update && apt-get install git-lfs

# latest nvm & node
RUN curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install node && nvm use node && nvm alias default node

# latest vscode-server
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://aka.ms/install-vscode-server/setup.sh | sh
RUN npm i -g bun && bun i -g pnpm snocommit tsx typescript
ENV VSCODE_SERVER_PORT=8000

## COPY ./vscode/* /root/.vscode-server/data/Machine/
COPY ./home/.vscode-server/data/Machine/ /root/.vscode-server/data/Machine/

## install extensions
RUN cat /usr/local/bin/code-server
RUN code-server serve-local \
    --install-extension "dbaeumer.vscode-eslint" \
    --install-extension "eamodio.gitlens" \
    --install-extension "esbenp.prettier-vscode" \
    --install-extension "ms-azuretools.vscode-docker" \
    --install-extension "nicoespeon.abracadabra" \
    --install-extension "ypresto.vscode-intelli-refactor" \
    --accept-server-license-terms
# run vscode without token
# WARN: dont expose it directly into the whole network, instead use a reverse-proxy with auth.
CMD code-server serve-local \
    --accept-server-license-terms \
    --host 0.0.0.0 \
    --port $VSCODE_SERVER_PORT \
    --without-connection-token
