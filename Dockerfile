FROM debian:bookworm-slim

ARG VERSION=19

RUN apt-get update && apt-get install -y lsb-release wget software-properties-common gnupg
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc

# workaround, see https://github.com/hof/bookworm-apt-add-repository-issue
RUN echo "#" | tee /etc/apt/sources.list

RUN apt-add-repository "deb http://apt.llvm.org/bookworm/ llvm-toolchain-bookworm-${VERSION} main"

RUN apt-get update && apt-get install -y clang-${VERSION} lld-${VERSION} libc++-${VERSION}-dev libc++abi-${VERSION}-dev \
    lldb-${VERSION} ninja-build git cmake libncurses6

ENV PATH=/usr/lib/llvm-${VERSION}/bin:$PATH
ENV CC=clang-${VERSION}
ENV CXX=clang++-${VERSION}
ENV LDFLAGS="-fuse-ld=lld"
ENV CMAKE_EXE_LINKER_FLAGS="-fuse-ld=lld"
ENV CMAKE_SHARED_LINKER_FLAGS="-fuse-ld=lld"
ENV CMAKE_MODULE_LINKER_FLAGS="-fuse-ld=lld"
