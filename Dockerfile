FROM ubuntu:20.04

WORKDIR /src

ENV LANG=en_US.utf8
ENV PYTHONIOENCODING=UTF-8
ENV TZ=Asia/Seoul

COPY ./docker-entrypoint.sh /

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    apt-get update && \
    apt-get install -y vim net-tools

#Dev
RUN apt-get install sudo gdb gdbserver gdb-multiarch git make gcc g++ wget cmake pkg-config binutils python3 python3-dev python3-pip gcc-arm-linux-gnueabihf libc6-dev-armhf-cross qemu-user-static -y

#PWNTools - Python
RUN python3 -m pip install -U pip && \
    python3 -m pip install --no-cache-dir \
    ropgadget \
    pwntools \
    z3-solver \
    smmap2 \
    apscheduler \
    ropper \
    unicorn \
    keystone-engine \
    capstone \
    angr \
    pebble \
    r2pipe

RUN python3 -m pip install --no-cache-dir \
    pycrypto

#Analysis
RUN apt-get install netcat binwalk nmap ltrace strace -y

RUN git clone --depth 1 https://github.com/pwndbg/pwndbg && \
    cd pwndbg && chmod +x setup.sh && ./setup.sh

EXPOSE 22
EXPOSE 80
EXPOSE 8080
EXPOSE 4444

RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
