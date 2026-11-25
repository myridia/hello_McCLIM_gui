(defvar cl-user::*auto-start* t)
(defvar cl-user::*bundled-font-bytes* nil)


(let ((setup (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (if (probe-file setup)
      (load setup)
      (error "Quicklisp not found. Run task 1 in ask.sh.")))

(when (fboundp 'ql:register-local-projects)
  (ql:register-local-projects))

(defvar cl-user::*backend*
  (let ((requested (sb-ext:posix-getenv "MCCLIM_BACKEND")))
    (cond ((and requested (plusp (length requested))
                (string-equal requested "sdl2")) :sdl2)
          ((and requested (plusp (length requested))
                (string-equal requested "clx")) :clx)
          ((and requested (plusp (length requested)))
           (error "Unknown MCCLIM_BACKEND ~s (use sdl2 or clx)" requested))
          ((or (member :win32 *features*)
               (member :mingw32 *features*)
               (member :cygwin *features*)) :sdl2)
          (t :clx))))

(ql:quickload :mcclim)

(when (eq cl-user::*backend* :sdl2)
  (ql:quickload :mcclim-sdl2)
  (load (merge-pathnames "sdl2-runtime.lisp"
                         (or *load-truename* *default-pathname-defaults*)))
  (setf clim:*default-server-path* '(:sdl2-soft)))

(in-package :clim-user)

(defun use-bundled-font ()
  (when cl-user::*bundled-font-bytes*
    (let* ((dir (merge-pathnames ".cache/mcclim/" (user-homedir-pathname)))
           (font (merge-pathnames "DejaVuSans.ttf" dir)))
      (ensure-directories-exist dir)
      (with-open-file (s font :direction :output
                         :element-type '(unsigned-byte 8)
                         :if-exists :supersede
                         :if-does-not-exist :create)
        (write-sequence cl-user::*bundled-font-bytes* s))
      (setf mcclim-truetype::*truetype-font-path* dir
            mcclim-truetype::*families/faces*
            (loop for entry in mcclim-truetype::*families/faces*
                  collect (cons (car entry) font))))))

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

(defun command-line-args ()
  (rest sb-ext:*posix-argv*))

(defun no-window-p ()
  (some (lambda (arg)
          (or (string= arg "-nw")
              (string= arg "--nw")
              (string= arg "--no-window")))
        (command-line-args)))

(defun free-console ()
  #+win32
  (cffi:foreign-funcall "FreeConsole" :boolean)
  #-win32
  t)

(defun attach-parent-console ()
  #+win32
  (cffi:foreign-funcall "AttachConsole" :int -1 :boolean)
  #-win32
  t)

(defun write-console-line (text)
  (let ((message (format nil "~a~%" text)))
    #+win32
    (cffi:with-foreign-object (written :unsigned-int)
      (cffi:foreign-funcall
       "WriteFile"
       :pointer (cffi:foreign-funcall "GetStdHandle" :int -11 :pointer)
       :string message
       :unsigned-int (length message)
       :pointer written
       :pointer (cffi:null-pointer)
       :boolean))
    #-win32
    (format t "~a" message)))

(defun command-line-main ()
  (attach-parent-console)
  (write-console-line "Hello, world!"))

(defun main ()
  (when (eq cl-user::*backend* :sdl2)
    (funcall (symbol-function (intern "RESET-SDL2-USER-EVENT-ID" "CL-USER"))))
  (if (no-window-p)
      (command-line-main)
      (progn
        #+win32
        (free-console)
        (use-bundled-font)
        (run-frame-top-level (make-application-frame 'hello-frame)))))

(export 'main)

(when cl-user::*auto-start*
  (main))
