FROM ubuntu:focal

# Install packages based on architecture
RUN apt-get -y update && \
    apt-get -y install wget libcurl4 && \
    if [ "$(uname -m)" = "x86_64" ]; then \
        apt-get -y install lib32gcc1; \
    else \
        apt-get -y install libgcc-s1; \
    fi && \
    apt-get -y install ruby && \
    apt-get clean && \
    find /var/lib/apt/lists -type f | xargs rm -vf

RUN useradd -m steam

WORKDIR /home/steam
USER steam

# Add necessary files
ADD kf2_functions.sh kf2_functions.sh 
ADD main main
ADD configurator configurator

# Steam port
EXPOSE 20560/udp

# Query port
EXPOSE 27015/udp

# Game port
EXPOSE 7777/udp

# Web Admin port
EXPOSE 8080/tcp

# Set entrypoint
ENTRYPOINT ["/bin/bash", "main"]