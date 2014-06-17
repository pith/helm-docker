;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;                            Helm Docker 
;;
;; This is for now just a work in progress. The goal is to provide UI to access the Docker
;; API via Emacs with Helm.
;; 
;; Configuration:
;;
;; To use this file you have to define three variables. Defining the host to request and
;; the container to work with.
;;
;; (defvar docker-host "myhost.lol")
;; (defvar docker-port "8080")
;; (defvar container-name "grave_ritchie")
;;
(require 'url)
(require 'json)
(require 'helm)

;; Docker ps
(defun dkr/request-containers ()
  "List docker containers"
  (with-current-buffer 
      (url-retrieve-synchronously (format "http://%s:%s/containers/json" docker-host docker-port))
    (goto-char url-http-end-of-headers)
    (json-read)))

;; Extract name from the "docker ps"
(defun dkr/search-containers ()
  "Returns container names form a list of container"
  (mapcar (lambda (container)
	    (elt (cdr (assoc 'Names container)) 0 ))
	  (dkr/get-containers)))

(dkr/search-containers)

;; Format sources for Helm
(defvar helm-source-docker-ps
  "Returns a list of container for Helm"
  '((name . "Docker")
    (candidates . dkr/search-containers)))

(message "%s" helm-source-docker-ps)

;; Actually use Helm
(helm :sources '(helm-source-docker-ps))

;; Docker inspect
(defun dkr/docker-inspect (containerID) 
  "Return low-level information on the container id"
  (with-current-buffer 
      (url-retrieve-synchronously (format "http://%s:%s/containers/%s/json" docker-host docker-port containerID))
    (goto-char url-http-end-of-headers)
    (json-read)))

;; get a container IP from docker inspect
(defun dkr/docker-get-ip (containerID)
  "Return the contrainer IP"
 (cdr (assoc 'IPAddress (assoc 'NetworkSettings (dkr/docker-inspect containerID)))))

(dkr/docker-get-ip container-name)

;; Docker top
(defun dkr/docker-top (containerID)
  "List processes running inside the container id"
  (with-current-buffer 
      (url-retrieve-synchronously (format "http://%s:%s/containers/%s/top" docker-host docker-port containerID))
    (goto-char url-http-end-of-headers)
    (json-read)))

(dkr/docker-top container-name)

;; Docker logs
(defun dkr/docker-logs (containerID)
  "Get stdout and stderr logs from the container id"
  (with-current-buffer 
      (url-retrieve-synchronously (format "http://%s:%s/containers/%s/logs" docker-host docker-port containerID))
    (goto-char url-http-end-of-headers)
    (json-read)))

(dkr/docker-logs container-name)

;; Docker changes
(defun dkr/docker-changes (containerID)
  "Inspect changes on container id's filesystem"
  (with-current-buffer 
      (url-retrieve-synchronously (format "http://%s:%s/containers/%s/changes" docker-host docker-port containerID))
    (goto-char url-http-end-of-headers)
    (json-read)))

(dkr/docker-changes container-name)


