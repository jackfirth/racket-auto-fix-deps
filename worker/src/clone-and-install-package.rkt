#lang sweet-exp racket

provide
  contract-out
    clone-and-install-package! (-> string? void?)

require pkg/lib


(define (clone-and-install-package! package-name)
  (define command (format "raco pkg install --deps search-auto --clone ~a" package-name))
  (unless (system command)
    (raise-install-error (format "Package ~a failed to install" package-name)))
  (flush-output))

(struct exn:fail:user:install exn:fail:user ())

(define (raise-install-error message)
  (raise (make-exn:fail:user message (current-continuation-marks))))

#|
(define (clone-and-install-package! package-name)
  (displayln (pkg-config-catalogs))
  (displayln (current-pkg-catalogs))
  (flush-output)
  (define desc (pkg-name->pkg-desc package-name))
  (parameterize ([current-pkg-error raise-user-error])
    (with-pkg-lock
     (pkg-install (list desc)
                  #:dep-behavior 'search-auto
                  #:quiet? #t)))
  (void))

(define (pkg-name->pkg-desc package-name)
  (pkg-desc package-name
            'clone
            #f
            #f
            #f
            #:path (package-path package-name)))

(define (package-path package-name)
  (build-path (current-directory) package-name))
|#