(defvar cl-user::*auto-start* t)

(let ((setup (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (if (probe-file setup)
      (load setup)
      (error "Quicklisp not found. Run task 1 in ask.sh.")))

(ql:quickload :mcclim)

(in-package :clim-user)

(define-application-frame hello-frame ()
  ()
  (:panes
   (message :application
            :display-function 'display-message
            :width 340
            :height 100)
   (quit-button :push-button
                :label "Quit"
                :activate-callback (lambda (&rest args)
                            (declare (ignore args))
                            (frame-exit *application-frame*))))
  (:layouts
   (default (vertically () message quit-button))))

(defun display-message (frame stream)
  (declare (ignore frame))
  (format stream "Hello, world!"))

(defun main ()
  (run-frame-top-level (make-application-frame 'hello-frame)))

(export 'main)

(when cl-user::*auto-start*
  (main))
