FROM ubuntu:22.04

# Minimal packages: wget, tar, ca-certificates, libstdc++ (jika binary butuh)
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates tar libstdc++6 && \
    rm -rf /var/lib/apt/lists/*

# Non-root user
RUN useradd -m -s /bin/bash runner
WORKDIR /home/runner
COPY start.sh /home/runner/start.sh
RUN chown runner:runner /home/runner/start.sh && chmod +x /home/runner/start.sh

USER runner
ENV WORKDIR=/home/runner
ENTRYPOINT ["/home/runner/start.sh"]
