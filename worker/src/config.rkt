#lang sweet-exp racket

provide
  contract-out
    queue-stomp-config stomp-config?
    package-job-destination string?
    package-fix-deps-destination string?

require stomp
        "stomp-config.rkt"


(define package-job-destination "/queue/package-install-jobs")
(define package-fix-deps-destination "/queue/package-fix-deps-jobs")

(define queue-stomp-config
  (stomp-config "queue"
                #f
                #f
                "/"
                61613
                '()
                '("1.1")))
