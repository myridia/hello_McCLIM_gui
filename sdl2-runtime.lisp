(defun cl-user::reset-sdl2-user-event-id ()
  (setf sdl2::*user-event-id*
        (plus-c:c-let ((atomic sdl2-ffi:sdl-atomic-t))
          (setf (atomic :value) 0)
          atomic)))

(mcclim-sdl2::define-sdl2-request center-sdl2-window (mirror)
  (let ((window (mcclim-sdl2::sdl2-mirror-window mirror)))
    (sdl2-ffi.functions:sdl-set-window-position
     window
     sdl2-ffi:+sdl-windowpos-centered+
     sdl2-ffi:+sdl-windowpos-centered+)))

(defmethod clim:note-frame-enabled :before
    ((frame-manager clim:standard-frame-manager)
     (frame clim:standard-application-frame))
  (declare (ignore frame-manager))
  (let ((sheet (clim:frame-top-level-sheet frame)))
    (when sheet
      (let ((mirror (clim:sheet-direct-mirror sheet)))
        (when (typep mirror 'mcclim-sdl2::sdl2-mirror)
          (center-sdl2-window mirror :synchronize t))))))
