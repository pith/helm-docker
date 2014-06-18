;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                            Helm Docker 
;;
;; This is for now just a work in progress. The goal is to provide UI to access the Docker
;; API via Emacs with Helm.
;;
;; Dependency: docker-client.el (from https://github.com/pith/docker-client)
;;

(require 'url)
(require 'json)
(require 'helm)
(require 'docker-client)

;; Extract name from the "docker ps"
(defun dkr/search-containers ()
  "Returns container names form a list of container"
  (mapcar (lambda (container)
	    (elt (cdr (assoc 'Names container)) 0 ))
	  (dkr/docker-containers)))

;; Format sources for Helm
(defun helm-source-docker-ps ()
  "Returns a list of container for Helm"
  (interactive)
  (helm :sources 
	'((name . "Docker")
	  (candidates . dkr/search-containers))))

;; get a container IP from docker inspect
;; (defun dkr/docker-get-ip (containerID)
;;   "Return the contrainer IP"
;;   (cdr (assoc 'IPAddress (assoc 'NetworkSettings (dkr/docker-inspect containerID)))))

;; (dkr/docker-get-ip container-name)


