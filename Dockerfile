FROM ethereum/client-go:v1.8.17
MAINTAINER Maxim B. Belooussov <belooussov@gmail.com>
ARG ADMINETHERBASE=0000000000x0
VOLUME /root/.ethereum
VOLUME /root/rinkeby.json
CMD ["--rinkeby","--cache=1024","--rpccorsdomain='*'","--rpcapi","admin,db,eth,debug,miner,net,shh,txpool,personal,web3","--rpc","--rpcport","8545","--rpcaddr","0.0.0.0","--datadir","/root/.ethereum","--etherbase","$ADMINETHERBASE","--verbosity","6","--identity","rinkeby"]
