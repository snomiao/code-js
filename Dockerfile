FROM debian

# curl
RUN apt-get update && apt-get install -y curl

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
    nvm install node && nvm use node && nvm alias default node && \
    npm i -g bun && bun i -g pnpm snocommit tsx typescript && \
    ln -s "$(which node)" /usr/bin/ && \
    ln -s "$(which npm)" /usr/bin/ && \
    ln -s "$(which node)" /usr/local/ && \
    ln -s "$(which npm)" /usr/local/

# latest vscode-server
# RUN curl -fsSL https://aka.ms/install-vscode-server/setup.sh | sh
RUN \
    curl https://az764295.vo.msecnd.net/stable/$(curl https://update.code.visualstudio.com/api/commits/stable/server-linux-x64-web | cut -d '"' -f 2)/vscode-server-linux-x64-web.tar.gz \
    | tar xzvf - && \
    mv -f vscode-server-linux-x64-web vscode-server && \
    chmod +x ./vscode-server/bin/code-server && \
    ln -s /vscode-server/bin/code-server /usr/bin/

## install extensions
RUN code-server serve-local \
    --install-extension "dbaeumer.vscode-eslint" \
    --install-extension "eamodio.gitlens" \
    --install-extension "esbenp.prettier-vscode" \
    --install-extension "ms-azuretools.vscode-docker" \
    --install-extension "nicoespeon.abracadabra" \
    --install-extension "ypresto.vscode-intelli-refactor" \
    --accept-server-license-terms

COPY ./home/.vscode-server/data/Machine/ /root/.vscode-server/data/Machine/

# run vscode without token
# WARN: dont expose it directly into the whole network, instead use a reverse-proxy with auth.
ENV VSCODE_SERVER_PORT=8000
ENV VSCODE_SERVER_HOST=0.0.0.0
CMD code-server serve-local \
    --accept-server-license-terms \
    --host $VSCODE_SERVER_HOST \
    --port $VSCODE_SERVER_PORT \
    --without-connection-token
