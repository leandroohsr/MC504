FROM debian:12-slim

WORKDIR /usr/src/app
# COPY . .

RUN apt update && apt install -y git \
    build-essential \
    gdb-multiarch \
    qemu-system-misc \
    gcc-riscv64-linux-gnu \
    binutils-riscv64-linux-gnu \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# RUN make

CMD [ "make", "qemu"]