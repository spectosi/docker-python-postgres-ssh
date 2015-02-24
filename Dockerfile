FROM python:3.4.2-slim
MAINTAINER info@specto.si

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y git gcc postgresql-client libpq-dev openssh-server

# Create directories
RUN mkdir -p /usr/src/app
RUN mkdir -p /var/run/sshd

# Change dir for SSH session
RUN echo "cd /usr/src/app" >> /root/.bashrc

# Setup SSH
RUN echo "root:root" | chpasswd
RUN sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/" /etc/ssh/sshd_config
RUN sed "s@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g" -i /etc/pam.d/sshd
RUN echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1" >> /etc/ssh/sshd_config
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
