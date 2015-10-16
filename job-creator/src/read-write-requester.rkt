#lang sweet-exp racket

require racket/contract

provide
  contract-out
    make-read-write-requester (-> requester? requester?)

require fancy-app
        request


(define read-from-string (compose read open-input-string))

(define make-read-write-requester
  (compose (wrap-requester-body ~s _)
           (wrap-requester-response read-from-string _)))
