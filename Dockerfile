FROM ubuntu:16.04

COPY . /niftycoin
WORKDIR /niftycoin

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils
RUN apt-get install -y libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev

#BerkleyDB for wallet support
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:bitcoin/bitcoin
RUN apt-get update
RUN apt-get install -y libdb4.8-dev libdb4.8++-dev

#upnp
RUN apt-get install -y libminiupnpc-dev

#ZMQ
RUN apt-get install -y libzmq3-dev

#build niftycoin source
RUN ./autogen.sh
RUN ./configure --disable-tests --disable-bench --without-gui
RUN make
RUN make install

#fix entrypoint and set permissions
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Port, RPC, Test Port, Test RPC
EXPOSE 3333 3332 13335 13332

ENTRYPOINT ["/entrypoint.sh"]
