FROM instrumentisto/coturn

COPY turnserver.conf /etc/coturn/turnserver.conf

EXPOSE 3478 3478/udp 5349 5349/udp

CMD ["turnserver", "-c", "/etc/coturn/turnserver.conf"]
