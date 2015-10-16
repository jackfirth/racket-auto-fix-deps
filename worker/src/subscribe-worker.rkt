#lang sweet-exp racket

provide
  contract-out
    stomp-subscribe-worker (-> stomp-config?
                               string?
                               (-> stomp-frame?
                                   void?)
                               void?)

require stomp
        "stomp-config.rkt"


(define (stomp-subscribe-worker a-stomp-config
                                destination
                                message-handler)
  (define subscription-id (symbol->string (gensym)))
  (define session (stomp-connect/config a-stomp-config))
  (stomp-subscribe session destination subscription-id)
  (stomp-subscribe-worker/session session
                                  destination
                                  subscription-id
                                  message-handler)
  (stomp-disconnect session))


(define (stomp-subscribe-worker/session session
                                        destination
                                        subscription-id
                                        message-handler)
  (define next-frame (stomp-next-message session subscription-id))
  (unless (eof-object? next-frame)
    (message-handler next-frame)
    (stomp-subscribe-worker/session session
                                    destination
                                    subscription-id
                                    message-handler)))
