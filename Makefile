AUTHOR=yellowdocker
NAME=rinkaway
NETWORKPORT=30303
VERSION=5lines
RPCPORT=8545
FULLDOCKERNAME=$(AUTHOR)/$(NAME):$(VERSION)
KEYS=`pwd`/.ethereum/keystore
MAXKEY=`cat .ethereum/admin.id`

build:
	docker build -t $(FULLDOCKERNAME) .

start: rinkeby

stop:
	docker stop -t 0 rinkeby

clean:
	docker rm -f rinkeby

deepclean:
	docker rm -f init
	docker rm -f init2
	docker rm -f rinkeby

cleanrestart: clean start

console:
	docker exec -ti rinkeby geth attach

rmkeys:
	@if [ ! -d ./.ethereum/keystore ]; then mkdir -p ./.ethereum/keystore; else rm -f ./.ethereum/keystore/UTC*; fi

adminid:
	@ls -la `pwd`/.ethereum/keystore|grep UTC--|awk '{split($$0,a,"--"); print a[6]}'|sed 's/^/0x/' > `pwd`/.ethereum/admin.id
	@if [ -e ./.ethereum/pw ]; then PASSWD= $(cat ./.ethereum/pw); else echo "$(PASSWD)" > ./.ethereum/pw; fi

init:
	@if [ ! -d ./.ethereum ]; then mkdir -p ./.ethereum; fi
	@if [ ! -d ./.ethereum/keystore ]; then mkdir -p ./.ethereum/keystore; fi
	@if [ -e ./.ethereum/pw ]; then PASSWD= $(cat ./.ethereum/pw); else echo "$(PASSWD)" > ./.ethereum/pw; fi
	echo "[x] Initializing a Rinkeby client"
	docker run -d --name init --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json $(AUTHOR)/$(NAME):$(VERSION) --rinkeby --datadir /root/.ethereum init /root/rinkeby.json
	docker logs init
	echo "[x] Creating an account now"
	docker run -d --name init2 --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json $(AUTHOR)/$(NAME):$(VERSION) --password /root/.ethereum/pw account new 2>&1
	@ls -la `pwd`/.ethereum/keystore|grep UTC--|awk '{split($$0,a,"--"); print a[6]}'|sed 's/^/0x/' > `pwd`/.ethereum/admin.id
	docker logs init2
	
rinkeby:
	echo `cat .ethereum/admin.id`
	docker run -d --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json --name rinkeby -h rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) $(AUTHOR)/$(NAME):$(VERSION) --rinkeby --cache=1024 --rpccorsdomain='*' --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3 --rpc --rpcport 8545 --rpcaddr 0.0.0.0 --datadir /root/.ethereum --etherbase $(MAXKEY) --verbosity 6 --identity rinkeby
