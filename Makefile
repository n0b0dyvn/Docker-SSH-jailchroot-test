IMG=n0b0dyvn/alpine-ssh:0.1
sshserver_dir="img"
include env
PWD = $(shell pwd)
export $(shell sed 's/=.*//' env)


build:
	[ -d ${sshserver_dir} ] || git submodule update --init
	docker build -t ${IMG} ${sshserver_dir}/

test: build
	-docker rm -f ${TEST_NAME}
	mkdir -p ssh-key 2>/dev/null
	rm -f ssh-key/id_rsa*
	ssh-keygen -t rsa -N "" -f ssh-key/id_rsa 
	docker run -d --env-file env -p 2222:22 --name ${TEST_NAME} ${IMG}
	# sleep 2 second to wait sshd running
	sleep 5
	docker cp -a ${PWD}/ssh-key/id_rsa.pub ${TEST_NAME}:/home/${user}/.ssh/authorized_keys
	docker exec -i ${TEST_NAME} bash -c "chown ${user} /home/${user}/.ssh/authorized_keys && chmod 600 /home/${user}/.ssh/authorized_keys"
	ssh -F ssh-key/ssh-config -i ssh-key/id_rsa ${user}@localhost -p ${port} ls -al /
