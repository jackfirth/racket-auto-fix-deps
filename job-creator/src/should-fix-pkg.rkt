#lang sweet-exp racket

provide
  contract-out
    should-fix-pkg? predicate/c


require fancy-app
        predicates


(define (pkg-details-ring= ring pkg-details)
  (= ring (hash-ref pkg-details 'ring)))

(define ring1-pkg? (pkg-details-ring= 1 _))

(define (build-succeeded? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (not (hash-ref search-terms ':build-fail: #f)))

(define (has-undeclared-dependencies? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (hash-ref search-terms ':build-dep-fail: #f))

(define (string-contains? contain-str str)
  (regexp-match? (regexp contain-str) str))

(define github-pkg-source? (string-contains? "github.com" _))

(define pkg-on-github? (compose github-pkg-source? (hash-ref _ 'source)))


(define should-fix-pkg?
  (and? ring1-pkg?
        build-succeeded?
        pkg-on-github?
        has-undeclared-dependencies?))
