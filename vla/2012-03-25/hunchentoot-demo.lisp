(defpackage :hunchentoot-demo
  (:use :cl :alexandria))

(in-package :hunchentoot-demo)

(defclass acceptor (hunchentoot:acceptor) ())

(defvar *acceptor* (make-instance 'acceptor))

(defun choose-route (request)
  (let ((route (assoc (hunchentoot:request-uri request)
		      *routes*
		      :test #'string=)))
    (if route
	(funcall (symbol-function (cdr route)) request)
	(funcall #'four-oh-four request))))

(defmethod hunchentoot:handle-request ((acceptor acceptor) request)
  (choose-route request))




;; blog stuff
;; ----------

(defclass blog-post ()
  ((:title :initform (error "Blog post is missing a title.")
	   :initarg :title
	   :accessor title)
   (:date :initform (get-universal-time)
	  :initarg :date
	  :accessor date)
   (:content :initform (error "Blog post is missing post content.")
	     :initarg :content
	     :accessor content)))

#|(defvar *blog-posts*
  (list
   (make-instance 'blog-post
		  :title "Hello, world!"
		  :content "First post! Lorem ipsum?")
   (make-instance 'blog-post
		  :title "Goodbye, world!"
		  :content "Last post. I'm done with this blog.")))

(cl-store:store (list (find-class 'blog-post)
		      *blog-posts*)
		"blog-posts.out")|#

(defvar *blog-posts* (cl-store:restore (second "blog-posts.out")))





;; Routes
;; ------

(defvar *routes*
  '(("/" . index)
    ("/foo" . foo)
    ("/bar" . bar)
    ("/posts" . blog-posts)))






;; Pages
;; -----

(defun index (request)
  (declare (ignorable request))
  (defun last-request ()
    request)
  (format nil "~@{~a ~}"
	      "hello world! This session has id "
	      (hunchentoot:session request)))

(defun foo (request)
  (declare (ignorable request))
  "foo")

(defun bar (request)
  (declare (ignorable request))
  "bar")

(defun four-oh-four (request)
  (declare (ignorable request))
  "404 Not Found")



