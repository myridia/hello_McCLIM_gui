(defun hello ()
  (message "level 1" (message "level 2" (message "level 3" (message "level 4"(message "level 5") ) )
     ))
)

(hello)
