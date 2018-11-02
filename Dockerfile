FROM centos:latest
MAINTAINER Toon Leijtens <toon.leijtens@ing.com>
RUN yum -y groupinstall "Development Tools"
RUN yum -y install bc
RUN yum -y install golang
RUN git clone https://github.com/ethereum/go-ethereum

ARG ETHVERSION=v1.8.17
RUN cd /go-ethereum && git checkout $ETHVERSION && make geth && cp /go-ethereum/build/bin/* /usr/local/sbin/
RUN yum -y remove golang
RUN rm -rf /go-ethereum

ENV DATADIR=/root/.ethereum
WORKDIR $DATADIR

COPY artifacts/key.* /root/.ethereum/
COPY artifacts/admin.id /root/.ethereum/
COPY artifacts/rinkeby.json /root/.ethereum/
COPY artifacts/keystore/* /root/.ethereum/keystore/

COPY artifacts/entrypoint.sh /entrypoint.sh
RUN sed -i "s/adminetherbase/0x$(cat /root/.ethereum/admin.id)/" /entrypoint.sh

RUN /usr/local/sbin/geth --rinkeby --datadir /root/.ethereum init /root/.ethereum/rinkeby.json

ARG RPCPORT=8545
ENV RPCPORT $RPCPORT

EXPOSE $RPCPORT
ENTRYPOINT ["/entrypoint.sh"]
