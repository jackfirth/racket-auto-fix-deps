#lang sweet-exp racket

provide
  contract-out
    struct stomp-config ([hostname string?]
                         [login (or/c string? #f)]
                         [passcode (or/c string? #f)]
                         [virtual-host string?]
                         [port-number (and/c exact-nonnegative-integer?
                                             (integer-in 0 65535))]
                         [headers (listof (list/c symbol? string?))]
                         [request-versions (listof string?)])
    stomp-connect/config (-> stomp-config? stomp-session?)

require stomp


(struct stomp-config
  (hostname login passcode virtual-host port-number headers request-versions)
  #:prefab)

(define (stomp-connect/config a-stomp-config)
  (match-define (stomp-config hostname
                              login
                              passcode
                              virtual-host
                              port-number
                              headers
                              request-versions) a-stomp-config)
  (stomp-connect hostname
                 #:login login
                 #:passcode passcode
                 #:virtual-host virtual-host
                 #:port-number port-number
                 #:headers headers
                 #:request-versions request-versions))
