echo ${create_user} ${user} ${pwuser}
[ ${create_user} ] && \
		apk --update add --no-cache sudo && \
		echo "%sshuser ALL=(ALL) NOPASSWD:ALL"  | tee -a /etc/sudoers	&& \
		addgroup -g 1000 -S sshuser && \
		adduser -u 1000 -S ${user} -G sshuser -s /bin/bash  && \
		echo "${user}:${pwuser}" | chpasswd && \
		su ${user} -c "mkdir -p /home/${user}/.ssh/"
        # mkdir -p /home/${user}/.ssh/

export create_user=false

/usr/sbin/sshd -D