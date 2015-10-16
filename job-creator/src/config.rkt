#lang sweet-exp racket

provide
  contract-out
    package-catalog-domain string?
    queue-stomp-config stomp-config?
    package-job-destination string?

require stomp
        "stomp-config.rkt"


(define package-catalog-domain "pkgs.racket-lang.org")
(define package-job-destination "/queue/package-install-jobs")

(define queue-stomp-config
  (stomp-config "queue"
                #f
                #f
                "/"
                61613
                '()
                '("1.1")))
