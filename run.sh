	-docker rm -f ${TEST_NAME}
	mkdir -p ssh-key 2>/dev/null
	rm -f ssh-key/*
	ssh-keygen -t rsa -N "" -f ssh-key/id_rsa 
	docker run -d --env-file ${PWD}/env --rm -p 2222:22 --name ${TEST_NAME} ${IMG}
	docker cp ${PWD}/ssh-key/id_rsa.pub ${TEST_NAME}:/home/${user}/.ssh/authorized_keys