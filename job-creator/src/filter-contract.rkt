#lang sweet-exp racket

provide
  contract-out
    filter/c (-> contract? contract?)


(define (filter/c item-contract)
  (-> (listof item-contract) (listof item-contract)))
