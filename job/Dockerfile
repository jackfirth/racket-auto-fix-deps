FROM jackfirth/racket:6.2.1

WORKDIR /src

RUN apt-get update && apt-get install -y git curl

RUN curl -L https://github.com/github/hub/releases/download/v2.2.1/hub-linux-amd64-2.2.1.tar.gz \
  | tar xz && mv hub-linux-amd64-2.2.1/hub hub && \
    chmod +x hub && \
    rm -rf hub-linux-amd64-2.2.1

ADD src/info.rkt ./info.rkt
RUN raco pkg install --link --deps search-auto
ADD src .
RUN chmod +x ./fix-deps.sh
RUN raco exe main.rkt
WORKDIR /tmp
CMD ["/src/main"]
