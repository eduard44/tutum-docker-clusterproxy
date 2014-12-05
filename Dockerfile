FROM ubuntu:trusty
MAINTAINER Bernardo Pericacho <bernardo@tutum.co> && Feng Honglin <hfeng@tutum.co>

#RUN apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common && add-apt-repository ppa:vbernat/haproxy-1.5
RUN echo 'deb http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu trusty main' >> /etc/apt/sources.list && \
    echo 'deb-src http://ppa.launchpad.net/vbernat/haproxy-1.5/ubuntu trusty main' >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 505D97A41C61B9CD && \
    apt-get update && \
    apt-get install -y --no-install-recommends haproxy python-pip
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Add configuration and scripts
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

ADD main.py /main.py
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD conf/haproxy.cfg.json /etc/haproxy/haproxy.cfg.json
ADD conf/haproxy.cfg.json /etc/haproxy/empty_haproxy.cfg.json

# Download AWS tools
RUN pip install awscli

# PORT to load balance and to expose (also update the EXPOSE directive below)
ENV PORT 80

# MODE of operation (http, tcp)
ENV MODE http

# algorithm for load balancing (roundrobin, source, leastconn, ...)
ENV BALANCE roundrobin

# maximum number of connections
ENV MAXCONN 4096

# list of options separated by commas
ENV OPTIONS redispatch

# list of timeout entries separated by commas
ENV TIMEOUTS connect 5000,client 50000,server 50000

# SSL certificate to use (optional)
ENV S3_SSL_CERT_FILE s3://my-bucket/mycert.pem

# Setup AWS environment variables
ENV AWS_ACCESS_KEY_ID mykey
ENV AWS_SECRET_ACCESS_KEY mysecret

EXPOSE 80
CMD ["/run.sh"]
