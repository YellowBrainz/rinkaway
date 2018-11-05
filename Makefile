AUTHOR=yellowdocker
NAME=rinkaway
NETWORKPORT=30303
VERSION=5lines
RPCPORT=8545
FULLDOCKERNAME=$(AUTHOR)/$(NAME):$(VERSION)

build:
	docker build -t $(FULLDOCKERNAME) .

start: rinkeby

stop:
	docker stop -t 0 rinkeby

clean:
	docker rm -f rinkeby

cleanrestart: clean start

datavolume:
	docker run -d -v ethereumeth:/root/.ethereum --name data-rinkeby --entrypoint /bin/echo $(AUTHOR)/$(NAME):$(VERSION)

rinkeby:
	docker run -d --name=rinkeby -h rinkeby --volumes-from data-rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) $(AUTHOR)/$(NAME):$(VERSION) rinkeby

console:
	docker exec -ti eth /usr/local/sbin/geth attach ipc:/root/.ethereum/geth.ipc

properdatavolume:
	docker volume create maxrinkeby

init: properdatavolume
	docker run -d --mount type=volume,source=maxrinkeby,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json $(AUTHOR)/$(NAME):$(VERSION) --rinkeby --datadir /root/.ethereum init /root/rinkeby.json

rinkeby:
	#docker run -d --name=rinkeby -h rinkeby --volumes-from data-rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) $(AUTHOR)/$(NAME):$(VERSION)
	docker run -d --mount type=volume,source=maxrinkeby,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json --name=rinkeby -h rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) $(AUTHOR)/$(NAME):$(VERSION)
