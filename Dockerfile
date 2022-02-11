FROM ubuntu:jammy-20220130

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y \
	git \
	make \
	sudo \
	wget

WORKDIR /tmp

RUN wget https://static.dev.sifive.com/dev-tools/freedom-tools/v2020.12/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14.tar.gz
RUN tar -xzf riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14.tar.gz -C /opt

ENV PATH=/opt/riscv64-unknown-elf-toolchain-10.2.0-2020.12.8-x86_64-linux-ubuntu14/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Create our user/group
RUN echo user ALL=NOPASSWD: ALL > /etc/sudoers.d/user
RUN useradd -m -U user
USER user:user

WORKDIR /home/user
RUN mkdir /home/user/artifacts

WORKDIR /home/user
RUN git clone https://github.com/starfive-tech/bootloader_recovery
WORKDIR /home/user/bootloader_recovery
RUN git checkout 2b268a1cedf6c7136814967da9d591e39b673068
RUN make
RUN cp debug/jh7100_recovery_boot.bin /home/user/artifacts

WORKDIR /home/user
RUN git clone https://github.com/starfive-tech/JH7100_secondBoot
WORKDIR /home/user/JH7100_secondBoot/build
RUN git checkout f93f109c75ee75fe404a710a92eb9bac31eb7ec9
RUN make clean
RUN make
RUN cp bootloader-JH7100-*.bin.out /home/user/artifacts/bootloader-JH7100.bin.out
