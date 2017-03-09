FROM ubuntu:16.04

MAINTAINER Yannik Behr <y.behr@gns.cri.nz>

# Can fail on occasion.
RUN apt-get update && apt-get upgrade || true
RUN apt-get -y install \
    wget \
    csh \
 	&& apt-get clean


# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
chmod +x /usr/local/bin/tini


# Configure container startup
ENTRYPOINT ["tini", "--"]

RUN groupadd -g 1260 -r volcano && useradd -m -s /bin/bash -r -g volcano -u 1260 volcano

COPY qlog /usr/local/bin
RUN chmod a+x /usr/local/bin/qlog

USER volcano
WORKDIR /home/volcano

VOLUME ["/home/volcano/output"]
VOLUME ["/home/volcano/sds"]
VOLUME ["/home/volcano/workdir"]
COPY edslog_1.csh /home/volcano/
COPY edslog_2.csh /home/volcano/
COPY tedslog_2.csh /home/volcano/
