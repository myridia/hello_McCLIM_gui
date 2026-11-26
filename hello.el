(defun hello ()
  (message "level 1"
	   (message "level 2"
		    (message "level 3"
			     (message "level 4 A" 
                		      (message "level 5 A")
				      (message "level 5 B")
				      (message "level 5 C") 				      

				      )

			     (message "level 4 B")
			     (message "level 4 C")			     
			     )
		    ))
  )




(hello)

