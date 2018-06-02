-docker rm -f ${TEST_NAME}
-mkdir -p ssh-key 2>/dev/null
-rm -f ssh-key/*
-ssh-keygen -t rsa -N "" -f ssh-key/id_rsa 
docker run -d --env-file ${PWD}/env -p 2222:22 --name ${TEST_NAME} ${IMG}
# I dont know the reason why docker cp cant copy to /home/{user}/.ssh directly
docker cp -a ${PWD}/ssh-key/id_rsa.pub ${TEST_NAME}:/home/${user}/.ssh/authorized_keys
# docker exec -it ${TEST_NAME} mv /tmp/authorized_keys /home/${user}/.ssh/
# tar -c ssh-key/id_rsa.pub | docker exec -i ${TEST_NAME}  /bin/tar -C /home/${user}/.ssh/ -x 