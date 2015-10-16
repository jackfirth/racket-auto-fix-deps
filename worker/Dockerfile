FROM jackfirth/racket:6.2-onbuild

RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list.d/sources.list

RUN apt-get -t jessie-backports update \
 && apt-get -t jessie-backports install -y docker.io
