AUTHOR=yellowdocker
NAME=rinkaway
NETWORKPORT=30303
VERSION=5lines
RPCPORT=8545
FULLDOCKERNAME=$(AUTHOR)/$(NAME):$(VERSION)
KEYS=`pwd`/.ethereum/keystore
MAXKEY=0x`cat .ethereum/admin.id`

build:
	docker build -t $(FULLDOCKERNAME) .

start: rinkeby

stop:
	docker stop -t 0 rinkeby

clean:
	docker rm -f init
	docker rm -f init2
	docker rm -f rinkeby

cleanrestart: clean start

datavolume:
	docker run -d -v ethereumeth:/root/.ethereum --name data-rinkeby --entrypoint /bin/echo $(AUTHOR)/$(NAME):$(VERSION)

rinkeby:
	docker run -d --name=rinkeby -h rinkeby --volumes-from data-rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) $(AUTHOR)/$(NAME):$(VERSION) rinkeby

console:
	docker exec -ti eth /usr/local/sbin/geth attach ipc:/root/.ethereum/geth.ipc

init:
	mkdir -p .ethereum
	docker run -d --name init --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json $(AUTHOR)/$(NAME):$(VERSION) --rinkeby --datadir /root/.ethereum init /root/rinkeby.json
	docker logs init
	echo "foobarsecret" > .ethereum/pw
	echo "Creating an account now"
	docker run -d --name init2 --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json $(AUTHOR)/$(NAME):$(VERSION) --password /root/.ethereum/pw account new 2>&1 |sed 's/^/0x/' >`pwd`/.ethereum/admin.id
	docker logs init2
	
max:
	docker run -d --mount type=bind,source=`pwd`/.ethereum,target=/root/.ethereum --mount type=bind,source=`pwd`/rinkeby.json,target=/root/rinkeby.json --name rinkeby -h rinkeby -p $(NETWORKPORT):$(NETWORKPORT) -p $(RPCPORT):$(RPCPORT) -e ADMINETHERBASE=`cat .ethereum/admin.id` $(AUTHOR)/$(NAME):$(VERSION)

reset:
	docker rm `docker ps -aq`
