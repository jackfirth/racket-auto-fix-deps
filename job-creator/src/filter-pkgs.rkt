#lang sweet-exp racket

provide
  contract-out
    filter-pkgs (filter/c pkg-details?)

require fancy-app
        "pkg-details.rkt"
        "filter-contract.rkt"
        "should-fix-pkg.rkt"


(define filter-pkgs (filter should-fix-pkg? _))
