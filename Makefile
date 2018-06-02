IMG=n0b0dyvn/alpine-ssh:0.1
sshserver_dir="img"
include env
PWD = $(shell pwd)

build:
	[ -d "${sshserver_dir}"] || git submodule update --init
	docker build -t ${IMG} ${sshserver_dir}/

test: build
	cd container
	-docker rm -f ${TEST_NAME}
	mkdir -p ssh-key 2>/dev/null
	rm -f ssh-key/*
	ssh-keygen -t rsa -N "" -f ssh-key/id_rsa 
	docker run -d --env-file env -p 2222:22 --name ${TEST_NAME} ${IMG}
	# sleep 2 second to wait sshd running
	sleep 2
	docker cp -a ${PWD}/ssh-key/id_rsa.pub ${TEST_NAME}:/home/${user}/.ssh/authorized_keys
	cd ${PWD}

testall: build test
	ssh sangvh@localhost -p 2222 ls -al /