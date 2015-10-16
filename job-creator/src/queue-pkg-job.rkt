#lang sweet-exp racket

provide
  contract-out
    queue-pkg-job! (-> stomp-session? string? string? void?)

require stomp


(define (queue-pkg-job! session pkg-job-destination name)
  (stomp-send session
              pkg-job-destination
              (string->bytes/utf-8 name)))
