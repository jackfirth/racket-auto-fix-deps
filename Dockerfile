FROM jackfirth/racket:6.2.1
RUN apt-get install software-properties-common
RUN add-apt-repository ppa:cpick/hub
RUN apt-get update && apt-get install git hub
WORKDIR /src
ADD src/info.rkt ./info.rkt
RUN raco pkg install --link --deps search-auto
ADD src .
RUN chmod +x ./fix-deps.sh
RUN raco exe main.rkt
CMD ["./main"]
