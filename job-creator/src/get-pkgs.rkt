#lang sweet-exp racket

provide
  contract-out
    get-pkgs (-> (listof pkg-details?))

require request
        "catalog-requester.rkt"
        "pkg-details.rkt"


(define (get-pkgs)
  (hash-values (get catalog-requester "pkgs-all")))
