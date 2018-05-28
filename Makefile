IMG="n0b0dyvn/alpine-ssh:0.1"
TEST_NAME="ssh-test"
include env
PWD = $(shell pwd)

build:
	docker build -t ${IMG} .

test:
	/bin/sh ${PWD}/run.sh
	#  -v /ssh-key/:/ssh-key

testall:
	make build
	make test
	ssh sangvh@localhost -p 2222 ls -al /