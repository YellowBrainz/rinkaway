#!/bin/sh

OPTIONS="--rpc --rpcport $RPCPORT --rpcaddr 0.0.0.0 --datadir /root/.ethereum --etherbase adminetherbase --verbosity 6"

/usr/local/sbin/geth  --rinkeby --cache=1024 --rpccorsdomain="*" --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --identity $1 $OPTIONS