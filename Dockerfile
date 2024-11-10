FROM ubuntu
RUN apt update -y && apt install ssh sudo -y
RUN adduser nti && echo "nti:1234" | chpasswd
RUN usermod -aG sudo nti
ENTRYPOINT service ssh start && bash
