#!/bin/sh

OPTIONS="--rpc --rpcport $RPCPORT --rpcaddr 0.0.0.0 --datadir /root/.ethereum --etherbase adminetherbase --verbosity 6"

/usr/local/sbin/geth  --rinkeby --cache=1024 --rpccorsdomain="*" --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --identity $1 $OPTIONS
#/usr/local/sbin/geth --bootnodes=enode://a24ac7c5484ef4ed0c5eb2d36620ba4e4aa13b8c84684e1b4aab0cebea2ae45cb4d375b77eab56516d34bfbd3c1a833fc51296ff084b770b94fb9028c4d25ccf@52.169.42.101:30303 --rpccorsdomain="*" --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --identity $1 $OPTIONS
