#lang sweet-exp racket

provide
  contract-out
    process-pkg-job! (-> stomp-frame? void?)

require stomp
        "fix-pkg-deps.rkt"


(define process-pkg-job!
  (compose fix-pkg-deps!
           bytes->string/utf-8
           stomp-frame-body))
