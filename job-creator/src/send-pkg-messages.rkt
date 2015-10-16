#lang sweet-exp racket

provide
  contract-out
    send-pkg-messages (-> (listof pkg-details?) void?)

require fancy-app
        stomp
        "pkg-details.rkt"
        "config.rkt"
        "stomp-config.rkt"
        "queue-pkg-job.rkt"


(define (send-pkg-messages pkg-details)
  (define session (stomp-connect/config queue-stomp-config))
  (define names (map (hash-ref _ 'name) pkg-details))
  (for-each (queue-pkg-job! session package-job-destination _) names)
  (stomp-disconnect session))
