#lang sweet-exp racket

provide
  contract-out
    fix-pkg-deps! (-> string? void?)

require fancy-app


(define (printf/flush format-str . vs)
  (apply printf format-str vs)
  (flush-output))

(define notify-job-received (printf/flush "Received job for package ~a\n" _))
(define notify-job-finished (printf/flush "Job for package ~a finished successfully\n" _))
(define notify-job-failed (printf/flush "Job for package ~a failed\n" _))


(define (fix-pkg-deps! pkg-name)
  (notify-job-received pkg-name)
  (if (system (format "docker run racketautofixdeps_pkg-fixer raco pkg install ~a" pkg-name))
      (notify-job-finished pkg-name)
      (notify-job-failed pkg-name)))
