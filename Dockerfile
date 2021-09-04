FROM ubuntu as setup

# Updates and packages
RUN apt update -y && apt install -y --no-install-recommends curl ca-certificates

# Setup environment variables for easy configuration
ENV litecoin_path="/tmp/litecoin.tar.gz"

# Download LiteCoin Core
ADD https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz ${litecoin_path}

# Download SHA256.asc and validate against it
RUN echo $(curl -fsSL https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-linux-signatures.asc | \
  grep litecoin-0.18.1-x86_64-linux-gnu.tar.gz |  awk '{print $1}') \
  ${litecoin_path} | sha256sum -c

# Unzip litecoin
RUN tar -xvf ${litecoin_path} -C /tmp

FROM ubuntu

# Setup non-root user
RUN adduser non-root

COPY --from=setup --chown=non-root:litecoin /tmp/litecoin-0.18.1/bin/* /usr/local/bin
# Switch to non root
USER non-root
# Startup daemon
ENTRYPOINT ["litecoind"]