(defun cl-user::reset-sdl2-user-event-id ()
  (setf sdl2::*user-event-id*
        (plus-c:c-let ((atomic sdl2-ffi:sdl-atomic-t))
          (setf (atomic :value) 0)
          atomic)))
