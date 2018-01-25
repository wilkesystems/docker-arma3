FROM wilkesystems/steamcmd:centos7

MAINTAINER wilkesystems <maintainer@wilke.systems>

ADD arma3.tar.xz /

RUN yum -y install epel-release; \
yum -y install bzip2 cronie exim p7zip rsyslog supervisor unzip wget xz; rm -rf /root/.steam; \
groupadd -g 1000 steam; useradd -d /home/steam -g 1000 -m -r -u 1000 steam; usermod -G tty steam; \
mkdir -p -m 770 /usr/games/arma3; chown steam:steam /usr/games/arma3; \
su -s /bin/bash -l steam -c 'steamcmd +quit'

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 2301-2305/udp 9000/tcp

WORKDIR /usr/games/arma3

USER steam

CMD ["arma3server", "-port=2302", "-bepath=/usr/games/arma3/battleye", "-cfg=/usr/games/arma3/basic.cfg", "-config=/usr/games/arma3/server.cfg", "-profiles=/usr/games/arma3/profiles", "-name=default", "-world=empty"]

ENTRYPOINT ["docker-entrypoint.sh"]
