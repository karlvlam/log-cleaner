FROM alpine:3.4 

RUN ulimit -n 65536

RUN mkdir -p /opt/script clean.sh

COPY clean.sh /opt/script/clean.sh

RUN chmod a+x /opt/script/clean.sh 
RUN mkdir /var/log/containers 

ENTRYPOINT ["/opt/script/clean.sh"]

