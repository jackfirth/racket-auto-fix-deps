#lang sweet-exp racket

require fancy-app
        predicates
        request
        "filter-hash.rkt"


(define read-from-string (compose read open-input-string))

(define write-requester (wrap-requester-body ~s _))
(define read-requester (wrap-requester-response read-from-string _))
(define read-write-requester (compose write-requester read-requester))
(define domain-requester/exn (make-domain-requester _ http-requester/exn))
(define package-requester (compose read-write-requester domain-requester/exn))


(define catalog-requester (package-requester "pkgs.racket-lang.org"))

(define (catalog-build-succeeded? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (not (hash-ref search-terms ':build-fail: #f)))

(define (has-undeclared-dependencies? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (hash-ref search-terms ':build-dep-fail: #f))

(define (string-contains? contain-str str)
  (regexp-match? (regexp contain-str) str))

(define github-pkg-source? (string-contains? "github.com" _))

(define (pkg-has-source-on-github? pkg-details)
  (github-pkg-source? (hash-ref pkg-details 'source)))


(define (all-pkg-details!) (get catalog-requester "pkgs-all"))
(define bad-pkg? (and? catalog-build-succeeded?
                       has-undeclared-dependencies?
                       pkg-has-source-on-github?))

(define (names-of-bad-pkgs all-pkg-details)
  (hash-keys
   (filter-hash-by-value all-pkg-details bad-pkg?)))

(define (systemf format-str . vs)
  (system (apply format format-str vs)))

(define (auto-fix-deps! pkg-name)
  (systemf "/src/fix-deps.sh ~a" pkg-name))

(module+ main
  (define bad-pkg-names (names-of-bad-pkgs (all-pkg-details!)))
  (set! bad-pkg-names '("lens"))
  (for ([pkg-name (in-list bad-pkg-names)])
    (auto-fix-deps! pkg-name)))
