#lang sweet-exp racket

require "get-pkgs.rkt"
        "filter-pkgs.rkt"
        "send-pkg-messages.rkt"


(module+ main
  (sleep 3)
  (send-pkg-messages (filter-pkgs (get-pkgs))))
