FROM hardv26/linkedin-mcp-server:safe-4.17.0

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends x11vnc novnc websockify x11-utils \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/login-vnc.sh /usr/local/bin/linkedin-login-vnc
RUN chmod 0755 /usr/local/bin/linkedin-login-vnc

USER pwuser
ENV DISPLAY=:99
EXPOSE 6080
ENTRYPOINT ["/usr/local/bin/linkedin-login-vnc"]
