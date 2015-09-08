FROM jackfirth/racket:6.2.1
WORKDIR /src
ADD src/info.rkt
RUN raco pkg install --link --deps search-auto
ADD src .
RUN raco exe main.rkt
