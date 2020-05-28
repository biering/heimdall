SHELL=/bin/bash
NAME=pool-test

build:
	#docker rm pool-test
	#docker ps -q --filter "name=${NAME}" | grep -q . && docker stop ${NAME} && docker rm -fv ${NAME}
	docker build -t cardano-stakepool .

# docker images -a

