(defpackage :learn.core
  (:use :cl)
  (:export #:buffer #:make-buffer
           #:line #:make-line #:line-chars
           #:insert-char #:delete-char #:move #:text))

(in-package :cl-user)

;;; A buffer is a list of lines; each line is a list of characters; the cursor is
;;; (line-index, offset) into the line. Everything below is list surgery.

(defstruct (line (:constructor make-line (chars)))
  chars)

(defstruct (buffer (:constructor make-buffer (cursor line-index offset lines)))
  (cursor nil)
  (line-index 0)
  (offset 0)
  lines)

(defun line-text (line)
  (coerce (line-chars line) 'string))

(defun text (b)
  "Return the buffer as a list of strings, one per line."
  (mapcar #'line-text (buffer-lines b)))

(defun insert-char (b ch)
  "Insert character CH at the cursor, then step the cursor right."
  (let* ((lines (buffer-lines b))
         (i (buffer-line-index b))
         (off (buffer-offset b))
         (chars (line-chars (elt lines i))))
    (setf (elt lines i)
          (make-line (append (subseq chars 0 off) (list ch) (subseq chars off))))
    (setf (buffer-offset b) (1+ off))
    b))

(defun delete-char (b)
  "Delete the character AT the cursor."
  (let* ((lines (buffer-lines b))
         (i (buffer-line-index b))
         (off (buffer-offset b))
         (chars (line-chars (elt lines i))))
    (when (< off (length chars))
      (setf (elt lines i)
            (make-line (append (subseq chars 0 off) (subseq chars (1+ off))))))
    b))

(defun move (b dx)
  "Move the cursor DX characters, clamped to the line."
  (let* ((line (elt (buffer-lines b) (buffer-line-index b)))
         (off (buffer-offset b))
         (n (length (line-chars line))))
    (setf (buffer-offset b) (max 0 (min n (+ off dx)))))
  b)
