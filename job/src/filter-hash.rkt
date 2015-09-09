#lang sweet-exp racket

provide
  contract-out
    filter-hash-by-key (-> hash? predicate/c hash?)
    filter-hash-by-value (-> hash? predicate/c hash?)
    filter-hash (-> hash? (-> any/c any/c boolean?) hash?)

module+ test
  require rackunit


(define (filter-hash-by-key a-hash key-predicate)
  (for/hash ([(k v) (in-hash a-hash)]
             #:when (key-predicate k))
    (values k v)))

module+ test
  (check-equal? (filter-hash-by-key (hash 1 'a 'foo 'b 2 'c 'bar 'd) number?)
                (hash 1 'a 2 'c))


(define (filter-hash-by-value a-hash value-predicate)
  (for/hash ([(k v) (in-hash a-hash)]
             #:when (value-predicate v))
    (values k v)))

module+ test
  (check-equal? (filter-hash-by-value (hash 'a 1 'b 'foo 'c 2 'd 'bar) number?)
                (hash 'a 1 'c 2))


(define (filter-hash a-hash relation)
  (for/hash ([(k v) (in-hash a-hash)]
             #:when (relation k v))
    (values k v)))

module+ test
  (check-equal? (filter-hash (hash 'a 'a 'b 1 'c 'c 'd 2) equal?)
                (hash 'a 'a 'c 'c))
