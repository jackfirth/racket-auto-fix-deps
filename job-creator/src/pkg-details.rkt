#lang sweet-exp racket

require racket/contract

provide
  contract-out
    pkg-details? predicate/c


(define pkg-details? hash?)
