# ============================================================
# Stage 1: Build
# Compiles CMaNGOS-TBC from source with all features enabled.
# cmake fetches playerbots automatically via FetchContent.
# ============================================================
FROM ubuntu:22.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    g++ \
    g++-12 \
    cmake \
    git \
    autoconf \
    automake \
    make \
    libtool \
    patch \
    default-libmysqlclient-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libboost-all-dev \
    libreadline-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy our fork (including module system patch on dev branch)
WORKDIR /source
COPY . .

# Build CMaNGOS
# - BUILD_PLAYERBOTS: cmake auto-fetches cmangos/playerbots via FetchContent
# - BUILD_AHBOT: built into core, no separate repo needed
# - BUILD_MODULES: enables the module system hooks we patched in
# - BUILD_GIT_ID: embeds current commit hash in server info
RUN mkdir -p /build && cd /build && \
    cmake /source \
        -DCMAKE_INSTALL_PREFIX=/opt/mangos \
        -DCMAKE_C_COMPILER=gcc-12 \
        -DCMAKE_CXX_COMPILER=g++-12 \
        -DPCH=1 \
        -DDEBUG=0 \
        -DBUILD_PLAYERBOTS=ON \
        -DBUILD_AHBOT=ON \
        -DBUILD_MODULES=ON \
        -DBUILD_GIT_ID=ON \
    && make -j$(nproc) \
    && make install
    
# ============================================================
# Stage 2: Runtime
# Minimal image containing only compiled binaries and
# their runtime dependencies. Build tools are discarded.
# ============================================================
FROM ubuntu:22.04 AS runtime

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libboost-all-dev \
    libreadline-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/mangos /opt/mangos

WORKDIR /opt/mangos/bin