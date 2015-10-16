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

(define (pkg-details-ring= ring pkg-details)
  (= ring (hash-ref pkg-details 'ring)))

(define pkg-ring1? (pkg-details-ring= 1 _))

(define (catalog-build-succeeded? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (not (hash-ref search-terms ':build-fail: #f)))

(define (has-undeclared-dependencies? pkg-details)
  (define search-terms (hash-ref pkg-details 'search-terms))
  (hash-ref search-terms ':build-dep-fail: #f))

(define (string-contains? contain-str str)
  (regexp-match? (regexp contain-str) str))

(define github-pkg-source? (string-contains? "github.com" _))

(define pkg-has-source-on-github? (compose github-pkg-source? (hash-ref _ 'source)))


(define (all-pkg-details!) (get catalog-requester "pkgs-all"))
(define bad-pkg? (and? pkg-ring1?
                       catalog-build-succeeded?
                       has-undeclared-dependencies?
                       pkg-has-source-on-github?))

(define filter-ring1-pkgs (filter-hash-by-value _ pkg-ring1?))
(define all-ring1-pkg-details! (compose filter-ring1-pkgs all-pkg-details!))

(define (names-of-bad-pkgs all-pkg-details)
  (hash-keys
   (filter-hash-by-value all-pkg-details bad-pkg?)))

(define (systemf format-str . vs)
  (system (apply format format-str vs)))

(define (auto-fix-deps! pkg-name)
  (systemf "/src/fix-deps.sh ~a" pkg-name))


(define (append-map-dedupe f vs)
  (remove-duplicates (append-map f vs)))

(define (pkg-authors all-pkg-details)
  (append-map-dedupe (hash-ref _ 'authors) (hash-values all-pkg-details)))

(define (is-author-of-pkg? author pkg-details)
  (set-member? (hash-ref pkg-details 'authors) author))

(define (author-num-packages author all-pkg-details)
  (length (filter (is-author-of-pkg? author _ ) (hash-values all-pkg-details))))

(define (all-author-num-packages all-pkg-details)
  (for/hash ([author (in-list (pkg-authors all-pkg-details))])
    (values author (author-num-packages author all-pkg-details))))



(sort (hash->list (all-author-num-packages (all-ring1-pkg-details!)))
      <
      #:key cdr)
