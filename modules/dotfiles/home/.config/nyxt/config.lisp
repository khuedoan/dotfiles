(define-configuration buffer
  ((default-modes
    (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration prompt-buffer
    ((default-modes (append '(vi-insert-mode) %slot-default%))))
