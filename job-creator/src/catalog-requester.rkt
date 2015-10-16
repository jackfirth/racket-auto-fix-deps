#lang sweet-exp racket

require racket/contract

provide
  contract-out
    catalog-requester requester?

require request
        "config.rkt"
        "read-write-requester.rkt"


(define read-write-http-requester/exn
  (make-read-write-requester http-requester/exn))

(define (make-catalog-requester catalog-domain)
  (make-domain-requester catalog-domain
                         read-write-http-requester/exn))


(define catalog-requester
  (make-catalog-requester package-catalog-domain))
