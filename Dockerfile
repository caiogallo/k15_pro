FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    build-essential \
    gcc-avr \
    binutils-avr \
    avr-libc \
    dfu-programmer \
    dfu-util \
    sudo \
	gcc-arm-none-eabi \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install qmk --break-system-packages

RUN python3 -m pip config set global.break-system-packages true

RUN useradd -ms /bin/bash builder && \
    echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER builder
WORKDIR /home/builder

WORKDIR /home/builder/qmk_firmware

CMD ["/bin/bash"]
