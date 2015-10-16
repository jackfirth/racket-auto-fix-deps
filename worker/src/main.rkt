#lang sweet-exp racket

require fancy-app
        "config.rkt"
        "subscribe-worker.rkt"
        "process-pkg-job.rkt"


(module+ main
  (sleep 3)
  (stomp-subscribe-worker queue-stomp-config
                          package-job-destination
                          process-pkg-job!))
