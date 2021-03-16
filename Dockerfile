FROM ubuntu

RUN apt-get update && \
    apt-get -y install curl build-essential automake autoconf git jq

RUN curl -sL https://deb.nodesource.com/setup_10.x -o nodesource_setup.sh 
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# add user
RUN useradd -d /home/app -m -G sudo app
RUN mkdir -m 0755 /app
RUN chown app /app
RUN mkdir -m 0755 /nix
RUN chown app /nix
USER app
ENV USER app

# install nix
RUN curl -L https://nixos.org/nix/install | sh
ENV PATH="/home/app/.nix-profile/bin:${PATH}"
ENV NIX_PATH="/home/app//.nix-defexpr/channels/"

# install dapp tools and solc
RUN nix-env -iA dapp hevm seth solc ethsign -f https://api.github.com/repos/dapphub/dapptools/tarball/dapp/0.28.0
RUN nix-env -iA solc-static-versions.solc_0_5_15 -f https://github.com/dapphub/dapptools/archive/master.tar.gz 

WORKDIR /app
