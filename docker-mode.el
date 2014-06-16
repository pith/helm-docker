(require 'url)
(require 'json)
(require 'helm)

(defun dkr/request-containers () 
  (with-current-buffer 
      (url-retrieve-synchronously "http://pith.fr:5555/containers/json?all=1")
    (goto-char url-http-end-of-headers)
    (json-read)))

(defun dkr/search-containers ()
  (mapcar (lambda (container)
	    (elt (cdr (assoc 'Names container)) 0 ))
	  (dkr/get-containers)))

(dkr/search-containers)

(defvar helm-source-docker8
  '((name . "Docker")
    (candidates . dkr/search-containers)))

(message "%s" helm-source-docker8)

(helm :sources '(helm-source-docker8))
