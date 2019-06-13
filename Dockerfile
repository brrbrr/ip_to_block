FROM alpine
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apk --no-cache add git openssh-client python3 python3-dev openssl-dev build-base libffi-dev && \
        pip3 install --upgrade pip &&\
        pip3 install --no-cache-dir httpie-edgegrid &&\
        ln -s /root/data/.edgerc /root/.edgerc &&\
        git init

