; A hello. Returns the string "hi"; prints nothing.
(defun hello () "hi")

; entry point: prints hello's return value.
(defun main ()
  (format t "~a~%" (hello)))
